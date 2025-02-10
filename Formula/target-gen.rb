class TargetGen < Formula
  desc "A cli tool to create new target files for probe-rs ot of CMSIS-Packs."
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.27.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.27.0/target-gen-aarch64-apple-darwin.tar.xz"
      sha256 "9f7d3862b0706e20472a89a35a8ce2f692f2a1e7efac509aff5b704785d129c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.27.0/target-gen-x86_64-apple-darwin.tar.xz"
      sha256 "10c08a3939d87952825ad93a24ae0d708ce95b9d6e21ba37b8a71714ed292a7b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.27.0/target-gen-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f0d2327b2adb804c68273f32b14d4d3f1d9a28ac35dfb46cdeedf7358dd38e35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.27.0/target-gen-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "482e616248d10225aca55100460f4eb95d5a3ac771461e9b5092deed9e93114c"
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
