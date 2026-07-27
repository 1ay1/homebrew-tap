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
  version "0.2.10"

  on_linux do
    on_arm do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-linux-aarch64"
      sha256 "b13ecbcc12a473da0adf429cd838aaa47fbf617cb58e78011ed4d74887cee295"
    end
    on_intel do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-linux-x86_64"
      sha256 "7f4f8b4972fa925d452c01b3ece500464b3a4e44da1f75900a2e767779f2677a"
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
      sha256 "82866e5847e491fb94f183b4256feb21d273a12a5f65488687eced49a984a284"
    end
    on_intel do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-macos-x86_64"
      sha256 "3116cf70a9cbdc5d681b7626bb682b489c8844bcc388b9f9a6763027a326d50e"
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
