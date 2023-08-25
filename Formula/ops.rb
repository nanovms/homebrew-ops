class Ops < Formula
  desc "OPS - Build and Run Nanos Unikernels"
  homepage "https://nanos.org/"
  license "Apache 2.0"
  revision 1
  head "https://github.com/nanovms/ops"
  version "0.1.39"
  depends_on "go" => :build
  depends_on "qemu"
  depends_on "bufbuild/buf/buf"
  depends_on "protoc-gen-go-grpc"

  stable do
    url "https://github.com/nanovms/ops/archive/refs/tags/0.1.39.tar.gz"
    sha256 "7f4481c263f1c5d291400e4bc9d9557fb083e669a644f6cb8194e72912a8d83c"
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
      system "go", "install", "google.golang.org/protobuf/cmd/protoc-gen-go@latest"
      system "go", "install", "google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest"
      system "go", "install", "github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest"
      system "go", "install", "github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest"

      a = `uname -m`.rstrip
      system "curl", "-L", "https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v2.15.0/protoc-gen-openapiv2-v2.15.0-darwin-"+a, "-o", "/tmp/protoc-gen-openapiv2"
      system "chmod", "+x", "/tmp/protoc-gen-openapiv2"
      system "curl", "-L", "https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v2.15.0/protoc-gen-grpc-gateway-v2.15.0-darwin-"+a, "-o", "/tmp/protoc-gen-grpc-gateway"
      system "chmod", "+x", "/tmp/protoc-gen-grpc-gateway"

      system "make", "generate"
      system "go", "build", "-ldflags", "-w", "-o", "ops"
      system "mkdir", "-p", "$HOME/.ops/bin"
      system "cp", "ops", "$HOME/.ops/bin/."
      bin.install "ops"
    end
  end

end
