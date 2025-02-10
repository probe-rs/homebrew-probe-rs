class Rtthost < Formula
  desc "RTT (Real-Time Transfer) client"
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.27.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.27.0/rtthost-aarch64-apple-darwin.tar.xz"
      sha256 "33ec8daf81d24b2809ecda364bd81e7d99f56153ef391b042cb427eb90d6a83a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.27.0/rtthost-x86_64-apple-darwin.tar.xz"
      sha256 "4e8fd037ab76be7994a91e9c0fae87d1ada9b06385a0eff822ae9feee0373d00"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.27.0/rtthost-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6eb5ccdbdbfbfec47be1b2945ec7615575769519387bdd75211d41a669fb8ae8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.27.0/rtthost-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0435f60b91067c9e775cf53a0cde68d470f235aaef4a2d82a929ca2daacf3f36"
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
