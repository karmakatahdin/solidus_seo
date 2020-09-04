module TestingHelpers
  def add_stubs(target, atts = {})
    target = create(target.to_sym) if target.is_a? Symbol

    target.tap do |it|
      klass = [Class, Module].include?(target.class) ? target : target.class
      atts.each do |(attr, v)|
        allow_any_instance_of(klass).to receive(attr.to_sym) { v }
      end
    end
  end

  def checkout_stubs(order, user = nil)
    user ||= order.user
    allow_any_instance_of(Spree::CheckoutController).to receive_messages(current_order: order)

    if user
      allow_any_instance_of(Spree::CheckoutController).to receive_messages(try_spree_current_user: user)
      allow_any_instance_of(Spree::OrdersController).to receive_messages(try_spree_current_user: user)
    end
  end
end
