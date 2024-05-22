class ProbeRs < Formula
  desc "A collection of on chip debugging tools to communicate with microchips."
  homepage "https://probe.rs"
  version "0.24.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.24.0/probe-rs-tools-aarch64-apple-darwin.tar.xz"
      sha256 "7140d9c2c61f8712ba15887f74df0cb40a7b16728ec86d5f45cc93fe96a0a29a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.24.0/probe-rs-tools-x86_64-apple-darwin.tar.xz"
      sha256 "0e35cc92ff34af1b1c72dd444e6ddd57c039ed31c2987e37578864211e843cf1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.24.0/probe-rs-tools-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "95d91ebe08868d5119a698e3268ff60a4d71d72afa26ab207d43c807c729c90a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.24.0/probe-rs-tools-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "21e8d7df39fa0cdc9a0421e0ac2ac5ba81ec295ea11306f26846089f6fe975c0"
    end
  end
  license "MIT OR Apache-2.0"

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "cargo-embed", "cargo-flash", "probe-rs"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cargo-embed", "cargo-flash", "probe-rs"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cargo-embed", "cargo-flash", "probe-rs"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cargo-embed", "cargo-flash", "probe-rs"
    end

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
