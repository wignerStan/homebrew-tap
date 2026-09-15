class SingBoxWigner < Formula
  desc "Universal proxy platform with Wigner's Darwin Tailscale route fixes"
  homepage "https://github.com/wignerStan/sing-box"
  url "https://github.com/wignerStan/sing-box/archive/5469a0acb36b2dfd465b7b6b1eb5f3b9e01b75f1.tar.gz"
  version "1.14.0-wigner-5469a0ac"
  sha256 "910e99f75de55a02fc26a1e7611fe17eb52a7e968b20622786cfa4cb025fa2dc"
  license "GPL-3.0-or-later"

  depends_on "go" => :build

  conflicts_with "sing-box", because: "both install a sing-box executable"

  def install
    # The Homebrew compiler shim triggers an arm64 Go linker failure in this
    # fork; use Xcode's compiler selected by xcrun for this Go/Cgo build.
    ENV["CC"] = Utils.safe_popen_read("/usr/bin/xcrun", "--find", "clang").strip
    ENV["CXX"] = Utils.safe_popen_read("/usr/bin/xcrun", "--find", "clang++").strip
    tags = %w[with_gvisor with_quic with_wireguard with_utls with_clash_api with_tailscale]
    # release/LDFLAGS adds -checklinkname=0, which fails the Darwin linker for
    # this fork's system-interface build. Keep the version stamp only.
    ldflags = "-X github.com/sagernet/sing-box/constant.Version=#{version}"
    system "go", "build", "-trimpath", "-buildvcs=false", "-tags", tags.join(","),
           "-ldflags", ldflags, "-o", bin/"sing-box", "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box version")
    (testpath/"config.json").write <<~JSON
      {"inbounds":[{"type":"mixed","listen":"127.0.0.1","listen_port":1080}]}
    JSON
    system bin/"sing-box", "check", "-c", testpath/"config.json"
  end
end
