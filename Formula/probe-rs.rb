class ProbeRs < Formula
  desc "A collection of on chip debugging tools to communicate with microchips."
  homepage "https://probe.rs"
  version "0.29.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.1/probe-rs-tools-aarch64-apple-darwin.tar.xz"
      sha256 "74af375061589671644cdfb7fd406b0346da736001f97f33f74d229d7fe5ef6f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.1/probe-rs-tools-x86_64-apple-darwin.tar.xz"
      sha256 "b6b8ccfd367ddf0ddcd04a23bc0e440087d49c333472b259fe79340fb63e119e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.1/probe-rs-tools-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d30d60e96d8244bd4670f244ec039d9167ca6564828096b2d04edd5d114ee286"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.1/probe-rs-tools-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f2ccb2ee5058559d663a3a4d1947ca1ce80802546aadd48cf355455126ae9758"
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
