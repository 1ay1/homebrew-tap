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
  version "0.9.47"

  on_linux do
    on_arm do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-linux-aarch64"
      sha256 "7bd4756dc4127de6a3f58897c6abda1f18669367b740c84e95eea07a26217bdc"
    end
    on_intel do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-linux-x86_64"
      sha256 "0559e32ab1b7878618503ab6b26968d664032edd5f982ffc7cc27f2459ad3ba2"
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
      sha256 "a52a5d5fb767209b3aa91f45f79b59eb84d13529c4ac2adad780ba213b2d6e76"
    end
    on_intel do
      url "https://github.com/agentty-org/agentty/releases/download/v#{version}/agentty-macos-x86_64"
      sha256 "e704ea0ddd91aed59841dc8d63f956b2e895edbfe3769e67a791330727fb3f76"
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
