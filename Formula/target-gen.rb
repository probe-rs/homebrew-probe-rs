class TargetGen < Formula
  desc "A cli tool to create new target files for probe-rs ot of CMSIS-Packs."
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.24.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.24.0/target-gen-aarch64-apple-darwin.tar.xz"
      sha256 "52fb9da0c31a7d4d9d5ebcfe706f57f26f583eda2bfdc9d403844316d5828eee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.24.0/target-gen-x86_64-apple-darwin.tar.xz"
      sha256 "824fb7c4cb8744c9c01a13bbfa6457830cefc0234d1faff9ebd25f8f2ca233d7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.24.0/target-gen-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5a1315c5c0bc04895b627256ce8765ed6056837201fbd4ae9ab90b62f0a6ee4b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.24.0/target-gen-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "86c6e83dc551970804706b4c6093be841a58e05d6149317a9e1d1ecb589a9678"
    end
  end
  license "MIT OR Apache-2.0"

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "target-gen"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "target-gen"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "target-gen"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "target-gen"
    end

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
