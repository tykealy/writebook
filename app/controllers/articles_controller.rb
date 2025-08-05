# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  before_action :set_article, only: %i[ show edit update destroy ]
  # before_action :ensure_editable, only: %i[ edit update destroy ]
  before_action :set_users, only: %i[ new edit ]

  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.create! article_params
    update_accesses(@article)
    redirect_to slugged_article_url(@article, @article.slug)
  end

  def show
    # Article shows its single page content
    @leaf = @article.leaf
  end

  def edit
    @leaf = @article.leaves.first
  end

  def update
    @article.update(article_params)
    update_accesses(@article)

    # Update the page content if provided
    if page_params.present?
      @article.page.update!(page_params)
    end

    redirect_to slugged_article_url(@article, @article.slug)
  end

  def destroy
    @article.destroy
    redirect_to articles_url
  end
  def set_users
    @users = User.active.ordered
  end

  private

    def set_article
      @article = Article.find(params[:id])
    end

    def ensure_editable
      head :forbidden unless @article.editable?
    end

    def article_params
      params.require(:article).permit(:title, :subtitle, :author, :everyone_access, :theme, :cover)
    end

    def page_params
      params.fetch(:page, {}).permit(:body)
    end

    def update_accesses(article)
      editors = [ Current.user.id, *params[:editor_ids]&.map(&:to_i) ]
      readers = [ Current.user.id, *params[:reader_ids]&.map(&:to_i) ]
      article.update_access(editors: editors, readers: readers)
    end
end
