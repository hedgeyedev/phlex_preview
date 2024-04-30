require 'roda'
require 'phlex'
require 'tempfile'

require_relative 'application_component'
require_relative 'app_layout_component'
require_relative 'rendered_results_preview_component'
class PreviewApp < Roda
  plugin :render

  route do |r|
    r.root do
      # Assuming `AppLayout` is a Phlex component you have defined to layout the app
      AppLayoutComponent.new.call
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
  end
end
