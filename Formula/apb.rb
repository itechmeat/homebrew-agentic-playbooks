class Apb < Formula
  desc "Local runner for agentic playbooks with an embedded web dashboard and MCP server"
  homepage "https://github.com/itechmeat/agentic-playbooks"
  version "0.17.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/itechmeat/agentic-playbooks/releases/download/v0.17.0/apb-aarch64-apple-darwin.tar.xz"
      sha256 "27e9dc21f531074f6522a2e14644b30b3b80b794e743ac9b2ac381ea860ebc95"
    end
    if Hardware::CPU.intel?
      url "https://github.com/itechmeat/agentic-playbooks/releases/download/v0.17.0/apb-x86_64-apple-darwin.tar.xz"
      sha256 "3ae2703a53cd6267bf0aaba831fc8be3b8c4b531adcdfea00eec2d00dafa8387"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/itechmeat/agentic-playbooks/releases/download/v0.17.0/apb-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d7aa7bce15d1bea3736ec6dcf34fcbbfc0ee472f4f1512f3a300919e896a1383"
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
