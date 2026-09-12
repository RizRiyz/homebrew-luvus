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
  version "0.14.1"
  license "Apache-2.0"
  head "https://github.com/RizRiyz/luvus.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. luvus only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`luvus doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.1/luvus-v0.14.1-aarch64-apple-darwin.tar.gz"
      sha256 "3028867f7bc88809467b759a96a0fceab6fee9364c5dd85151bece262d4b9ceb"
    end
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.1/luvus-v0.14.1-x86_64-apple-darwin.tar.gz"
      sha256 "4e090adcf30e6d39a929c655d3a1baac893f1ef336fee723a89fa64d3873f6ff"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.1/luvus-v0.14.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f8a2f2cf1059cf51cc6db59b152971e0ec64bde0be84c2673180137b00418bd2"
    end
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.1/luvus-v0.14.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "be4a8138d6d53cad8de17b04e303618ac4484aa40059d09388d46f91a94e2c26"
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
