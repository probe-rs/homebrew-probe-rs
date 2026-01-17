class ProbeRs < Formula
  desc "A collection of on chip debugging tools to communicate with microchips."
  homepage "https://probe.rs"
  version "0.31.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.31.0/probe-rs-tools-aarch64-apple-darwin.tar.xz"
      sha256 "ade07f1172a5cc17f8d465bc3d2651e7d06212ef79d150d5b10c7a867a192151"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.31.0/probe-rs-tools-x86_64-apple-darwin.tar.xz"
      sha256 "2ddda8dc7531b6896b585c738e54a255a21ff3b790f4089333e0da63b7856bc1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.31.0/probe-rs-tools-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "80e4235c3262bf42e93a024124af37d3ddcf05b16bbc3b5b57eff8623061e385"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.31.0/probe-rs-tools-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "25e6c6792914994cd0b7a6d2f90f28c17ac22a45af8f4424e9a0f44a60ee85f2"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    bin.install "cargo-embed", "cargo-flash", "probe-rs" if OS.mac? && Hardware::CPU.arm?
    bin.install "cargo-embed", "cargo-flash", "probe-rs" if OS.mac? && Hardware::CPU.intel?
    bin.install "cargo-embed", "cargo-flash", "probe-rs" if OS.linux? && Hardware::CPU.arm?
    bin.install "cargo-embed", "cargo-flash", "probe-rs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
