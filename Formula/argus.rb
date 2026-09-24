class Argus < Formula
  desc "Go API gateway and session proxy for OpenAI-compatible agent traffic"
  homepage "https://github.com/nasimubd/ArgusVault"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.24.0/argus_1.24.0_darwin_arm64.tar.gz"
      sha256 "c4dbf206b56ff3640a274b393365b8ca590c40fe0796929129f5b8e625c30e04"
    else
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.24.0/argus_1.24.0_darwin_amd64.tar.gz"
      sha256 "78ec95a1c5da710df40c8e3128957f24cb173a435736b24507dbb86d763ddef4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.24.0/argus_1.24.0_linux_arm64.tar.gz"
      sha256 "20a87e8e3628a0df75fd80fbd7c85dc8d0fd83bbff9acacc2ba8f6f01635ed86"
    else
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.24.0/argus_1.24.0_linux_amd64.tar.gz"
      sha256 "9fcaf193ff3d65409dbeb0a0952d82bac2379b7c077e22888209b4d788526bf7"
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
