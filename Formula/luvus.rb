# Homebrew formula for luvus.
#
# Installs the **prebuilt binary** from the GitHub release, so `brew install`
# is a ~3 MB download with no Rust toolchain and no compile step. Building the
# 100+ crate dependency graph from source peaks well over a gigabyte of RAM,
# which is exactly what people install a binary to avoid.
#
# Every platform we publish gets a prebuilt binary, Intel macs included (the
# release cross-compiles x86_64 on an Apple-silicon runner).
#
#   brew install RizRiyz/luvus/luvus
#   brew install --HEAD RizRiyz/luvus/luvus   # build the tip of main
#
# `scripts/release.sh` rewrites the version + every sha256 below from the
# release's published `.sha256` assets — don't hand-edit them.
class Luvus < Formula
  desc "Mission control for your AI coding agents"
  homepage "https://github.com/RizRiyz/luvus"
  version "0.13.1"
  license "MIT"
  head "https://github.com/RizRiyz/luvus.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. luvus only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`luvus doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.1/luvus-v0.13.1-aarch64-apple-darwin.tar.gz"
      sha256 "eb8718edf01160bd953fe3ffb82ea68d0e49fb270c3ea27d0a001724f589dff9"
    end
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.1/luvus-v0.13.1-x86_64-apple-darwin.tar.gz"
      sha256 "c16268da807c1dcceb8cb7337959b9bf6c5dd46cacaeb37acb370021e3ed65a5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.1/luvus-v0.13.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6c6771c7f627a4f581db8e907ec026d1d616cfc880e070619fdcf54966674206"
    end
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.1/luvus-v0.13.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7de61c32e690d4b8132ad3e29476e408731d279951838da71dbb5c3a2c7f8d76"
    end
  end

  def install
    # `--HEAD` builds from a source checkout; every release path unpacks an
    # archive with the binary at its root.
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "luvus"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/luvus --version")
  end
end
