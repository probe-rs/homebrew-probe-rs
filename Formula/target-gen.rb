class TargetGen < Formula
  desc "A cli tool to create new target files for probe-rs ot of CMSIS-Packs."
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.28.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.28.0/target-gen-aarch64-apple-darwin.tar.xz"
      sha256 "9e4662a00eb963f48e060ba755fc99c7ba7d81b7203f4d81c8059c78e4a52e14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.28.0/target-gen-x86_64-apple-darwin.tar.xz"
      sha256 "da3e7cb593d2255de6a7e2d1a4f022d847d0aadbe4ddbe050dfbac59426296c7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.28.0/target-gen-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0fb065687dcb50974463dfd180dcfb379000106406334d06ccfd4e3ba8db2392"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.28.0/target-gen-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "04499c8010465a20fd4f047d3760f56fe35c40b6c161b988da24d286e9e73c32"
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
