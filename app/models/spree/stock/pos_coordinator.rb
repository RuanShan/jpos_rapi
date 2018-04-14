module Spree
  module Stock
    class PosCoordinator < Coordinator
      attr_reader   :order, :inventory_units
      attr_accessor :unallocated_inventory_units

      def initialize(order, inventory_units = nil)
        @order = order
        @inventory_units = inventory_units || InventoryUnitBuilder.new(order).units
      end

      def shipments
        stock_location = Spree::StockLocation.active.first
        raise new Exception('system required at least one stock location') if stock_location.blank?

        shipments_map = {}
        order.line_items.each{|line_item|
          if shipments_map[line_item.group_number].blank?
            shipments_map[line_item.group_number] = Spree::Shipment.new(
              stock_location: stock_location,
              group_number: line_item.group_number
            )
          end
        }

        shipments_map.values
      end

    
    end
  end
end
