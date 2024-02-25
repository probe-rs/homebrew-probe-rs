class Rtthost < Formula
  desc "RTT (Real-Time Transfer) client"
  version "0.23.0"
  on_macos do
    on_arm do
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.23.0/rtthost-aarch64-apple-darwin.tar.xz"
      sha256 "03cd1a0e8a1f693ff198290bca6498fd6ecc8cf7bcf049bffccd933ba87d32f7"
    end
    on_intel do
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.23.0/rtthost-x86_64-apple-darwin.tar.xz"
      sha256 "a6c36a6f6c0dc23aee06eb6209acece7746b35a84a53ae1fbae8742000044838"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.23.0/rtthost-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fbbd5959cb4c7efa1c96f8c75e5664e80c7bf1b3d2a3705a202167900244eb22"
    end
  end
  license "MIT"

  def install
    on_macos do
      on_arm do
        bin.install "rtthost"
      end
    end
    on_macos do
      on_intel do
        bin.install "rtthost"
      end
    end
    on_linux do
      on_intel do
        bin.install "rtthost"
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
