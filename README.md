<div align="center">

# ArgusVault

**Official public binaries and installation hub for Argus**

[![Latest published binary](https://img.shields.io/github/v/release/nasimubd/ArgusVault?display_name=tag&label=latest%20published%20binary&color=2ea44f&logo=github)](https://github.com/nasimubd/ArgusVault/releases/latest)
[![macOS](https://img.shields.io/badge/macOS-Apple%20Silicon%20%7C%20Intel-111827?logo=apple&logoColor=white)](#platforms-and-verification)
[![Linux](https://img.shields.io/badge/Linux-ARM64%20%7C%20x64-FCC624?logo=linux&logoColor=black)](#platforms-and-verification)
[![Windows](https://img.shields.io/badge/Windows-ARM64%20%7C%20x64-0078D4?logo=windows&logoColor=white)](#platforms-and-verification)
[![Homebrew](https://img.shields.io/badge/Homebrew-tap-FBB040?logo=homebrew&logoColor=white)](https://docs.brew.sh/Taps)
[![Go](https://img.shields.io/badge/Go-binaries-00ADD8?logo=go&logoColor=white)](https://go.dev/)
[![SQLite](https://img.shields.io/badge/SQLite-embedded-003B57?logo=sqlite&logoColor=white)](https://www.sqlite.org/)
[![Conventional Commits](https://img.shields.io/badge/Conventional_Commits-release_history-FE5196?logo=conventionalcommits&logoColor=white)](https://www.conventionalcommits.org/)
[![Mise](https://img.shields.io/badge/Mise-release_tooling-111827?logo=mise&logoColor=white)](https://mise.jdx.dev/)
[![GoReleaser](https://img.shields.io/badge/GoReleaser-platform_archives-5E5CE6?logo=go&logoColor=white)](https://goreleaser.com/)
[![LGPL-3.0](https://img.shields.io/badge/License-LGPL--3.0-blue?logo=gnu&logoColor=white)](LICENSE)

[Install](#install) · [Platforms](#platforms-and-verification) · [Get started](#get-started) · [Releases](#releases-and-integrity) · [Support](#support) · [Citation](#cite-argusvault)

</div>

## Argus, for every supported platform

Argus is a Go API gateway and session proxy for OpenAI-compatible agent traffic. **ArgusVault is the public source of truth for its downloadable releases**: macOS, Linux, and Windows archives, SHA-256 checksums, installation scripts, and a Homebrew formula. The application source is in a separate private repository. Source access is not required to install a published binary.

The version badge above reads the latest release **published with binaries in this repository**. It advances when a new GitHub release is published; the README does not hard-code the current production version.

| In this repository | Purpose |
| --- | --- |
| [Releases](https://github.com/nasimubd/ArgusVault/releases) | Six OS and architecture archives plus `checksums.txt` per version |
| [`scripts/install.sh`](scripts/install.sh) | Checksum-verified macOS and Linux installer |
| [`scripts/install.ps1`](scripts/install.ps1) | Checksum-verified Windows installer |
| [`Formula/argus.rb`](Formula/argus.rb) | Homebrew formula for macOS and Linux |

## Install

### macOS and Linux: Homebrew

```sh
brew tap --custom-remote nasimubd/argus https://github.com/nasimubd/ArgusVault.git
brew install nasimubd/argus/argus
```

This installs `argus` and `argus-codex`. The explicit tap URL is required because this repository is named `ArgusVault`, not `homebrew-argus`. Homebrew's [custom remote tap form](https://docs.brew.sh/Taps#the-brew-tap-command) supports this name. The qualified formula name selects Argus rather than the unrelated `argus` formula in Homebrew/core.

To update a Homebrew installation:

```sh
brew update
brew upgrade nasimubd/argus/argus
```

### macOS and Linux: installation script

```sh
curl --fail --silent --show-error --location https://raw.githubusercontent.com/nasimubd/ArgusVault/main/scripts/install.sh | bash
```

The script detects macOS or Linux and Intel or ARM, downloads the matching archive and `checksums.txt` from this public repository, checks SHA-256, installs `argus` and `argus-codex`, and runs `argus --version`. If the selected installation directory is outside your `PATH`, the script prints the directory to add. Set `ARGUS_INSTALL_DIR="$HOME/.local/bin"` before running the script to choose that directory explicitly. Re-run the command to install a newer release.

### Windows: PowerShell

```powershell
irm https://raw.githubusercontent.com/nasimubd/ArgusVault/main/scripts/install.ps1 | iex
```

The script selects Windows x64 or ARM64, verifies the archive against `checksums.txt`, installs `argus.exe` and `argus-codex.bat` under `%LOCALAPPDATA%\Argus\bin`, adds that directory to the user `PATH`, and runs `argus.exe --version`. Re-run the command to install a newer release.

### Manual download: any supported OS

Download the archive for your platform and `checksums.txt` from the [latest release](https://github.com/nasimubd/ArgusVault/releases/latest). Verify the archive's SHA-256 digest against its entry in `checksums.txt` before extracting it.

| OS | CPU | Archive name pattern |
| --- | --- | --- |
| macOS | Apple Silicon | `argus_<version>_darwin_arm64.tar.gz` |
| macOS | Intel | `argus_<version>_darwin_amd64.tar.gz` |
| Linux | ARM64 | `argus_<version>_linux_arm64.tar.gz` |
| Linux | x64 | `argus_<version>_linux_amd64.tar.gz` |
| Windows | ARM64 | `argus_<version>_windows_arm64.zip` |
| Windows | x64 | `argus_<version>_windows_amd64.zip` |

## Platforms and verification

All six archives are present in the [latest published release](https://github.com/nasimubd/ArgusVault/releases/latest). **Published** means that the archive is available; it does not imply that installation has been exercised on that OS and CPU combination.

| OS and CPU | Available installation paths | Verified version and scope | Field status |
| --- | --- | --- | --- |
| macOS Apple Silicon | Homebrew, script, archive | v1.18.2: installer, binary launch, and `argus --version` on macOS ARM64 | Local smoke test; broader use not yet battle-tested |
| macOS Intel | Homebrew, script, archive | Archive published; installation not tested on Intel hardware | Not yet battle-tested |
| Linux ARM64 | Homebrew, script, archive | Archive published; installation not tested on Linux ARM64 hardware | Not yet battle-tested |
| Linux x64 | Homebrew, script, archive | Archive published; installation not tested on Linux x64 hardware | Not yet battle-tested |
| Windows ARM64 | PowerShell, archive | Archive published; installer not tested on Windows ARM64 hardware | Not yet battle-tested |
| Windows x64 | PowerShell, archive | Archive published; installer not tested on Windows x64 hardware | Not yet battle-tested |

The macOS Apple Silicon smoke test covers installation and CLI startup, not sustained production traffic. This table is updated when an installation path is actually exercised; release availability alone is never marked as tested.

## Get started

```sh
argus --version
argus login
argus-codex
```

`argus login` starts browser account setup and launches the local gateway afterward; no `serve` command is needed. Run it again to add another account. `argus-codex` launches the separately installed Codex CLI with the Argus endpoint configured. Argus includes embedded SQLite, so no PostgreSQL, Redis, or separate SQLite server is required.

## Releases and integrity

Each [ArgusVault release](https://github.com/nasimubd/ArgusVault/releases) contains matching platform archives and `checksums.txt`. The formula pins the archive digest for every supported Homebrew platform. The scripts compare downloaded archive bytes with the release checksum before installing. A checksum detects mismatched or corrupted downloads; it is not a substitute for independent publisher signatures.

## Support

Please [open an issue in ArgusVault](https://github.com/nasimubd/ArgusVault/issues/new/choose) for installation failures, missing platform support, broken downloads, checksum mismatches, or runtime problems. Include your OS, CPU architecture, Argus version from `argus --version`, installation command, and the error output. The repository maintainer or owner will triage reports according to impact and available time.

## Source access

The Argus application source is private. Authorized contributors can clone it with:

```sh
git clone https://github.com/nasimubd/Argus.git
```

If you do not already have access, contact **[MD NASIM](https://github.com/nasimubd)** at **[nasimubd21@gmail.com](mailto:nasimubd21@gmail.com)** to request it. Without permission, GitHub will not allow the clone. This public vault remains available for binary installation.

## Sponsor

<a href="https://epatner.com/"><img src="assets/sponsors/epatner/logo-white.svg" alt="ePATNER" width="420"></a>

Thanks to [ePATNER](https://epatner.com/) for supporting Argus.

## Cite ArgusVault

Use GitHub's **Cite this repository** menu, backed by [`CITATION.cff`](CITATION.cff), or copy this BibTeX entry:

```bibtex
@software{argusvault_2026,
  title = {ArgusVault: Cross-platform binaries and installation for Argus},
  author = {MD NASIM},
  year = {2026},
  url = {https://github.com/nasimubd/ArgusVault.git}
}
```

Argus is distributed under the [GNU Lesser General Public License v3.0](LICENSE).
