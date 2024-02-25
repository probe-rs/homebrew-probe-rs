class TargetGen < Formula
  desc "A cli tool to create new target files for probe-rs ot of CMSIS-Packs."
  homepage "https://github.com/probe-rs/probe-rs"
  version "0.23.0"
  on_macos do
    on_arm do
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.23.0/target-gen-aarch64-apple-darwin.tar.xz"
      sha256 "b42fa287aad8cfe19b03e178eaf0ad4dfb52cc87f3616bbfa67fce15509478b0"
    end
    on_intel do
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.23.0/target-gen-x86_64-apple-darwin.tar.xz"
      sha256 "518f816264e9e768da1a6cde06b7107e4fa5f8c5efd6107fafa79cbc3a9eb28f"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/probe-rs/probe-rs/releases/download/v0.23.0/target-gen-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e6a725b6d75213aa14a82a38f231ba859e232a8606bc29e4757c126854a7a20"
    end
  end
  license "MIT OR Apache-2.0"

  def install
    on_macos do
      on_arm do
        bin.install "target-gen"
      end
    end
    on_macos do
      on_intel do
        bin.install "target-gen"
      end
    end
    on_linux do
      on_intel do
        bin.install "target-gen"
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
