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
  version "0.14.0"
  license "Apache-2.0"
  head "https://github.com/RizRiyz/luvus.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. luvus only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`luvus doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.0/luvus-v0.14.0-aarch64-apple-darwin.tar.gz"
      sha256 "281d1ea8f432160f227c9577e5e5c03933627837f2572e94a128dc546579df08"
    end
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.0/luvus-v0.14.0-x86_64-apple-darwin.tar.gz"
      sha256 "40c0a23296c3c5c90c28eeb627daa5d8593b2b57eb2a6282892a283921e99957"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.0/luvus-v0.14.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4118f8ffe99afc81e60551d714d883c6a9198278eae5c81d7af2c0567e34a732"
    end
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.0/luvus-v0.14.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b7655ff356bac3e6718a56d8fb2e6db160a38b39e3c0fb510161fb14732c7a0a"
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
