class TargetGen < Formula
  desc "A cli tool to create new target files for probe-rs ot of CMSIS-Packs."
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.31.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.31.0/target-gen-aarch64-apple-darwin.tar.xz"
      sha256 "7fa89a8673cf22710c3abfa380807c77d8e857a4c0f4bacb061a2838a27e1adb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.31.0/target-gen-x86_64-apple-darwin.tar.xz"
      sha256 "4a3924c29f8481deac27110cc57dd8a2377d1e71b7c4cf98998c1f8d833e9f2b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.31.0/target-gen-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b11703025e23082fb671d8d06979a35c040e4395e71f8e490ea12de69d491301"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.31.0/target-gen-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c8838468410b8d335bb205f0508ac8e670a2a3a4134d2bb6e44316107363b13f"
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
    bin.install "target-gen" if OS.mac? && Hardware::CPU.arm?
    bin.install "target-gen" if OS.mac? && Hardware::CPU.intel?
    bin.install "target-gen" if OS.linux? && Hardware::CPU.arm?
    bin.install "target-gen" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
