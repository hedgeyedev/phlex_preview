# frozen_string_literal: true
module PhlexStorybook
	class ApplicationView < ApplicationComponent
		include Phlex::Rails::Helpers::CheckBox
		include Phlex::Rails::Helpers::FormFor
    include Phlex::Rails::Helpers::ImageTag
		include Phlex::Rails::Helpers::StylesheetLinkTag
		include Phlex::Rails::Helpers::JavascriptImportmapTags
		include Phlex::Rails::Helpers::JavascriptIncludeTag
		include Phlex::Rails::Helpers::AssetPath
		include Phlex::Rails::Helpers::PathToAsset
		include Phlex::Rails::Helpers::Request
		include Phlex::Rails::Helpers::Tag
		include ApplicationHelper
	end
end
