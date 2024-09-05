require_relative "lib/phlex_storybook/version"

Gem::Specification.new do |spec|
  spec.name        = "phlex_storybook"
  spec.version     = PhlexStorybook::VERSION
  spec.authors     = [ "Hedgeye Developers" ]
  spec.email       = [ "developers@hedgeye.com" ]
  spec.homepage    = "https://github.com/hedgeyedev/phlex_preview"
  spec.summary     = "A storybook implementation for Phlex components."
  spec.description = "Showcase your Phlex components: rendering, documentation, and copyable code."
  spec.license     = "MIT"

  spec.post_install_message = <<~MESSAGE
    PhlexStorybook requires additional setup.
    Please run the following command to install the necessary files:
    thor phlex_storybook:install
  MESSAGE

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,lib}/**/*", "LICENSE", "Rakefile", "README.md", "CHANGELOG.md"]
  end

  spec.add_dependency "importmap-rails"
  spec.add_dependency "phlex-rails", "~> 1.2"
  spec.add_dependency "rails", ">= 7.2"
  spec.add_dependency "stimulus-rails"
  spec.add_dependency "tailwindcss-rails", "~> 2.7"
  spec.add_dependency "turbo-rails"
  spec.add_dependency "turbo_power", "~> 0.6.2"
  spec.add_dependency "phlex-icons", "~> 0.11.0"
  spec.add_dependency "rouge", "~> 4.3.0"
end
