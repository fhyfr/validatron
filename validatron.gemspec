# frozen_string_literal: true

require_relative "lib/validatron/version"

Gem::Specification.new do |spec|
  spec.name = "validatron"
  spec.version = Validatron::VERSION
  spec.authors = ["fhyfr"]
  spec.email = ["fhaya.firman@gmail.com"]

  spec.summary = "A Ruby gem for request parameter validation"
  spec.description = "Validatron provides a simple and powerful way to validate request parameters in Ruby on Rails applications, ensuring data integrity and security."
  spec.homepage = "https://github.com/fhyfr/validatron"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fhyfr/validatron"
  spec.metadata["changelog_uri"] = "https://github.com/fhyfr/validatron/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency "rspec"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
end
