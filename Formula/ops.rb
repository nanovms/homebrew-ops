class Ops < Formula
  desc "OPS - Build and Run Nanos Unikernels"
  homepage "https://nanos.org/"
  license "Apache 2.0"
  revision 1
  head "https://github.com/nanovms/ops"
  version "0.1.38"
  depends_on "go" => :build
  depends_on "nanovms/qemu/qemu"

  stable do
    url "https://github.com/nanovms/ops/archive/refs/tags/0.1.38.tar.gz"
    sha256 "c0334ee9aca88b82e7246f050506e490d9f809dc9da9f57adcd93bb9a58b77ed"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["VERSION"] = "0.1.19"
    ENV["GO111MODULE"] = "on"

    path = buildpath/"src/github.com/nanovms/ops"
    path.install Dir["*"]
    cd path do
      system "go", "build", "-ldflags", "-w", "-o", "ops"
      system "mkdir", "-p", "$HOME/.ops/bin"
      system "cp", "ops", "$HOME/.ops/bin/."
      bin.install "ops"
    end
  end

end
