class ProbeRs < Formula
  desc "A collection of on chip debugging tools to communicate with microchips."
  homepage "https://probe.rs"
  version "0.28.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.28.0/probe-rs-tools-aarch64-apple-darwin.tar.xz"
      sha256 "b072d59b1dcea5e018c3e9824491453c3c76d6a351d607e2a64cebb88e628588"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.28.0/probe-rs-tools-x86_64-apple-darwin.tar.xz"
      sha256 "44201772971d5f99064058fe8f38afa20801876c28d3838253cf165d14f83c35"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.28.0/probe-rs-tools-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c87b220e9a292825c84708b4ac1df408d7dc7bf46cacffd6c70c0d4998366e35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.28.0/probe-rs-tools-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8b5d6327fb52715c8045c1f9261c335b2faa49c4b7f963e197251533f0bdb4f7"
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
