class Access < ApplicationRecord
  enum :level, %w[ reader editor ].index_by(&:itself)

  belongs_to :user
  belongs_to :book, optional: true
  belongs_to :article, optional: true

  # Validation to ensure access belongs to either book or article, but not both
  validates :book_id, presence: true, if: -> { article_id.blank? }
  validates :article_id, presence: true, if: -> { book_id.blank? }
  validates :book_id, absence: true, if: -> { article_id.present? }
  validates :article_id, absence: true, if: -> { book_id.present? }
end
