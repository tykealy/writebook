# app/models/article.rb
class Article < ApplicationRecord
  include Sluggable, Accessable

  has_many :leaves, dependent: :destroy

  has_one_attached :cover, dependent: :purge_later

  enum :theme, %w[ black blue green magenta orange violet white ].index_by(&:itself), suffix: true, default: :blue

  scope :ordered, -> { order(:title) }
  scope :published, -> { where(published: true) }

  after_create :create_initial_page

  def page
    leaves.where(leafable_type: "Page").first&.leafable
  end

  def searchable_content
    page&.searchable_content
  end

  def update_access(editors:, readers:)
    editors = Set.new(editors)
    readers = Set.new(everyone_access? ? User.active.ids : readers)

    all = editors + readers
    all_accesses = all.collect { |user_id|
      { user_id: user_id, level: editors.include?(user_id) ? :editor : :reader }
    }

    accesses.upsert_all(all_accesses, unique_by: [ :article_id, :user_id ])
    accesses.where.not(user_id: all).delete_all
  end

  def readers
    accesses.reader.includes(:user).map(&:user)
  end

  def editors
    accesses.editor.includes(:user).map(&:user)
  end

  def collaborators
    accesses.includes(:user).map(&:user)
  end

  private
    def create_initial_page
      initial_page = Page.create!(body: "")
      Leaf.create!(
        article: self,  # Use article instead of book
        leafable: initial_page,
        title: self.title,
        position_score: 1.0,
        status: :active
      )
    end
end
