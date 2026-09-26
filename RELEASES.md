# Binary release convention

ArgusVault distributes Argus executables for supported operating systems. GitHub
creates `Source code (zip)` and `Source code (tar.gz)` links for every release
tag. Those generated archives must not contain the repository metadata tree.

For each binary release, create the release tag on an empty artifact commit and
attach only the six platform archives and `checksums.txt`. Keep documentation,
formulas, and license metadata on `main`; do not use a normal `main` commit as
the public binary release tag.

The empty tag is an artifact index, not a source distribution. The private
Argus repository remains the source of truth for builds.

Latest binary artifact index: v1.24.4.

## Publishing from the private source release

Run the publisher from this checkout after building `dist/` locally:

```sh
ARGUS_DIST_DIR=/path/to/Argus/dist python3 scripts/release/publish_from_private.py
```

The publisher derives the version from the latest private Argus release, checks
all six archives and checksums before creating an empty artifact tag, and records
the artifact index with the semantic-release-bot identity. Do not tag a normal
source commit in this repository: public binary tag source archives must be empty.
