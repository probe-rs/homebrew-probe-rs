class Rtthost < Formula
  desc "RTT (Real-Time Transfer) client"
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.25.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.25.0/rtthost-aarch64-apple-darwin.tar.xz"
      sha256 "322168ed28d6a779e760b2346ce4f727b5efd7c82d738f46f580bcc534ce755e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.25.0/rtthost-x86_64-apple-darwin.tar.xz"
      sha256 "eae9eac3866d2a11c65a68b969ea0413dd67f5de8616f86708995c2a41b2f2eb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.25.0/rtthost-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7094c247e9a30828b951bfb5b58436e39704c1f51173a9b28fad6c62a2c36ef6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.25.0/rtthost-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e6e7ada1ccfc79e867f5cb0c48290a38136488b2681cddef5f8c64f511407dea"
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
