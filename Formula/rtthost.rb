class Rtthost < Formula
  desc "RTT (Real-Time Transfer) client"
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.29.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.1/rtthost-aarch64-apple-darwin.tar.xz"
      sha256 "00a94ac4988e9600bf9f11d1617687895f196fdf99b982d440a959a023f169e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.1/rtthost-x86_64-apple-darwin.tar.xz"
      sha256 "c91658052b8b093e9fc50491a36de5ed8199e3dbd80e3ff97df08d69a4d316f3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.1/rtthost-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "16e5a00f2597d8a7cc0dd19bc1349f4b058002e980c429fd164368bf43edd039"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.1/rtthost-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "71e034b49032a1eca188d9fc1041b835625dbf2ce41bbf162e70b4ab0ee43b2b"
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
