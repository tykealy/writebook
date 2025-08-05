class MakeBookIdNullable < ActiveRecord::Migration[8.0]
  def change
    # Make book_id nullable
    change_column_null :leaves, :book_id, true

    # Add constraint
    add_check_constraint :leaves,
      "(book_id IS NOT NULL AND article_id IS NULL) OR (book_id IS NULL AND article_id IS NOT NULL)",
      name: "leaves_must_belong_to_book_or_article"

    # The existing indexes are fine! No need to change them.
    # add_index :leaves, :book_id     # Already exists
    # add_index :leaves, :article_id  # Already exists
  end
end
