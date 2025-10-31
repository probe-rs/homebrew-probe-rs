class Rtthost < Formula
  desc "RTT (Real-Time Transfer) client"
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.30.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.30.0/rtthost-aarch64-apple-darwin.tar.xz"
      sha256 "6dcc597d4d66589ec0da4fc3abf525d27401871c3850df988ae3708c84acae9c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.30.0/rtthost-x86_64-apple-darwin.tar.xz"
      sha256 "41d150c4973e9b8b4e00f81e87c3b72320c4df4869203b433687c46c543e2e33"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.30.0/rtthost-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ec0ce757c62df577ca797c203caf6b01f26bd299375181074805693317582c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.30.0/rtthost-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "038c416e53356cc941f799c5fdcc97aff663d8d336ed581620fb575eb2c7c824"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "rtthost" if OS.mac? && Hardware::CPU.arm?
    bin.install "rtthost" if OS.mac? && Hardware::CPU.intel?
    bin.install "rtthost" if OS.linux? && Hardware::CPU.arm?
    bin.install "rtthost" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
