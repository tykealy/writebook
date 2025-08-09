module Accessable
  extend ActiveSupport::Concern

  included do
    has_many :accesses, dependent: :destroy
    scope :with_everyone_access, -> { where(everyone_access: true) }
  end

  class_methods do
    def accessable_or_published(user: Current.user)
      if user.present?
        accessable_or_published_books
      else
        published
      end
    end

    def accessable_or_published_books(user: Current.user)
      user.books.or(published).distinct
    end
  end

  def accessable?(user: Current.user)
    accesses.exists?(user: user)
  end

  def editable?(user: Current.user)
    access_for(user: user)&.editor? || user&.administrator?
  end

  def access_for(user: Current.user)
    accesses.find_by(user: user)
  end
end
