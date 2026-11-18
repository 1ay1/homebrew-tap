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
  version "0.9.58"

  on_linux do
    on_arm do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-linux-aarch64"
      sha256 "e85f4cf05bd3a4a63b7845454d42b2023732ba41185c201adc648f2ecf88f602"
    end
    on_intel do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-linux-x86_64"
      sha256 "e05788adc56291fa123fc9461cf3967564f87c146858b10730235bc2bf058014"
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
      sha256 "154a434294e1f3d5748834722845a4b5d7eee5d36ecc24319d7d9d7a3216207a"
    end
    on_intel do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-macos-x86_64"
      sha256 "7578cab219ce5484e13acd2cb66409dcee2fa9069e95eb8d65c2edcf76add0aa"
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
