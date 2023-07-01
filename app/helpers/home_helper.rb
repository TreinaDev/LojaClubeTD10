module HomeHelper
  def carousel_item(index)
    if index.zero?
      "class='carousel-item active'".html_safe
    else
      "class='carousel-item'".html_safe
    end
  end
end
