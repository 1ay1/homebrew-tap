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
  homepage "https://github.com/1ay1/agentty"
  license "MIT"
  version "0.4.0"

  on_linux do
    on_arm do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-linux-aarch64"
      sha256 "c723aafa11c32b74cc569ebaa969b58c2a414df6bce3d0ea0941392d53cf1e7d"
    end
    on_intel do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-linux-x86_64"
      sha256 "75b9ca06f86145556625c91225178e75af2fdebe9c0a1f2d92e97e862ac80e86"
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
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-macos-arm64"
      sha256 "7c93bc41fea8e48a0b48d7f3b1f65f535ed3dde9f56e49509f08a76a6e7e8ca0"
    end
    on_intel do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-macos-x86_64"
      sha256 "c56112eec27614ba16544798207abfe5b7bb702dc7043ce2175fa2762d086fbe"
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
