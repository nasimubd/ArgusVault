class Argus < Formula
  desc "Go API gateway and session proxy for OpenAI-compatible agent traffic"
  homepage "https://github.com/nasimubd/Argus"
  license "LGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/homebrew-argus/releases/download/v1.18.1/argus_1.18.1_darwin_arm64.tar.gz"
      sha256 "707aea0bccf05c280c8c6a6ad58f44757169569fb22ce12142edb55bdf4e36e7"
    else
      url "https://github.com/nasimubd/homebrew-argus/releases/download/v1.18.1/argus_1.18.1_darwin_amd64.tar.gz"
      sha256 "89cca7c83d56a5ea0db63d6ba430fe38bf62d418ca40ad59abbe0097379d762c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/homebrew-argus/releases/download/v1.18.1/argus_1.18.1_linux_arm64.tar.gz"
      sha256 "2c1910368eb91db3240f3d17edfcd519e8634cb1143edeaff8f88a2fff8b5616"
    else
      url "https://github.com/nasimubd/homebrew-argus/releases/download/v1.18.1/argus_1.18.1_linux_amd64.tar.gz"
      sha256 "cb180fdbbc5dd84d32403afdd36c0eb22ea1b5e3fec16bfa818592842c7c0102"
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
