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
  version "0.12.0"
  license "MIT"
  head "https://github.com/RizRiyz/luvus.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. luvus only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`luvus doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.12.0/luvus-v0.12.0-aarch64-apple-darwin.tar.gz"
      sha256 "f8231c5d2d12f53c67ae3eefedf52f88b92256e8fcfc5951d7547350f188a1a4"
    end
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.12.0/luvus-v0.12.0-x86_64-apple-darwin.tar.gz"
      sha256 "95b32522c8a93af3f93ba5f02428dc5dbfebd903667156aeda68239659ec02dc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.12.0/luvus-v0.12.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2870a1f9386d2e10aecc4e9e5149951eb374c4fd9fb723c1539b154034b2afd2"
    end
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.12.0/luvus-v0.12.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1e72ee8c4273b82ef48b9a6535c5f819d9ade6c208bf8d67bb4f15b91c3b4af1"
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
