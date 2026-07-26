class Apb < Formula
  desc "Local runner for agentic playbooks with an embedded web dashboard and MCP server"
  homepage "https://github.com/itechmeat/agentic-playbooks"
  version "0.10.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/itechmeat/agentic-playbooks/releases/download/v0.10.1/apb-aarch64-apple-darwin.tar.xz"
      sha256 "1c54ccd36b784170211af5b82cfe7c62915a46efc96299978a356d406b33dd59"
    end
    if Hardware::CPU.intel?
      url "https://github.com/itechmeat/agentic-playbooks/releases/download/v0.10.1/apb-x86_64-apple-darwin.tar.xz"
      sha256 "f2a58b36b257f47d7fd5137cb33e5f14018787480db3b32c65d276f504cf30a1"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/itechmeat/agentic-playbooks/releases/download/v0.10.1/apb-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "c37824e3e6fed34833e327810a9a8dadb6826c7cfc224ece368bd8654471d1f1"
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
    bin.install "apb" if OS.mac? && Hardware::CPU.arm?
    bin.install "apb" if OS.mac? && Hardware::CPU.intel?
    bin.install "apb" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
