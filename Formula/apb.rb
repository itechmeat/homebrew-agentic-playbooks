class Apb < Formula
  desc "Local runner for agentic playbooks with an embedded web dashboard and MCP server"
  homepage "https://github.com/itechmeat/agentic-playbooks"
  version "0.18.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/itechmeat/agentic-playbooks/releases/download/v0.18.0/apb-aarch64-apple-darwin.tar.xz"
      sha256 "908d1ad92d70ffeaae246ff4193b022fcca2f0fe5482f065b470f84089b5f9eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/itechmeat/agentic-playbooks/releases/download/v0.18.0/apb-x86_64-apple-darwin.tar.xz"
      sha256 "0e09e761a3bb9150502063c56ec5ec58938dc69858dee29500ba8ebf87c42e64"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/itechmeat/agentic-playbooks/releases/download/v0.18.0/apb-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e2036e8483a49039e74431a3bf7ccceb1a84266202cd4f46d722a21742bd0ae3"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "apb"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "apb"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "apb"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
