module ApplicationHelper
  def carousel_item(index)
    if index.zero?
      "class='carousel-item active'".html_safe
    else
      "class='carousel-item'".html_safe
    end
  end

  def user_info
    return "#{current_user.email} (ADMIN)" if current_user.admin?

    status = session[:status_user]
    "#{status ? "(#{t(status)}) " : ''}#{current_user.email}"
  end

  def user_links
    if user_signed_in?
      logged_user_navbar
    else
      "<li class='nav-item'> #{link_to(t(:create_account), new_user_registration_path, class: 'nav-link')} </li>" \
      "<li class='nav-item'> #{link_to(t(:login), new_user_session_path, class: 'nav-link')} </li>".html_safe
    end
  end

  def link_to_customer_area
    return unless user_signed_in? && current_user.common?

    "<li class='nav-item'>" \
    "#{link_to(raw("<i class='bi bi-person-circle'></i> #{t(:client_area)}"), customer_areas_path,
               class: 'nav-link')}" \
    '</li>'.html_safe
  end

  def nav_link_to(text, url)
    if current_page?(url)
      link_to(text, url, class: 'nav-link active')
    else
      link_to(text, url, class: 'nav-link')
    end
  end

  def show_price(price)
    if current_user&.common?
      show_common_user_price(price)
    elsif current_user&.admin?
      show_admin_price(price)
    end
  end

  def show_promotional_price(product, company)
    return show_price(product.price) if current_user&.admin?

    if product.lowest_price(company) == product.price
      "#{show_price(product.price)} Pontos"
    else
      text_promotional(product, company)
    end
  end

  def load_discount(product, company)
    return if current_user&.admin?

    return unless product.lowest_price(company) != product.price

    discount = 100 - (product.lowest_price(company) / product.price * 100)
    "#{discount.round}% OFF"
  end

  def load_end_data(product, company)
    return if current_user&.admin? || company.blank?

    offer_end_date_message(product, company)
  end

  private

  def offer_end_date_message(product, company)
    sc = product.current_seasonal_price
    pc = product.find_promotional_campaign(company.promotional_campaigns)
    if sc.present? && pc.present?
      "Oferta válida até #{l(compare_prices(product, company))}"
    elsif pc
      "Oferta válida até #{l(pc.end_date)}"
    elsif sc
      "Oferta válida até #{l(sc.end_date)}"
    end
  end

  def compare_prices(product, company)
    if product.lowest_price(company) == product.current_seasonal_price.value
      return product.current_seasonal_price.end_date
    end

    product.find_promotional_campaign(company.promotional_campaigns).end_date
  end

  def text_promotional(product, company)
    content_tag :div do
      content_tag(:span, "De\s") +
        content_tag(:span, show_price(product.price).to_s, class: 'text-danger text-decoration-line-through') +
        content_tag(:span, "\spor\s") +
        content_tag(:span, show_price(product.lowest_price(company)).to_s, class: 'fw-bold text-success') +
        content_tag(:span, "\sPontos")
    end
  end

  def show_common_user_price(price)
    return if current_user.card_info.nil? || session[:status_user] != 'unblocked'

    number_with_delimiter((price * current_user.card_info.conversion_tax.to_f).round,
                          delimiter: '.')
  end

  def show_admin_price(price)
    number_to_currency price.to_s
  end

  def logged_user_navbar
    "<li class='navbar-text'> <span> #{user_info} </span> </li>" \
    "<li class='nav-item'> #{button_to(t(:log_out), destroy_user_session_path, method: :delete, class: 'nav-link')}" \
    '</li>'.html_safe
  end
end
