class AddArticleIdToLeaves < ActiveRecord::Migration[8.0]
  def change
    add_reference :leaves, :article, foreign_key: true, null: true
  end
end
