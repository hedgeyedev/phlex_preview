# frozen_string_literal: true

class ComponentSelector < Phlex::HTML
  def initialize(label, component, active: false, explanatory_component: nil, args: [], kw_args: {})
    @active                = active
    @label                 = label
    @component             = component
    @explanatory_component = explanatory_component
    @args                  = args.blank? ? [] : args.map { |a| "args[]=#{a}" }.join("&")
    @kw_args               = kw_args.blank? ? {} : kw_args.map { |k, v| "kw_args[#{k}]=#{v}" }.join("&")
  end

  def active?
    @active
  end

  def view_template(&)
    div(**classes("component-selection", active?: "active")) do
      name        = "name=#{@component}"
      explanation = @explanatory_component ? "explanation=#{@explanatory_component}" : nil
      a(
        href: "/select_component?#{[name, explanation, @args, @kw_args].compact_blank.join("&")}",
        target: "_top",
      ) { @label }
    end
  end
end
