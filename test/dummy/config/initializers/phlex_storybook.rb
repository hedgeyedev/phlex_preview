# frozen_string_literal: true

Dir[Rails.root.join("app/components/**/*.rb").to_s].each { |file| require file }
