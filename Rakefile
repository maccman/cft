desc "Build the cft-source gem"
task :gem do
  sh "cake dist"

  require "json"
  require "rubygems"
  require "rubygems/package"

  gemspec = Gem::Specification.new do |s|
    s.name        = "cft-source"
    s.version     = JSON.parse(File.read("package.json"))["version"].gsub("-", ".")
    s.date        = Time.now.strftime("%Y-%m-%d")

    s.homepage    = "https://github.com/maccman/cft/"
    s.summary     = "CFT compiler source"
    s.description = "JavaScript source code for the CFT (CoffeeScript fragment template) compiler"
    s.files = [
      "lib/cft/cft.js",
      "lib/cft/source.rb"
    ]

    s.authors     = ["Alex MacCaw"]
    s.email       = "info@eribium.org"
  end

  file = File.open("cft-source-#{gemspec.version}.gem", "w")
  Gem::Package.open(file, "w") do |pkg|
    pkg.metadata = gemspec.to_yaml

    path = "lib/cft/source.rb"
    contents = <<-RUBY
module CFT
  module Source
    VERSION = #{gemspec.version.to_s.inspect}

    def self.bundled_path
      File.expand_path("../cft.js", __FILE__)
    end
  end
end
    RUBY
    pkg.add_file_simple(path, 0644, contents.size) do |tar_io|
      tar_io.write(contents)
    end

    contents = File.read("dist/cft.js")
    path = "lib/cft/cft.js"
    pkg.add_file_simple(path, 0644, contents.size) do |tar_io|
      tar_io.write(contents)
    end
  end

  warn "Built #{file.path}"
end