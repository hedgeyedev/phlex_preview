# frozen_string_literal: true

Phlex::SELECTABLE_COMPONENTS = []

require 'phlex'
require 'active_support'
require 'active_support/core_ext'
require_relative 'components/application_component'
require_relative 'components/app_layout_component'
require_relative 'components/rendered_results_preview_component'
require_relative 'components/phlex_preview_app'
require_relative 'components/component_selector'
require_relative 'components/validateable_input'
require_relative 'components/labelized_checkbox'
require_relative 'components/labelized_input'
require_relative 'components/labelized_magnitude_input'

relative_requirer = ->(f) { require_relative File.join('components', File.basename(f, '.rb')) }
Dir.glob(File.join(__dir__, 'components', '*.rb')).each do |f|
  require_relative File.join('components', File.basename(f, '.rb'))
end
