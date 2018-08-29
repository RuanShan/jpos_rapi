module DisplayEnum
  ##
  # Takes a list of methods that the base object wants to be able to use
  # to display with Spree::Money, and turns them into display_* methods.
  # Intended to help clean up some of the presentational logic that exists
  # at the model layer.
  #
  #
  # ==== Examples
  # Decorate a method, with the default option of using the base object's
  # currency
  # class Product < ApplicationRecord
  #     extend DisplayEnum
  #     enum status:[ created, approved, disapproved]
  #     display_enum_methods :status
  # end
  # locale.yml
  # zh-CN:
  #  activerecord:
  #    attributes:
  #      product:
  #       statuses:
  #         created: 创建
  #         approved: 审核通过
  #         disapproved: 审核未通过
  # Decorate a method, but with some additional options
  def display_enum_methods(*args)
    args.each do |enum_method|
      enum_method = { enum_method => {} } unless enum_method.is_a? Hash
      enum_method.each do |enum_name, opts|
        define_method("display_#{enum_name}") do
          enum_value = send enum_name
          I18n.t("activerecord.attributes.#{self.class.model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
        end
      end
    end
  end
end
