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
end
