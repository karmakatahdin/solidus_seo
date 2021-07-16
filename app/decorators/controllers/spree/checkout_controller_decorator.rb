# frozen_string_literal: true

module Spree
  module CheckoutControllerDecorator
    def self.prepended(base)
      base.class_eval do
      end
    end

    def before_address
      flash[:checkout_initiated] =
        @order.address? &&
        request.referrer =~ /#{cart_path}\b/i &&
        params[:action] == 'edit'

      super
    end

    private

    ::Spree::StoreController.prepend(self)
  end
end
