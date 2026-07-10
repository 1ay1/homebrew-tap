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
  version "0.2.6"

  on_linux do
    on_arm do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-linux-aarch64"
      sha256 "7efeef8be560fd019d9a5ced57116beb4d99e78d87ff41d0a3b8169d7300b2f8"
    end
    on_intel do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-linux-x86_64"
      sha256 "4a504fc4ab51a420283509f0a8bd0991ea1cd79ae254748eb39e0f207ae302ca"
    end

    def install
      bin.install Dir["*"].first => "agentty"
      chmod 0755, bin/"agentty"
    end
  end

  on_macos do
    on_arm do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-macos-arm64"
      sha256 "a6320e56a5d2136690f4ddf8d9961c1f078fcaee566a4e5bb2afd42445a08e26"
    end
    on_intel do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-macos-x86_64"
      sha256 "04e6231be4361570ec9dcf45fc6bd3df8ac6a86286875b32d09526a633d3ae28"
    end

    def install
      bin.install Dir["*"].first => "agentty"
      chmod 0755, bin/"agentty"
    end
  end

  test do
    assert_match "agentty #{version}", shell_output("#{bin}/agentty --version")
  end
end
