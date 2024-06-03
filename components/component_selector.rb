# frozen_string_literal: true

class ComponentSelector < Phlex::HTML
  def initialize(label, component, active: false, explanatory_component: nil, args: [], kw_args: {})
    @active                = active
    @label                 = label
    @component             = component
    @explanatory_component = explanatory_component
    @args                  = args.blank? ? [] : convert_deep_array(args).join("&")
    @kw_args               = kw_args.blank? ? {} : convert_deep_hash(kw_args).join("&")
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

  private

  def convert_deep_array(args, key_format: "args[%s]")
    args.flat_map.with_index do |v, i|
      case v
      when Hash
        convert_deep_hash(v, key_format: "#{format(key_format, i)}[%s]")
      when Array
        convert_deep_array(v, key_format: "#{format(key_format, i)}[]")
      else
        format("%s=%s", format(key_format, i), encode(v))
      end
    end
  end

  def convert_deep_hash(kw_args, key_format: "kw_args[%s]")
    kw_args.flat_map do |k, v|
      case v
      when Hash
        convert_deep_hash(v, key_format: "#{format(key_format, k)}[%s]")
      when Array
        convert_deep_array(v, key_format: "#{format(key_format, k)}[]")
      else
        format("%s=%s", format(key_format, encode(k)), encode(v))
      end
    end
  end

  def encode(it)
    URI.encode_www_form_component(it)
  end
end
