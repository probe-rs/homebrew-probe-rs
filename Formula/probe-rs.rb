class ProbeRs < Formula
  desc "A collection of on chip debugging tools to communicate with microchips."
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.23.0"
  on_macos do
    on_arm do
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.23.0/probe-rs-aarch64-apple-darwin.tar.xz"
      sha256 "7a1f10a074ed7e02fa010aed11f3af8bd200473f07274bd819a0920d9adb7dd7"
    end
    on_intel do
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.23.0/probe-rs-x86_64-apple-darwin.tar.xz"
      sha256 "6feec6fb0ee95c44ab217999aa503a696538c1cd97f1a4addb677908d3799b75"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.23.0/probe-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5f3b06971102921687cda3c5d3070ff8b7dd9698e7b7bdc73cec048c65f94107"
    end
  end
  license "MIT OR Apache-2.0"

  def install
    on_macos do
      on_arm do
        bin.install "cargo-embed", "cargo-flash", "probe-rs"
      end
    end
    on_macos do
      on_intel do
        bin.install "cargo-embed", "cargo-flash", "probe-rs"
      end
    end
    on_linux do
      on_intel do
        bin.install "cargo-embed", "cargo-flash", "probe-rs"
      end
    end

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install *leftover_contents unless leftover_contents.empty?
  end
end
