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
  version "0.13.0"
  license "MIT"
  head "https://github.com/RizRiyz/luvus.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. luvus only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`luvus doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.0/luvus-v0.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "717c3ef4c0f9ed3b7dc0e6e4d9382122e4afa19215af8c91fcd87cdd06a16ca4"
    end
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.0/luvus-v0.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "8c18efb8e83b65a673927895db30fa5b4ef30c7883f493b60202ceb78aa0e252"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.0/luvus-v0.13.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f3572649ffe3ff0440a99c92da33038925a0009bef5d1513f59a36dd24a43156"
    end
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.0/luvus-v0.13.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b257fb3a9c1eac7db76e0d2726b86dd3a9730563a4b015eb9f4a8f222faecb52"
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
