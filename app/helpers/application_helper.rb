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

    "(#{t(session[:status_user])}) #{current_user.email}"
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

  private

  def logged_user_navbar
    "<li class='navbar-text'> <span> #{user_info} </span> </li>" \
    "<li class='nav-item'> #{button_to(t(:log_out), destroy_user_session_path, method: :delete, class: 'nav-link')}" \
    '</li>'.html_safe
  end
end
