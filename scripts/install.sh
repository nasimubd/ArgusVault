#!/usr/bin/env bash
set -euo pipefail

repo="${ARGUS_REPOSITORY:-nasimubd/ArgusVault}"
api="https://api.github.com/repos/${repo}/releases/latest"
api_json="$(curl --fail --silent --show-error --location --retry 3 "$api")"
tag="$(printf '%s' "$api_json" | sed -nE 's/.*"tag_name"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' | head -n1)"
if [[ -z "$tag" ]]; then echo "latest release tag was not found" >&2; exit 1; fi
version="${tag#v}"
case "$(uname -s)" in
  Linux) os=linux ;;
  Darwin) os=darwin ;;
  *) echo "unsupported operating system" >&2; exit 1 ;;
esac
case "$(uname -m)" in
  x86_64|amd64) arch=amd64 ;;
  arm64|aarch64) arch=arm64 ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac
asset="argus_${version}_${os}_${arch}.tar.gz"
base="https://github.com/${repo}/releases/download/${tag}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
curl --fail --silent --show-error --location --retry 3 "$base/$asset" -o "$tmp/$asset"
curl --fail --silent --show-error --location --retry 3 "$base/checksums.txt" -o "$tmp/checksums.txt"
expected="$(awk -v name="$asset" '$2 == name { print $1; exit }' "$tmp/checksums.txt")"
if [[ ! "$expected" =~ ^[[:xdigit:]]{64}$ ]]; then echo "checksum entry for $asset was not found" >&2; exit 1; fi
if command -v sha256sum >/dev/null 2>&1; then actual="$(sha256sum "$tmp/$asset" | awk '{print $1}')"; else actual="$(shasum -a 256 "$tmp/$asset" | awk '{print $1}')"; fi
if [[ "${actual,,}" != "${expected,,}" ]]; then echo "checksum verification failed" >&2; exit 1; fi
tar -xzf "$tmp/$asset" -C "$tmp"
if [[ ! -x "$tmp/argus" ]]; then chmod +x "$tmp/argus"; fi
if [[ -n "${ARGUS_INSTALL_DIR:-}" ]]; then
  install_dir="$ARGUS_INSTALL_DIR"
elif [[ -w /usr/local/bin ]]; then
  install_dir=/usr/local/bin
else
  install_dir="$HOME/.local/bin"
fi
mkdir -p "$install_dir"
if [[ -w "$install_dir" ]]; then install -m 0755 "$tmp/argus" "$install_dir/argus"; else sudo install -m 0755 "$tmp/argus" "$install_dir/argus"; fi
cat > "$tmp/argus-codex" <<'WRAPPER'
#!/bin/bash
exec argus _codex "$@"
WRAPPER
if [[ -w "$install_dir" ]]; then install -m 0755 "$tmp/argus-codex" "$install_dir/argus-codex"; else sudo install -m 0755 "$tmp/argus-codex" "$install_dir/argus-codex"; fi
"$install_dir/argus" --version
echo "installed Argus ${tag} in ${install_dir}"
if [[ "$(uname -s)" == Darwin && -n "${HOME:-}" && -n "${USER:-}" ]]; then
  launch_agents_dir="$HOME/Library/LaunchAgents"
  launch_agent="$launch_agents_dir/com.epatner.argus.plist"
  mkdir -p "$launch_agents_dir" "$HOME/.argus"
  cat >"$launch_agent" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.epatner.argus</string>
  <key>ProgramArguments</key>
  <array>
    <string>${install_dir}/argus</string>
    <string>serve</string>
  </array>
  <key>WorkingDirectory</key>
  <string>${HOME}/.argus</string>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>ThrottleInterval</key>
  <integer>10</integer>
  <key>StandardOutPath</key>
  <string>${HOME}/.argus/argus.log</string>
  <key>StandardErrorPath</key>
  <string>${HOME}/.argus/argus.log</string>
</dict>
</plist>
PLIST
  plutil -lint "$launch_agent"
  uid="$(id -u)"
  launchctl bootout "gui/$uid/com.epatner.argus" 2>/dev/null || true
  launchctl bootstrap "gui/$uid" "$launch_agent"
  launchctl kickstart -k "gui/$uid/com.epatner.argus"
  echo "configured macOS launch agent at $launch_agent"
fi
case ":$PATH:" in
  *":$install_dir:"*) ;;
  *) echo "Add ${install_dir} to PATH to use argus and argus-codex in new terminals." ;;
esac
