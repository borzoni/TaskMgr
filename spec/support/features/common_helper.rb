# frozen_string_literal: true
module Features
  module CommonHelpers
    def expect_flash_with(msg)
      expect(page).to have_css('.alert', count: 1, text: msg)
    end
  end
end
