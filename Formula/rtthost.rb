class Rtthost < Formula
  desc "RTT (Real-Time Transfer) client"
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.31.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.31.0/rtthost-aarch64-apple-darwin.tar.xz"
      sha256 "65acc8a02e7786fbd2fd8e85d7be9ca3ff9d51917a9276878d56bd288df6cf2e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.31.0/rtthost-x86_64-apple-darwin.tar.xz"
      sha256 "67372df51c52218e504d441314ccf4e340a8f8f3d6d5ce230af64f2b95d2419b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.31.0/rtthost-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "998c02d3055533fed9293caa2423c8e64c0a1f2c3e494b6613fe5723518f1f9c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.31.0/rtthost-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "484f52740e95a2d86fa6859250def273cddca343ceaf30367f4103ef7b5cc769"
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
