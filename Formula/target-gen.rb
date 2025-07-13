class TargetGen < Formula
  desc "A cli tool to create new target files for probe-rs ot of CMSIS-Packs."
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.29.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.1/target-gen-aarch64-apple-darwin.tar.xz"
      sha256 "e6521843f3d7b36478af997b5f6243bb738039fafbed82b7557ca6c08b28e712"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.1/target-gen-x86_64-apple-darwin.tar.xz"
      sha256 "de752684e92880612d97cf520f4b708cdd33315894d99c0810c60b608f3ef051"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.1/target-gen-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cf3759360ac2cddaeb649b887f47cd234a614c096359045a66b95e68b66fd679"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.1/target-gen-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "48a527171cb277c9307f2dd2e73045dd3f5172c8eb42a0611949960d8f78bf38"
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
