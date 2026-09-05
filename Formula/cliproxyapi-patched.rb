class CliproxyapiPatched < Formula
  desc "CLIProxyAPI with plugin-controlled model-list metadata"
  homepage "https://github.com/wignerStan/CLIProxyAPI/tree/feature/plugin-model-list-filter"
  license "MIT"
  head "https://github.com/wignerStan/CLIProxyAPI.git", branch: "feature/plugin-model-list-filter"

  depends_on "go" => :build

  conflicts_with "cliproxyapi", because: "both install a cliproxyapi binary"

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV["CC"] = "/usr/bin/gcc" if OS.linux?
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}/model-list-patch
      -X main.BuildDate=#{time.iso8601}
      -X main.DefaultConfigPath=#{etc/"cliproxyapi-patched.conf"}
    ]

    system "go", "build", *std_go_args(output: bin/"cliproxyapi", ldflags: ldflags), "cmd/server/main.go"
    etc.install "config.example.yaml" => "cliproxyapi-patched.conf"
  end

  service do
    run [opt_bin/"cliproxyapi", "-config", etc/"cliproxyapi-patched.conf"]
    keep_alive true
  end

  test do
    output = shell_output("#{bin}/cliproxyapi --version 2>&1", 2)
    assert_match "CLIProxyAPI Version:", output
  end
end
