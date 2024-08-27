class Ops < Formula
  desc "OPS - Build and Run Nanos Unikernels"
  homepage "https://nanos.org/"
  license "Apache 2.0"
  revision 1
  head "https://github.com/nanovms/ops"
  version "0.1.42"
  depends_on "go" => :build
  depends_on "qemu" => "9.0.1"

  stable do
    url "https://github.com/nanovms/ops/archive/refs/tags/0.1.42.tar.gz"
    sha256 "fd7b6fe1333d773df5bdc03b563f3b14836cc0a79f09cef030689698bcb5a3e9"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["VERSION"] = "0.1.19"
    ENV["GO111MODULE"] = "on"
    ENV["PATH"] = ENV["PATH"] + ":" + ENV["GOPATH"] + "/bin"

    path = buildpath/"src/github.com/nanovms/ops"
    path.install Dir["*"]
    cd path do
      system "make", "deps"

      a = `uname -m`.rstrip
      system "go", "build", "-ldflags", "-w", "-o", "ops"
      system "mkdir", "-p", "$HOME/.ops/bin"
      system "cp", "ops", "$HOME/.ops/bin/."
      bin.install "ops"
    end
  end

end
