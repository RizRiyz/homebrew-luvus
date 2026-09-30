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
  version "0.14.3"
  license "Apache-2.0"
  head "https://github.com/RizRiyz/luvus.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. luvus only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`luvus doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.3/luvus-v0.14.3-aarch64-apple-darwin.tar.gz"
      sha256 "3365665adb7984116681a8f91b614dac9610e4a622bd77b1ff175a17304257c8"
    end
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.3/luvus-v0.14.3-x86_64-apple-darwin.tar.gz"
      sha256 "5f463648c5958ed43c890e92a69c1704a99c4ff743f50b9b4ce18ea6af12c34c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.3/luvus-v0.14.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1d96580525f23b21143c05850dbd9a1b4fe95e66d7e173dc27aab6caf9b676bf"
    end
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.3/luvus-v0.14.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6587fae1a661b9e5b97fc030f11e8b1896828dda41a4b22edab2dee7b20ed00d"
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
