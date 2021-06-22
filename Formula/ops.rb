class Ops < Formula
  desc "OPS - Build and Run Nanos Unikernels"
  homepage "https://nanos.org/"
  license "Apache 2.0"
  revision 1
  head "https://github.com/nanovms/ops"
  version "0.1.24"
  depends_on "go" => :build
  depends_on "nanovms/qemu/qemu"

  stable do
    url "https://github.com/nanovms/ops/archive/refs/tags/0.1.24.tar.gz"
    sha256 "4d15c49e7780d2772e0b324c78d90851fe1547bbd1c7b581b75de01d536c9027"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["VERSION"] = "0.1.17"
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
