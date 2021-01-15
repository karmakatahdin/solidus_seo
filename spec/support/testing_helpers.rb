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

  def current_order_stubs(order)
    allow_any_instance_of(Spree::CheckoutController).to receive_messages(current_order: order)
    allow_any_instance_of(Spree::OrdersController).to receive_messages(current_order: order)
  end

  # Builds a regex matcher for script tag contents
  # @param tag_name [String] Value of script's data-tag attribute
  # @param matches [Array] Keywords that must appear in script contents (order matters!)
  # @return [Object] Returns a capybara matcher for a script tag with specific attributes and contents
  def track_analytics_event(tag_name, event_name, matches)
    matches = matches.flatten.map {|v| Regexp.escape(v.to_s) }.join('.+')
    have_selector :css, "script[data-tag=#{tag_name}][data-fired-events=#{event_name}]", visible: false, text: /#{matches}/i
  end
end
