#!/usr/bin/env python3
"""Publish private Argus binaries to ArgusVault as the semantic release bot."""
from __future__ import annotations

import hashlib
import io
import json
import os
import subprocess
import sys
import tarfile
import urllib.request
import zipfile
from pathlib import Path

PUBLIC_REPOSITORY = os.environ.get("ARGUS_PUBLIC_REPOSITORY", "nasimubd/ArgusVault")
PRIVATE_REPOSITORY = os.environ.get("ARGUS_PRIVATE_REPOSITORY", "nasimubd/Argus")
IDENTITY = "semantic-release-bot"
TARGETS = {
    "darwin_amd64": "tar.gz",
    "darwin_arm64": "tar.gz",
    "linux_amd64": "tar.gz",
    "linux_arm64": "tar.gz",
    "windows_amd64": "zip",
    "windows_arm64": "zip",
}


def run(*args: str, input: bytes | None = None) -> str:
    return subprocess.check_output(args, input=input, text=input is None).decode() if input is not None else subprocess.check_output(args, text=True).strip()


def api(path: str) -> dict:
    return json.loads(run("gh", "api", path))


def members(path: Path) -> list[str]:
    if path.suffix == ".zip":
        with zipfile.ZipFile(path) as archive:
            return archive.namelist()
    with tarfile.open(path, "r:gz") as archive:
        return archive.getnames()


def verify_local(dist: Path, version: str) -> list[Path]:
    checksum_file = dist / "checksums.txt"
    checksums = {}
    for line in checksum_file.read_text(encoding="utf-8").splitlines():
        digest, name = line.split(maxsplit=1)
        checksums[name] = digest
    expected = {f"argus_{version}_{target}.{extension}" for target, extension in TARGETS.items()}
    if set(checksums) != expected:
        raise SystemExit("checksums.txt does not cover exactly six release archives")
    archives = []
    for name in sorted(expected):
        path = dist / name
        if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != checksums[name]:
            raise SystemExit(f"checksum failure: {name}")
        expected_member = "argus.exe" if name.endswith(".zip") else "argus"
        if members(path) != [expected_member]:
            raise SystemExit(f"source or extra files found in {name}: {members(path)}")
        archives.append(path)
    return archives


def empty_tag(tag: str) -> None:
    if subprocess.run(["git", "rev-parse", tag], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0:
        raise SystemExit(f"tag already exists: {tag}")
    tree = run("git", "mktree", input=b"")
    env = os.environ | {
        "GIT_AUTHOR_NAME": IDENTITY,
        "GIT_AUTHOR_EMAIL": "semantic-release-bot@martynus.net",
        "GIT_COMMITTER_NAME": IDENTITY,
        "GIT_COMMITTER_EMAIL": "semantic-release-bot@martynus.net",
    }
    commit = subprocess.check_output(["git", "commit-tree", tree, "-m", f"chore(release): index binary artifacts for {tag} [skip ci]"], env=env, text=True).strip()
    subprocess.check_call(["git", "tag", "-a", tag, commit, "-m", f"Argus {tag} binary artifacts"])
    subprocess.check_call(["git", "push", "origin", f"refs/tags/{tag}"])


def main() -> None:
    identity = run("gh", "api", "user", "--jq", ".login")
    if identity != IDENTITY:
        raise SystemExit(f"refusing publication: authenticated GitHub user is {identity!r}, expected {IDENTITY!r}")
    tag = api(f"repos/{PRIVATE_REPOSITORY}/releases/latest")["tag_name"]
    if not tag.startswith("v"):
        raise SystemExit(f"private release has invalid tag: {tag}")
    version = tag[1:]
    dist = Path(os.environ.get("ARGUS_DIST_DIR", "dist")).resolve()
    archives = verify_local(dist, version)
    empty_tag(tag)
    notes = (f"Binary-only distribution derived from private {PRIVATE_REPOSITORY} release {tag}.\n\n"
             "The tag points to an empty artifact commit. GitHub-generated source archives therefore contain no files.\n\n"
             "Publication requires the semantic-release-bot identity and the local binary security audit.")
    subprocess.check_call(["gh", "release", "create", tag, "--repo", PUBLIC_REPOSITORY, "--title", f"Argus {tag} binaries", "--notes", notes, *[str(path) for path in archives], str(dist / "checksums.txt")])
    print(f"published {tag} from {PRIVATE_REPOSITORY} as {IDENTITY}")


if __name__ == "__main__":
    main()
