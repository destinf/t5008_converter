require_relative 'lib/t5008_converter/version'

Gem::Specification.new do |spec|
  spec.name          = "t5008_converter"
  spec.version       = T5008Converter::VERSION
  spec.authors       = ["d"]
  spec.email         = ["destin@fong.io"]

  spec.summary       = %q{A script to convert a CSV of your t5008 transactions into a different currency}
  spec.homepage      = "https://www.github.com/destinf/t5008_converter"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.1")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] =  "https://www.github.com/destinf/t5008_converter"
  spec.metadata["changelog_uri"] = "https://www.github.com/destinf/t5008_converter" # TODO: Put your gem's CHANGELOG.md URL here

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency("rspec", "~> 3.10")
  spec.add_development_dependency("guard-rspec", "~> 4.7")
  spec.add_development_dependency("pry", "~> 0.14")
end
