class Rtthost < Formula
  desc "RTT (Real-Time Transfer) client"
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.24.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.24.0/rtthost-aarch64-apple-darwin.tar.xz"
      sha256 "e6d5a4e766ce819dd27b6b9dc796a42de083b252aa15d852552ace7f813564b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.24.0/rtthost-x86_64-apple-darwin.tar.xz"
      sha256 "7fdb98eee047daf6d4020d63e9970784ab90d3dac99504bd5df2556fb742e6c0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.24.0/rtthost-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ce3db042937b768169e6e9e0871d679c9e35a28e79a74a3febe685802fb26bb8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.24.0/rtthost-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e2f8221bf516a6f6f4d863766e13910da28c31bf9b76f8a74284982fa8bdfb92"
    end
  end
  license "MIT"

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rtthost"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rtthost"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rtthost"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rtthost"
    end

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
