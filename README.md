# Argus Homebrew Tap

This tap distributes the verified Argus release for macOS and Linux.

## Install

```sh
brew tap nasimubd/argus
brew trust --formula nasimubd/argus/argus
brew install argus
```

For a fresh machine, the fully qualified form performs the tap automatically:

```sh
brew install nasimubd/argus/argus
```

The formula installs `argus` and the `argus-codex` wrapper. Argus uses embedded SQLite, so this tap does not require PostgreSQL, Redis, or a separate SQLite service.

Release archives are mirrored into this public tap so Homebrew can download them without access to the private Argus source repository. The formula version and SHA-256 values are updated with each Argus release.
