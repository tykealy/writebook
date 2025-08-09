# app/models/article.rb
class Article < ApplicationRecord
  include Sluggable, Accessable

  has_many :leaves, dependent: :destroy
  has_one :page, through: :leaves

  has_one_attached :cover, dependent: :purge_later

  enum :theme, %w[ black blue green magenta orange violet white ].index_by(&:itself), suffix: true, default: :blue

  scope :ordered, -> { order(:title) }
  scope :published, -> { where(published: true) }

  after_create :create_initial_page

  def searchable_content
    page&.searchable_content
  end

  private
    def create_initial_page
      Page.new(body: "")
      Leaf.create!(
        article: self,  # Use article instead of book
        leafable: page,
        title: self.title,
        position_score: 1.0,
        status: :active
      )
    end
end
