class Argus < Formula
  desc "Go API gateway and session proxy for OpenAI-compatible agent traffic"
  homepage "https://github.com/nasimubd/ArgusVault"
  license "LGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.18.2/argus_1.18.2_darwin_arm64.tar.gz"
      sha256 "887463dd97d468f83cc4554b4fe82b5e587e2fa5d94529b32faa4507dc43b601"
    else
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.18.2/argus_1.18.2_darwin_amd64.tar.gz"
      sha256 "20f884b200b52ff21cfe672919d08c9dde6c77b6fa00c32087bb59b169ef7e39"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.18.2/argus_1.18.2_linux_arm64.tar.gz"
      sha256 "09c3af02f13ace1cb13dd977bca6c10591903c55c1f71b99cb608db28f83d747"
    else
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.18.2/argus_1.18.2_linux_amd64.tar.gz"
      sha256 "a2d2c68e30cce476a54bf0ad48792fd01d97257a8cd4f1497a3c1335f3413a5c"
    end
  end

  def install
    bin.install "argus"
    (bin/"argus-codex").write <<~EOS
      #!/bin/bash
      exec "#{bin}/argus" _codex "$@"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argus --version")
  end
end
