Erp::Ability.class_eval do
  def products_ability(user)
    
    can :read, Erp::Products::Product

    can :update, Erp::Products::Product do |product|
      !product.archived?
    end

    can :archive, Erp::Products::Product do |product|
      !product.archived?
    end

    can :unarchive, Erp::Products::Product do |product|
      product.archived?
    end
    
    if Erp::Core.available?("ortho_k")
      can :combine, Erp::Products::Product do |product|
        !product.archived? and !product.parts.empty?
      end
  
      can :split, Erp::Products::Product do |product|
        !product.archived? and !product.parts.empty?
      end
    end
  end
end
