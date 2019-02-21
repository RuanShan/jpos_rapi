module Selling
  class PrepaidCard < Spree::Product
    extend DisplayEnum
    # enum status:[ created, approved, disapproved]
    default_scope { where( card_style: 0 ) }
    enum card_expire_in: { year: 0, month: 30, week: 7 }, _suffix: true

    [
      :card_discount_percent, :card_discount_amount, :card_expire_in
    ].each do |method_name|
      delegate method_name, :"#{method_name}=", to: :find_or_build_master
    end

    display_enum_methods :card_expire_in

    # Returns all the Spree::RelationType's which apply_to this class.
    def relation_types
      Spree::RelationType.where(applies_to: to_relation_name).order(:name)
    end

    def to_relation_name
      "#{self.type}##{self.id}"
    end
  end
end
