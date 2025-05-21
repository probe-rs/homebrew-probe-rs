class TargetGen < Formula
  desc "A cli tool to create new target files for probe-rs ot of CMSIS-Packs."
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.29.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.0/target-gen-aarch64-apple-darwin.tar.xz"
      sha256 "757f67895b001dc71441bf00243ed506913a3f9a10973977ed79c625eebf4b7e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.0/target-gen-x86_64-apple-darwin.tar.xz"
      sha256 "34c0ba350bf8fd572f8e1944f92e7ed5abd7fc0f93eac9954ea55f38d5eb7a81"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.0/target-gen-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "626d092dae0bcaac550f682002b43ef6225cacbc2bbaffd43f4ba5f66635b5bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.29.0/target-gen-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2f6c86e8b7ce8bd60f46b86a7c70dd4bd49a49a3b3c6d69da463ef552b31aadc"
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
