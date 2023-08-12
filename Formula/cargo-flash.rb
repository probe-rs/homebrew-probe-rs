class CargoFlash < Formula
  desc "The probe-rs embedded debugging toolkit"
  homepage "https://probe.rs"
  license "Apache 2.0 or MIT"
  version "0.20.0"

  depends_on "libftdi"
  
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/probe-rs/probe-rs/releases/download/v#{version}/probe-rs-aarch64-apple-darwin.tar.xz"
      sha256 "09fd234c26b1ac78064e60ab06b54c538d5121b352245b190aed22f934328f98"
    else
      url "https://github.com/probe-rs/probe-rs/releases/download/v#{version}/probe-rs-x86_64-apple-darwin.tar.xz"
      sha256 "09fd234c26b1ac78064e60ab06b54c538d5121b352245b190aed22f934328f98"
    end
  end

  on_linux do
    url "https://github.com/probe-rs/probe-rs/releases/download/v#{version}/probe-rs-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "09fd234c26b1ac78064e60ab06b54c538d5121b352245b190aed22f934328f98"
  end

  def install
    bin.install "cargo-flash"
  end
end
