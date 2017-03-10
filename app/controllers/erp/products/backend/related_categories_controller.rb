module Erp
  module Products
    module Backend
      class RelatedCategoriesController < Erp::Backend::BackendController
        def related_category_line_form
          @related_category = RelatedCategory.new
          @related_category.category_id = params[:add_value]
          
          render partial: params[:partial], locals: {
            related_category: @related_category,
            uid: helpers.unique_id()
          }
        end
      end
    end
  end
end
