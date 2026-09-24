class Argus < Formula
  desc "Go API gateway and session proxy for OpenAI-compatible agent traffic"
  homepage "https://github.com/nasimubd/ArgusVault"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.19.1/argus_1.19.1_darwin_arm64.tar.gz"
      sha256 "07106d8a3723dff0cda6e6e69531dad41f8b5c445901952db54abe248e292284"
    else
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.19.1/argus_1.19.1_darwin_amd64.tar.gz"
      sha256 "d15499c2a58d12c841e0e004591201003d14338f3df834fcfbe1e95fab12bcb9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.19.1/argus_1.19.1_linux_arm64.tar.gz"
      sha256 "d18a5a11db1833acfb6c0bc602d57f9a12229f4b13bb7dc08a4f9e0efb8aae59"
    else
      url "https://github.com/nasimubd/ArgusVault/releases/download/v1.19.1/argus_1.19.1_linux_amd64.tar.gz"
      sha256 "8f13f3d6da90bfc00c05bdb22a4e50c0339cfc03ecf567f1674d5beaac56546a"
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
