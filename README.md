<div align="center">

# ArgusVault

**The public release vault and Homebrew tap for Argus**

[![Latest release](https://img.shields.io/github/v/release/nasimubd/homebrew-argus?display_name=tag&logo=github)](https://github.com/nasimubd/homebrew-argus/releases/latest)
[![Homebrew](https://img.shields.io/badge/Homebrew-tap-FBB040?logo=homebrew&logoColor=white)](https://docs.brew.sh/Taps)
[![Go](https://img.shields.io/badge/Go-binaries-00ADD8?logo=go&logoColor=white)](https://go.dev/)
[![SQLite](https://img.shields.io/badge/SQLite-embedded-003B57?logo=sqlite&logoColor=white)](https://www.sqlite.org/)
[![Conventional Commits](https://img.shields.io/badge/Conventional_Commits-release_history-FE5196?logo=conventionalcommits&logoColor=white)](https://www.conventionalcommits.org/)
[![Mise](https://img.shields.io/badge/Mise-release_tooling-111827?logo=mise&logoColor=white)](https://mise.jdx.dev/)
[![GoReleaser](https://img.shields.io/badge/GoReleaser-platform_archives-5E5CE6?logo=go&logoColor=white)](https://goreleaser.com/)
[![LGPL-3.0](https://img.shields.io/badge/License-LGPL--3.0-blue?logo=gnu&logoColor=white)](LICENSE)

[Install](#install) · [Get started](#get-started) · [Releases](#releases-and-integrity) · [Source access](#source-access) · [Cite](#cite-argusvault)

</div>

## What is ArgusVault?

Argus is a Go API gateway and session proxy for OpenAI-compatible agent traffic. This public repository distributes its platform binaries, SHA-256 checksums, installation scripts, and Homebrew formula. The application source lives in a separate private repository; you do **not** need source access to install a published binary.

| Here | Purpose |
| --- | --- |
| [`Formula/argus.rb`](Formula/argus.rb) | Homebrew formula for macOS and Linux |
| [`scripts/install.sh`](scripts/install.sh) | Checksum-verified macOS and Linux installer |
| [`scripts/install.ps1`](scripts/install.ps1) | Checksum-verified Windows installer |
| [Releases](https://github.com/nasimubd/homebrew-argus/releases) | Six platform archives and `checksums.txt` per version |

## Install

### Homebrew · macOS and Linux

```sh
brew install nasimubd/argus/argus
```

This installs `argus` and the `argus-codex` command. Use the **fully qualified** name: Homebrew/core also has an unrelated formula called `argus`. Homebrew [recommends direct installation from a tap](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap#installing), and the qualified command [trusts only this formula](https://docs.brew.sh/Tap-Trust#installing-from-a-tap). The repository retains the `homebrew-argus` name so the working `nasimubd/argus/argus` tap path remains stable.

To update a Homebrew installation:

```sh
brew update
brew upgrade nasimubd/argus/argus
```

### Installation script · macOS and Linux

```sh
curl --fail --silent --show-error --location https://raw.githubusercontent.com/nasimubd/homebrew-argus/main/scripts/install.sh | bash
```

The script detects macOS or Linux and Intel or ARM, downloads the matching archive and `checksums.txt` from this public repository, checks SHA-256, installs `argus` and `argus-codex`, and runs `argus --version`. If the selected installation directory is outside your `PATH`, the script prints the directory to add. Set `ARGUS_INSTALL_DIR="$HOME/.local/bin"` before running the script to choose that directory explicitly. Re-run the command to install a newer release.

### PowerShell · Windows

```powershell
irm https://raw.githubusercontent.com/nasimubd/homebrew-argus/main/scripts/install.ps1 | iex
```

The script selects Windows x64 or ARM64, verifies the archive against `checksums.txt`, installs `argus.exe` and `argus-codex.bat` under `%LOCALAPPDATA%\Argus\bin`, adds that directory to the user `PATH`, and runs `argus.exe --version`. Re-run the command to install a newer release.

### Manual archive download

Download the archive for your platform and `checksums.txt` from the [latest release](https://github.com/nasimubd/homebrew-argus/releases/latest). Verify the archive's SHA-256 digest against its entry in `checksums.txt` before extracting it.

| Platform | Archive name pattern |
| --- | --- |
| macOS, Apple Silicon | `argus_<version>_darwin_arm64.tar.gz` |
| macOS, Intel | `argus_<version>_darwin_amd64.tar.gz` |
| Linux, ARM64 | `argus_<version>_linux_arm64.tar.gz` |
| Linux, x64 | `argus_<version>_linux_amd64.tar.gz` |
| Windows, ARM64 | `argus_<version>_windows_arm64.zip` |
| Windows, x64 | `argus_<version>_windows_amd64.zip` |

## Get started

```sh
argus --version
argus login
argus-codex
```

`argus login` starts browser account setup and launches the local gateway afterward; no `serve` command is needed. Run it again to add another account. `argus-codex` launches the separately installed Codex CLI with the Argus endpoint configured. Argus includes embedded SQLite, so no PostgreSQL, Redis, or separate SQLite server is required.

## Releases and integrity

Each [ArgusVault release](https://github.com/nasimubd/homebrew-argus/releases) mirrors the matching Argus version with platform archives and `checksums.txt`. The formula pins the archive digest for every supported Homebrew platform. The scripts compare downloaded archive bytes with the release checksum before installing. A checksum detects mismatched or corrupted downloads; it is not a substitute for independent publisher signatures.

## Source access

The Argus application source is private. Authorized contributors can clone it with:

```sh
git clone https://github.com/nasimubd/Argus.git
```

If you do not already have access, contact **[MD NASIM](https://github.com/nasimubd)** at **[nasimubd21@gmail.com](mailto:nasimubd21@gmail.com)** to request it. Without permission, GitHub will not allow the clone. This public vault remains available for binary installation.

## Sponsor

<a href="https://epatner.com/"><img src="assets/sponsors/epatner/logo-white.svg" alt="ePATNER sponsor logo on a white background" width="320"></a>

Thanks to [ePATNER](https://epatner.com/) for supporting Argus. The white background preserves the supplied logo's contrast in light and dark themes.

## Cite ArgusVault

Use GitHub's **Cite this repository** menu, backed by [`CITATION.cff`](CITATION.cff), or copy this BibTeX entry:

```bibtex
@software{argusvault_2026,
  title = {ArgusVault: Public binaries and Homebrew distribution for Argus},
  author = {MD NASIM},
  year = {2026},
  url = {https://github.com/nasimubd/homebrew-argus}
}
```

Argus is distributed under the [GNU Lesser General Public License v3.0](LICENSE).
