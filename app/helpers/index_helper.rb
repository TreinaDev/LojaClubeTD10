module IndexHelper
  def show_price(product)
    return unless user_signed_in? && current_user.common?

    if @conversion_tax.present?
      number = number_with_delimiter((product.price * @conversion_tax['conversion_tax'].to_f).round, delimiter: ".")
      content_tag(:p, "#{number} Pontos")
    end
  end
end
