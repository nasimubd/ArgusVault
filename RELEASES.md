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

Latest binary artifact index: v1.19.2.
