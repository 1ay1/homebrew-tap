# typed: false
# frozen_string_literal: true

# Homebrew formula for agentty.
#
# Install:
#   brew tap 1ay1/tap
#   brew install agentty
#
# Downloads the pre-built static binary from the GitHub release on both
# Linux and macOS (CI publishes agentty-{linux,macos}-{arch}). No source
# build: agentty needs C++26 (GCC), which AppleClang doesn't advertise.
#
# After every release: bump `version`, regenerate sha256s from the release
# SHA256SUMS (release.sh emits these automatically).
class Agentty < Formula
  desc "Blazing-fast Claude in your terminal — sandboxed, airgap-capable, single static binary"
  homepage "https://github.com/agentty-org/agentty"
  license "MIT"
  version "0.9.52"

  on_linux do
    on_arm do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-linux-aarch64"
      sha256 "b38cd88944ab508049301fb12c13f17c8dee94ecb7b8484da0c7020b7b470ca4"
    end
    on_intel do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-linux-x86_64"
      sha256 "17f2c458f781f85c7948e5bf424bd2a3219c2dfabbf25ce0a02a0713b9554c2c"
    end

    def install
      # The release asset is the bare static binary; Homebrew downloads it to
      # the staging dir under the URL's basename. Install it by that exact name
      # so a stray file in the dir can never be picked instead.
      bin.install Dir["agentty-*"].first => "agentty"
      chmod 0755, bin/"agentty"
    end
  end

  on_macos do
    on_arm do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-macos-arm64"
      sha256 "bea397f67c65443903b271be88130460b775530f5bf2fd1bde0e5fe342b3db85"
    end
    on_intel do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-macos-x86_64"
      sha256 "f185bd38cc4bb8cc10fd84199c8f172ddbbc3f1a790f136889867edda36f45d3"
    end

    def install
      bin.install Dir["agentty-*"].first => "agentty"
      chmod 0755, bin/"agentty"
    end
  end

  def caveats
    <<~EOS
      agentty is installed. Get started with:
        agentty

      It talks to Claude via your ANTHROPIC_API_KEY (or `agentty` will prompt
      you to sign in on first run). Docs: https://agentty.org/docs
    EOS
  end

  test do
    assert_match "agentty #{version}", shell_output("#{bin}/agentty --version")
  end
end
