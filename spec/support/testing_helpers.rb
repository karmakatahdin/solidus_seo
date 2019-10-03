module TestingHelpers
  def add_stubs(target, atts = {})
    target = create(target.to_sym) if target.is_a? Symbol

    target.tap do |it|
      atts.each do |(attr, v)|
        allow_any_instance_of(it.class).to receive(attr.to_sym) { v }
      end
    end
  end
end
