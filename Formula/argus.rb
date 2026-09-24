class Argus < Formula
  desc "Go API gateway and session proxy for OpenAI-compatible agent traffic"
  homepage "https://github.com/nasimubd/ArgusVault"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.19.2/argus_1.19.2_darwin_arm64.tar.gz"
      sha256 "4507ee9c06ec6fe7de672cac93a9b442f7c5a37a12d771af0b271de1e41acce7"
    else
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.19.2/argus_1.19.2_darwin_amd64.tar.gz"
      sha256 "0fc0b731524df57a917458e9f35901ecd0b2e29d22c211bafcb3a5c257a7f420"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.19.2/argus_1.19.2_linux_arm64.tar.gz"
      sha256 "8ab5068f90d9c870f3018d8bc570f503c73073179da926fe80df1df17685d78d"
    else
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.19.2/argus_1.19.2_linux_amd64.tar.gz"
      sha256 "16b0e01a5909d52e462d8f002b75918956ebcdeb2d4f36c9ef937315633d4595"
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
