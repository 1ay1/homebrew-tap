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
  version "0.9.38"

  on_linux do
    on_arm do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-linux-aarch64"
      sha256 "fc16af4888c10763e2a646299559cf2cd3f6672ea7b67cfedfb48eacdba025ec"
    end
    on_intel do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-linux-x86_64"
      sha256 "b686cf457777dc5e95aa1ce11e74ae3884f3f3d5d58de8eb6cde66fd12da929d"
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
      sha256 "1afc16684ef19129ecc4054611d326e1dbe685a10e8ac547734be970336c70f9"
    end
    on_intel do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-macos-x86_64"
      sha256 "7b0db181667ccacd28c773fe6ddd885409b1674451dc22cfe2e1ba0f879740f9"
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
