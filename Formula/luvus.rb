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
  version "0.14.2"
  license "Apache-2.0"
  head "https://github.com/RizRiyz/luvus.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. luvus only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`luvus doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.2/luvus-v0.14.2-aarch64-apple-darwin.tar.gz"
      sha256 "49446ee2702a36f09d723f728f776e0f56518a66f6272f13d72ad31ce5762444"
    end
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.2/luvus-v0.14.2-x86_64-apple-darwin.tar.gz"
      sha256 "34aacf24cb4e098cb0f7591ac6eb74e4dd23b29323653ab96d6408427b0a5c4d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.2/luvus-v0.14.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "af9e5f1ba4551f0ad7a245666152fae16e05554509c4f3fb82b011d912a2f61a"
    end
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.2/luvus-v0.14.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "02b6d0dd8b72182d33119be837e7ba5ee8c938453b2dab47face98da1c504e3d"
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
