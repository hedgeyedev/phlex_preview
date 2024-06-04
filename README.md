# Purpose

A quick and dirty phlex preview written because I was trying to understand some phlex functionality and just wanted to be able to see the changes easily

# Guiding principles
- Be simple
- Minimum Javascript/CSS load
  - Was no JS at all until I added Codemirror to syntax highlight the ruby
  - No CSS framework
  - How long can we keep it like this
    - ![image](https://github.com/hedgeyedev/phlex_preview/assets/13941/306f0df6-91c9-40e9-9a33-9d2c0eff419e)
    - Though technically not true, there's some embedded css and js

- Explore the perks of having everything Ruby and mostly server side (blog post forthcoming)

# Aspirations
- Currently a standalone playground meant to be run locally
- Maybe to be converted a rack app/rubygem that I can mount to any Ruby app to preview one's phlex components from their app
  - A poor man's Storybook

# Running
- clone
- `bundle install`
- `bundle exec puma -p 6001` or `bundle exec rerun -- puma -p 6001` (the "rerun" gem will watch for filesystem changes and restart your application)
- navigate to localhost:6001 in a browser
- Create the code and the invocation to be rendered

# Specifying invocations
- For this app, and it's potential "poor man's storybook" I wanted to include a way to invoke the object and pass it data in the files themselves and came up with a the format

``` ruby
# Sample invocation:
# All the setup you need
# TestComponent.new(stuff_I_setup)
# End Sample invocation

```
- example from app_layout_component.rb

``` ruby
# Sample invocation:
# code = "class UserProfileComponent < Phlex::HTML\n  def initialize(user)\n    @user = user\n  end\n\n  def view_template\n    div {\n      h1 { @user.name }\n      p { @user.email }\n    }\n  end\nend"
# params = "UserProfileComponent.new(User.new('John Doe', 'john@example.com')) "
# AppLayoutComponent.new(code, params)
# End Sample invocation

```

- This serves a part documentation as well as as something to automatically put into the invocation portion to render
- Also serves the future "poor man's Storybook" feature to be able to auto preview all your components
- To be delightly recursive
  - open the either of the rendered_results_preview_component.rb or app_layout_component.rb to see it render it's own components in itself

# Caveats
- Initial version super not safe, only intended to be run in development, may explore sandboxing later, but trying to think about also being able to handle components that invoke other components, so I want to have it in same app. TBD

# Pics
## Edit component code, specify invocation
![image](https://github.com/hedgeyedev/phlex_preview/assets/13941/336bc4dd-caec-49b2-be89-2c437e178e57)

## See both rendered and raw html - meta example, rendering that component
![image](https://github.com/hedgeyedev/phlex_preview/assets/13941/fd9140d3-3c0b-41e5-a019-32186c58eca6)
## Actual html of that component
![image](https://github.com/hedgeyedev/phlex_preview/assets/13941/c127e5bd-7242-4c6e-a5a7-f6c70c3012dc)
