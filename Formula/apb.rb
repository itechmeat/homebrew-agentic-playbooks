class Apb < Formula
  desc "Local runner for agentic playbooks with an embedded web dashboard and MCP server"
  homepage "https://github.com/itechmeat/agentic-playbooks"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/itechmeat/agentic-playbooks/releases/download/v0.11.0/apb-aarch64-apple-darwin.tar.xz"
      sha256 "34fc329f237b7eaad03fdf01de7420d9b97729862e1399dd602fda7959982798"
    end
    if Hardware::CPU.intel?
      url "https://github.com/itechmeat/agentic-playbooks/releases/download/v0.11.0/apb-x86_64-apple-darwin.tar.xz"
      sha256 "1fa47da6c11fadd8c9ee3dcec483c8a710a5a7a99da3eae299c73eb1121ed74a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/itechmeat/agentic-playbooks/releases/download/v0.11.0/apb-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "56515c50ad0f76cc4404dd56bb24282d536ae8f0f8dc8c4b10c91c1e62a9ecbf"
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
