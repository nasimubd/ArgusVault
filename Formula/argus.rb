class Argus < Formula
  desc "Go API gateway and session proxy for OpenAI-compatible agent traffic"
  homepage "https://github.com/nasimubd/ArgusVault"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.19.0/argus_1.19.0_darwin_arm64.tar.gz"
      sha256 "818b754765ae286e263b396e23c288dd09df737435fc26a18e1594d1fc1d85db"
    else
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.19.0/argus_1.19.0_darwin_amd64.tar.gz"
      sha256 "7ae12b01a4025ad988af83b5decf567818ac29635a7f4c399899c5e5d02d0370"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.19.0/argus_1.19.0_linux_arm64.tar.gz"
      sha256 "3886c0d4cd457d2b9bcf10b40a4d0fda0c78e9b34310a725417ba1cf1c8990cb"
    else
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.19.0/argus_1.19.0_linux_amd64.tar.gz"
      sha256 "45edd734905abbb7499d2bbc6a16d3833e77946036bb44bd3b3ca99c62c3805e"
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
