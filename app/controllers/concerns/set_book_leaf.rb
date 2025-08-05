module SetBookLeaf
  extend ActiveSupport::Concern

  included do
    before_action :set_container
    before_action :set_leaf, :set_leafable, only: %i[ show edit update destroy ]
  end

  private

    def set_container
      if is_book?
        @container = Book.accessable_or_published.find(params[:book_id])
      else
        @container = Article.find(params[:article_id])
      end
    end

    def is_book?
      params[:book_id].present?
    end

    def set_leaf
      @leaf = @container.leaves.active.find(params[:id])
    end

    def set_leafable
      instance_variable_set "@#{instance_name}", @leaf.leafable
    end

    def ensure_editable
      head :forbidden unless @container.editable?
    end

    def model_class
      controller_leafable_name.constantize
    end

    def instance_name
      controller_leafable_name.underscore
    end

    def controller_leafable_name
      self.class.to_s.remove("Controller").demodulize.singularize
    end
end
