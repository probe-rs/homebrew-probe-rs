class ProbeRs < Formula
  desc "A collection of on chip debugging tools to communicate with microchips."
  homepage "https://probe.rs"
  version "0.30.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.30.0/probe-rs-tools-aarch64-apple-darwin.tar.xz"
      sha256 "aaf0706747dd59fac2987a1d22654f0f2a51f9288689e919c476cf25fe7b2bfe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.30.0/probe-rs-tools-x86_64-apple-darwin.tar.xz"
      sha256 "b9c115d36f07f0f1fd7830ef71a9787bc7b95a3f6c989f62cd456647b303b6b3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.30.0/probe-rs-tools-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fd4bae725ab0cb75cae526ec0b4eef09e2aac3f3f51847d61aa1eac092f2b92e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.30.0/probe-rs-tools-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f35b6bc7c8312811e86687ccdbde4386ce63df12aeab79238c7c5fc86dd31046"
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
