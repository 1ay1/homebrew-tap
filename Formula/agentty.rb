# typed: false
# frozen_string_literal: true

# Homebrew formula for agentty.
#
# Install:
#   brew tap 1ay1/tap
#   brew install agentty
#
# On Linux this downloads the pre-built static binary from the GitHub
# release. On macOS it builds from source — fast (~1 min) and reproducible
# given the C++26 toolchain Homebrew ships.
#
# After every release: bump `version`, regenerate sha256s with
#   `shasum -a 256 dist/agentty-linux-{x86_64,aarch64}`
# (release.sh emits these automatically).
class Agentty < Formula
  desc "Blazing-fast Claude in your terminal — sandboxed, airgap-capable, single static binary"
  homepage "https://github.com/1ay1/agentty"
  license "MIT"
  version "0.1.0"

  on_linux do
    on_arm do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-linux-aarch64"
      sha256 "73c487b5820d24efe19abb119f54d94eaee9b94b9caad4bdced61bba4be629b6"
    end
    on_intel do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-linux-x86_64"
      sha256 "b559908ea7b7acf3ff10647e8b102a84048641566f0595f0c2356949601e55a0"
    end

    def install
      bin.install Dir["*"].first => "agentty"
      chmod 0755, bin/"agentty"
    end
  end

  on_macos do
    url "https://github.com/1ay1/agentty/archive/refs/tags/v#{version}.tar.gz"
    sha256 "9b1680c3b640e28dcb7e99304e4f372b5e072189a3afb8da0c981dca4a72e1f0"

    depends_on "cmake" => :build
    depends_on "ninja" => :build
    depends_on "openssl@3"

    def install
      system "cmake", "-S", ".", "-B", "build", "-GNinja",
                      "-DCMAKE_BUILD_TYPE=Release",
                      "-DAGENTTY_STANDALONE=ON",
                      *std_cmake_args
      system "cmake", "--build", "build"
      bin.install "build/agentty"
    end
  end

  test do
    assert_match "agentty #{version}", shell_output("#{bin}/agentty --version")
  end
end
