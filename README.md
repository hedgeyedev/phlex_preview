# PhlexStorybook

This is a storybook for your Phlex components that allows you to:

- Preview your component
- View the Ruby Code to render your component
- Alter properties and see the preview and ruby code changes in real time
- Write stories to document different facets of your component

## Usage

In your `config/routes.rb` file, mount the engine:

```ruby
Rails.application.routes.draw do
  mount PhlexStorybook::Engine => "/phlex_storybook"
end
```

Add your Phlex components to app/components. You can add metadata to your components with the following methods:

```ruby
class MyComponent < Phlex::HTML
  def self.component_category = "Category 1"
  def self.component_description = "MyComponent Description"
  def self.component_name = "MyComponent Name"

  def self.component_props
    [
      PhlexStorybook::Props::String.new(key: "header", default: "Hello World", required: true),
    ]
  end

  def self.component_stories
    [
      { title: "Default", header: "Hello World" } },
      { title: "Custom Title", header: "Goodbye World" } },
    ]
  end

  def initialize(header:)
    @header = header
  end

  def view_template
    div { h1 { @header } }
  end
end
```

Browse to your app @ /phlex_storybook. You should see a list of your components and their stories.

## Running locally

Clone this repo, then execute `bin/dev`. Simple, right?

## Installation

Add this to your application's Gemfile:

```ruby
source "https://rubygems.pkg.github.com/hedgeyedev" do
  gem "phlex_storybook"
end
```

And then execute:

```bash
$ bundle
```

Then run the installer:
```shell
rails phlex_storybook:install
```

## License

The gem is available as open source under the terms of the [MIT License](LICENSE).
