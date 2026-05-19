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
      sha256 "b419c322b4391d606b143c488c6e95387881b27aeaeb5fcdcdb6844f68c399ac"
    end
    on_intel do
      url "https://github.com/1ay1/agentty/releases/download/v#{version}/agentty-linux-x86_64"
      sha256 "51805279af278092322b122bc0e619df28ca76c5c812d0a1a8a52dd263a39269"
    end

    def install
      bin.install Dir["*"].first => "agentty"
      chmod 0755, bin/"agentty"
    end
  end

  on_macos do
    url "https://github.com/1ay1/agentty/archive/refs/tags/v#{version}.tar.gz"
    sha256 "218efa06cad834890dbcc891c609215ae9b6ccbd781dc3449c19bf5208d30079"

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
