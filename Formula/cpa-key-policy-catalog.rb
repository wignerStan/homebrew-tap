class CpaKeyPolicyCatalog < Formula
  desc "CPA key-policy plugin with per-key model catalogs"
  homepage "https://github.com/wignerStan/cpa-plugin-key-policy/tree/feature/model-catalog-policy"
  license "MIT"
  head "https://github.com/wignerStan/cpa-plugin-key-policy.git", branch: "feature/model-catalog-policy"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV["CC"] = "/usr/bin/gcc" if OS.linux?
    extension = OS.mac? ? "dylib" : "so"
    output = libexec/"cpa-key-policy.#{extension}"
    libexec.mkpath
    system "go", "build", "-trimpath", "-buildvcs=false", "-tags", "cshared",
           "-buildmode=c-shared", "-ldflags", "-s -w", "-o", output,
           "./cmd/cpa-key-policy"
    rm libexec/"cpa-key-policy.h"
  end

  def caveats
    <<~EOS
      Set CLIProxyAPI's plugins.dir to:
        #{opt_libexec}

      Then enable the cpa-key-policy plugin and configure catalog_groups.
    EOS
  end

  test do
    extension = OS.mac? ? "dylib" : "so"
    assert_path_exists libexec/"cpa-key-policy.#{extension}"
  end
end
