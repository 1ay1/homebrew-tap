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
  version "0.2.11"

  on_linux do
    on_arm do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-linux-aarch64"
      sha256 "f0d9dd94676eb15411c9410572e418bc1eca11e26c3c8116065efce618fb5e8e"
    end
    on_intel do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-linux-x86_64"
      sha256 "8c9b1cbbdeea0efbda18a8520c545cd4759ef5cb96a31ec5967d24bf8b44db29"
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
      sha256 "ee9de6f124e4dbdab3fe26e1d91fc1f8fd5352bd57e9cfb4ce09e800a9beb637"
    end
    on_intel do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-macos-x86_64"
      sha256 "e188032cdbcd311f11ac1683791fe8cd97b4f6f72cf0c7fb0a75951a701b5ca8"
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
