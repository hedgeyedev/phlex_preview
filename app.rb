require 'roda'
require 'phlex'
require 'tempfile'
require 'uri'

require_relative 'application_component'
require_relative 'app_layout_component'
require_relative 'rendered_results_preview_component'
class PreviewApp < Roda
  plugin :render

  route do |r|
    r.root do
      phlex_code = r.params['phlex_code']
      params_code = r.params['params']
      # Assuming `AppLayout` is a Phlex component you have defined to layout the app
      AppLayoutComponent.new(phlex_code, params_code).call
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
      params_code = params_match[1].strip.gsub("#", '') if params_match
      puts "params_code = |#{params_code}|"
      response.redirect "/?phlex_code=#{URI.encode_www_form_component(phlex_code)}&params=#{URI.encode_www_form_component(params_code)}"

    end
  end
end
