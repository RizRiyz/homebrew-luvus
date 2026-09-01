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
  version "0.13.4"
  license "Apache-2.0"
  head "https://github.com/RizRiyz/luvus.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. luvus only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`luvus doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.4/luvus-v0.13.4-aarch64-apple-darwin.tar.gz"
      sha256 "5b733b3102a70d59b852cc818e475e5eaa1fa3772dd835981b7d43bf96eced97"
    end
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.4/luvus-v0.13.4-x86_64-apple-darwin.tar.gz"
      sha256 "163bfd3ac0d2f880725c0ec53b406c22de551d5f09c52531e3c74123b834ed63"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.4/luvus-v0.13.4-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5a544c93cdca526d48a52eb40ec46a802459dd385a7d240dc0af5c8dc1df1cdd"
    end
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.4/luvus-v0.13.4-aarch64-unknown-linux-musl.tar.gz"
      sha256 "24a6350e7be409f334fa252494caf7710839cb884844d6c373c9550c8f380167"
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
