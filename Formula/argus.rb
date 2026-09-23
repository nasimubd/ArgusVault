class Argus < Formula
  desc "Go API gateway and session proxy for OpenAI-compatible agent traffic"
  homepage "https://github.com/nasimubd/Argus"
  license "LGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/Argus/releases/download/v1.18.0/argus_1.18.0_darwin_arm64.tar.gz"
      sha256 "4b04af64d01948f599b6c359f0430c6f4b31aec92026fdeb2028c851a92ddda1"
    else
      url "https://github.com/nasimubd/Argus/releases/download/v1.18.0/argus_1.18.0_darwin_amd64.tar.gz"
      sha256 "3bad7b16e5dec3f25625f8d75fb0870cf393ef73500927401972024d37769ee5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/Argus/releases/download/v1.18.0/argus_1.18.0_linux_arm64.tar.gz"
      sha256 "8ffaff274aac60bb4a2c4d0f6ff2f1d39be9f6db16f306dca95dd1115844e906"
    else
      url "https://github.com/nasimubd/Argus/releases/download/v1.18.0/argus_1.18.0_linux_amd64.tar.gz"
      sha256 "0ffea639d91c83df7d0d2d9dc1ab70f3d1a8e04869c10678739ba7a5d05a44e8"
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
