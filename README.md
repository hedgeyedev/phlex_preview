# Purpose

A quick and dirty phlex preview written because I was trying to understand some phlex functionality and just wanted to be able to see the changes easily

# Guiding principles
- Be simple
- Minimum Javascript/CSS load
  - Was no JS at all until I added Codemirror to syntax highlight the ruby
  - No CSS framework
- Explore the perks of having everything Ruby and mostly server side (blog post forthcoming)

# Aspirations
- Currently a standalone playground meant to be run locally
- Maybe to be converted a rack app/rubygem that I can mount to any Ruby app to preview one's phlex components from their app
  - A poor man's Storybook

# Running
- clone
- bundle install
- rackup (I use rerun to autoload in development)
- hit localhost:9292
- Create the code and the invocation to be rendered

# Specifying invocations
- For this app, and it's potential "poor man's storybook" I wanted to include a way to invoke the object and pass it data in the files themselves and came up with a the format

``` ruby
# Sample invocation:
# All the setup you need
# TestComponent.new(stuff_I_setup)
# End Sample invocation

```

- This serves a part documentation as well as as something to automatically put into the invocation portion to render
- Also serves the future "poor man's Storybook" feature to be able to auto preview all your components
- To be delightly recursive -open the rendered_results_preview_component.rb to see it on it's own components

# Caveats
- Initial version super not safe, only intended to be run in development, may explore sandboxing later, but trying to think about also being able to handle components that invoke other components, so I want to have it in same app. TBD