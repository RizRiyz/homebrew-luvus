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
  version "0.13.2"
  license "Apache-2.0"
  head "https://github.com/RizRiyz/luvus.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. luvus only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`luvus doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.2/luvus-v0.13.2-aarch64-apple-darwin.tar.gz"
      sha256 "60ae815371db95b8a8dd2687285c796120e7359706771e4243637bf1761ef823"
    end
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.2/luvus-v0.13.2-x86_64-apple-darwin.tar.gz"
      sha256 "df1eb069e365897d8b2328dc0eea7d2e9039c6cd5fc3923e1c17d6338c523e18"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.2/luvus-v0.13.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "01fb4cde86d771ce40f1230e81d731564b8e0fbafe9943ac192bc95c2820c259"
    end
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.13.2/luvus-v0.13.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "33aa640f1d9d1c0de6673e048d642e53eff5dcbed47eac8f145ec26ddaa8dd3f"
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
