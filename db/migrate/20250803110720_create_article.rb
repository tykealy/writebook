class CreateArticle < ActiveRecord::Migration[8.0]
  def change
    create_table "articles", force: :cascade do |t|
      t.string "title", null: false
      t.string "subtitle"
      t.string "author"
      t.string "slug", null: false
      t.boolean "published", default: false
      t.boolean "everyone_access", default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "theme", default: "blue"

      t.index [ "slug" ], name: "index_articles_on_slug", unique: true
      t.index [ "published" ], name: "index_articles_on_published"
    end
  end
end
