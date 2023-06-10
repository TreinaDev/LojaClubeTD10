module ApplicationHelper
  def user_info
    return "#{current_user.email} (ADMIN)" if current_user.admin?

    current_user.email
  end

  def user_links
    if user_signed_in?
      logged_user_navbar
    else
      "<li class='nav-item'> #{link_to(t(:create_account), new_user_registration_path, class: 'nav-link')} </li>" \
      "<li class='nav-item'> #{link_to(t(:login), new_user_session_path, class: 'nav-link')} </li>".html_safe
    end
  end

  private

  def logged_user_navbar
    "<li class='nav-item'> #{link_to(user_info, edit_user_registration_path, class: 'nav-link')} </li>" \
    "<li class='nav-item'> #{button_to(t(:logout), destroy_user_session_path, method: :delete, class: 'nav-link')}" \
    '</li>' \
    "<li class='nav-item'> #{link_to(t(:client_area), customer_area_index_path, class: 'nav-link')}" \
    '</li>'.html_safe
  end
end
