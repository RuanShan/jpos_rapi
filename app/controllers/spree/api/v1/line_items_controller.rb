module Spree
  module Api
    module V1
      class LineItemsController < Spree::Api::BaseController
        class_attribute :line_item_options

        self.line_item_options = []

        # 确认工作量，associate worker with line_items
        def fulfill
          worker_id = params[:worker_id]
          ids = params[:ids]
          @line_items = Spree::LineItem.includes(:line_item_group, :order).find( ids )
          worker_times = @line_items.select{|i| i.worker_id> 0 }.map{ |i| [i.worker_id, i.work_at] }.uniq
          # update_column skip callback, or cause error:
          # NoMethodError: undefined method `set_up_inventory' for nil:NilClass
          # from /var/www/apps/jpos_rapi/app/models/spree/order_inventory.rb:80:in `add_to_shipment'
          Spree::LineItem.where( id: ids ).update_all( worker_id: worker_id, work_at: DateTime.current, state: 1 )

          #重新统计工人每天工作量
          worker_times.each{ |worker_time_pair|
            worker_id, time = worker_time_pair[0], worker_time_pair[1]
            worker = User.find worker_id
            worker.sale_today.recompute_processed_line_items_count
          }
          #改变订单状态
          @line_items.each{ |li|
            states = li.order.line_items.pluck(:state)
            #无需判断 状态为:done， 前一步已经更新为 done 了
            if states.uniq.size == 1
              li.line_item_group.next
            end
          }

          respond_with(@line_items)
        end

        def new; end

        def create
          variant = Spree::Variant.find(params[:line_item][:variant_id])
          @line_item = order.contents.add(
            variant,
            params[:line_item][:quantity] || 1,
            line_item_params[:options] || {}
          )

          if @line_item.errors.empty?
            respond_with(@line_item, status: 201, default_template: :show)
          else
            invalid_resource!(@line_item)
          end
        end

        def update
          @line_item = find_line_item
          if @order.contents.update_cart(line_items_attributes)
            @line_item.reload
            respond_with(@line_item, default_template: :show)
          else
            invalid_resource!(@line_item)
          end
        end

        def destroy
          @line_item = find_line_item
          @order.contents.remove_line_item(@line_item)
          respond_with(@line_item, status: 204)
        end

        private

        def order
          @order ||= Spree::Order.includes(:line_items).find_by!(number: order_id)
          authorize! :update, @order, order_token
        end

        def find_line_item
          id = params[:id].to_i
          order.line_items.detect { |line_item| line_item.id == id } or
            raise ActiveRecord::RecordNotFound
        end

        def line_items_attributes
          { line_items_attributes: {
              id: params[:id],
              quantity: params[:line_item][:quantity],
              options: line_item_params[:options] || {}
          } }
        end

        def line_item_params
          params.require(:line_item).permit(:quantity, :variant_id, options: line_item_options)
        end
      end
    end
  end
end
