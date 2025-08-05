class AddArticleIdToAccesses < ActiveRecord::Migration[8.0]
  def change
    add_column :accesses, :article_id, :integer, null: true

    add_check_constraint :accesses,
      "(book_id IS NOT NULL AND article_id IS NULL) OR (book_id IS NULL AND article_id IS NOT NULL)",
      name: "accesses_must_belong_to_book_or_article"

    add_index :accesses, :article_id
    add_index :accesses, [ :user_id, :article_id ], unique: true, name: "index_accesses_on_user_id_and_article_id"

    change_column_null :accesses, :book_id, true
  end
end
