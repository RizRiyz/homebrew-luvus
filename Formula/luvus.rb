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
      sha256 "ef53040035b4974b129a9485681c03c332726eb088432591065c66bb9f780aa2"
    end
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.2/luvus-v0.14.2-x86_64-apple-darwin.tar.gz"
      sha256 "1fc679c9add536ff098edf2a9977f4c426b72ea57810a683321b5c58e86da9ed"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.2/luvus-v0.14.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "39734a22b95049afc8aa8273781a3cae2737d14820dd2ffb765ba48fd8366498"
    end
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.14.2/luvus-v0.14.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "87d14589463ed0b73975e07e5c8674f1f30dd18e7dbbf9750edf776313f95a59"
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
