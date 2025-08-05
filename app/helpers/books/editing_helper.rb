module Books::EditingHelper
  def editing_mode_toggle_switch(leaf, checked:)
    if leaf.book_id.present?
      target_url = checked ? leafable_slug_path(leaf) : edit_leafable_path(leaf)
      render "books/edit_mode", target_url: target_url, checked: checked
    elsif leaf.article_id.present?
      target_url = checked ? slugged_article_path(leaf.article, leaf.article.slug, leaf.id, leaf.slug) : edit_article_page_path(leaf.article, leaf)
      render "books/edit_mode", target_url: target_url, checked: checked
    end
  end
end
