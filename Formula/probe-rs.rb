class ProbeRs < Formula
  desc "A collection of on chip debugging tools to communicate with microchips."
  homepage "https://probe.rs"
  version "0.27.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.27.0/probe-rs-tools-aarch64-apple-darwin.tar.xz"
      sha256 "7b1ad0d61f6355a9f095e4d06a5e6149ad9824f4725d4976104486941d652d5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.27.0/probe-rs-tools-x86_64-apple-darwin.tar.xz"
      sha256 "c00a87173008b8279c8d2669e90ce878629abb95ceaa003099adb68d62f3fafb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.27.0/probe-rs-tools-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7aed7af58c9e267b7145490de61d0147033fadb0a70313fe7dbd363bfd98a728"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.27.0/probe-rs-tools-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "314c40db7ded9ae5622c6af8fe5149bcf5c507d7d6f5b7a415d6acf8d2005cb0"
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
