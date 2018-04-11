module Spree
  module Stock
    module Splitter
      class Pos < Spree::Stock::Splitter::Base
        def split(packages)
          split_packages = packages.flat_map(&method(:split_by_lineitem))
          return_next(split_packages)
        end

        private

        def split_by_lineitem(package)
          if package.order.is_pos?
            package.contents.map{| content_item|
              build_package( [content_item] )
            }
          else
            [package]
          end
        end

      end
    end
  end
end
