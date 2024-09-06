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

By default, this creates an initializer at `config/initializers/phlex_storybook.rb`, which looks in
`app/components` for your registered Phlex components. Those components should register themselves
with the storybook. E.g.

```ruby
class HelloWorld < Phlex::HTML
  register_component do
    # component_category is optional, non-categorized components will appear under "Uncategorized"
    component_category "Category 1"

    # component_name is optional, it defaults to the name of your component
    component_name "Good ol' Hello"

    # component_description is optional
    component_description "The typical programmer's first attempt..."

    # component props are required if your component takes arguments in #initialize
    component_props [
      PhlexStorybook::Props::String.new(key: :who, placeholder: "Who do you want to say hello to?")
    ]

    # component stories are optional; they are predefined instances of your component
    component_stories "Arnold" => { who: "Arnie Schwarzenegger" },
                      "Reagan" => { who: "Ronnie" }
  end

  def initialize(who: "world")
    @who = who
  end

  def view_template
    div { "hello #{@who}!" }
  end
end
```

## License

The gem is available as open source under the terms of the [MIT License](LICENSE).
