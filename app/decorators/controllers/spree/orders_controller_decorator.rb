# frozen_string_literal: true

module Spree
  module OrdersControllerDecorator
    def self.prepended(base)
      base.class_eval do
        around_action :calculate_cart_diff, only: :populate
      end
    end

    private

    def calculate_cart_diff
      previous_cart_items = order_contents_hash

      yield

      current_cart_items = order_contents_hash

      cart_diff = current_cart_items.map do |variant_sku, quantity|
        added_quantity = quantity - (previous_cart_items[variant_sku] || 0)

        [variant_sku, added_quantity.positive? ? added_quantity : nil]
      end.to_h.compact

      cart_diff = cart_diff.map do |variant_sku, quantity|
        variant_hash = cart_diff_variant_payload(variant_sku)
        variant_hash[:quantity] = quantity

        [variant_sku, variant_hash]
      end.to_h

      flash[:added_to_cart] = cart_diff if cart_diff.present?
    end

    def cart_diff_variant_payload(sku)
      variant = Spree::Variant.find_by(sku: sku)

      {
        id: variant.product.master.sku,
        name: variant.product.name,
        variant: variant.options_text,
        price: variant.price
      }
    end

    def order_contents_hash
      return {} if current_order.blank?

      current_order.line_items.each_with_object({}) do |li, acc|
        acc[li.variant.sku] ||= 0
        acc[li.variant.sku] += li.quantity
      end
    end

    ::Spree::StoreController.prepend(self)
  end
end
