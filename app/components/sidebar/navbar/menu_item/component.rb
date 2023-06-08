module Sidebar
  module Navbar
    module MenuItem
      class Component < ApplicationViewComponent
        with_collection_parameter :item

        def initialize(item:)
          super

          @item = item
        end
      end
    end
  end
end
