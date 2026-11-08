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
  version "0.9.51"

  on_linux do
    on_arm do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-linux-aarch64"
      sha256 "d2c7f9f13d19ede2baeaf452d2acdebbf0ae8c2bd0ca18e7d0eb5236f9fdf9f6"
    end
    on_intel do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-linux-x86_64"
      sha256 "6dda4cb3aaf3474041f63cd0cd02f2ddfab241c269ac2a4a0eff34b554083840"
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
      sha256 "c97dc590c249b8b64f99e3a4612de9711c02bc6cd403944de7f44933a0381e56"
    end
    on_intel do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-macos-x86_64"
      sha256 "d6227feadf1f6d2a1ab80ff96ce8b3b6d91f369df8385117f0037ca03fa7c4a0"
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
