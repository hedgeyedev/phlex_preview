# frozen_string_literal: true

require 'active_support'
require 'roda'
require 'phlex'
require 'tempfile'
require 'uri'

require_relative 'components'

class PreviewApp < Roda
  plugin :render

  route do |r|
    r.root do
      phlex_code = r.params['phlex_code']
      params_code = r.params['params']
      AppLayoutComponent.new(phlex_code, params_code).call
    end

    r.get 'select_component' do
      name    = r.params['name']
      args    = r.params['args'] || []
      kw_args = r.params['kw_args']&.flat_map { |k, v| [k.to_sym, v] }
      kw_args = kw_args.present? ? Hash[*kw_args] : {}
      AppLayoutComponent.new(name, *args, explanatory_component: r.params['explanation'], **kw_args).call
    end

    r.post 'render' do
      code = r.params['code']

      # Create a temporary file to store the class definition
      file = Tempfile.new(['phlex_preview', '.rb'])
      begin
        file.write(code)
        file.close

        # Dynamically load the class from the file
        load file.path
        instance = eval r.params['params']

        # Render the instance of the newly defined class
        response['Content-Type'] = 'text/html'
        html = instance.call
        RenderedResultsPreviewComponent.new(html).call
      rescue => e
        response.status = 422
        e.message + "\n" + e.backtrace.join("<br/>\n")
      ensure
        file.unlink # Delete the temp file
      end
    end

    r.post 'load' do
      pp r.params
      tempfile = r.params['file'][:tempfile]
      content = File.read(tempfile)

      # Extracting Phlex code
      phlex_code = content

      # Extracting invocation parameters
      params_match = content.match(/# Sample invocation:(.*?)# end Sample invocation/mi)
      params_code = params_match[1].strip.gsub(/^#/, '') if params_match
      puts "params_code = |#{params_code}|"
      response.redirect "/?phlex_code=#{URI.encode_www_form_component(phlex_code)}&params=#{URI.encode_www_form_component(params_code)}"
    end
  end
end
