class Leaf < ApplicationRecord
  include Editable, Positionable, Searchable

  belongs_to :book, touch: true, optional: true
  belongs_to :article, optional: true
  delegated_type :leafable, types: Leafable::TYPES, dependent: :destroy

  positioned_within :container,
                    association: :leaves,
                    filter: :active

  delegate :searchable_content, to: :leafable

  enum :status, %w[ active trashed ].index_by(&:itself), default: :active

  scope :with_leafables, -> { includes(:leafable) }

  # Validation to ensure leaf belongs to either book or article, but not both
  validates :book_id, presence: true, if: -> { article_id.blank? }
  validates :article_id, presence: true, if: -> { book_id.blank? }
  validates :book_id, absence: true, if: -> { article_id.present? }
  validates :article_id, absence: true, if: -> { book_id.present? }

  def slug
    title.parameterize.presence || "-"
  end

  private

  def container
    book || article
  end
end
