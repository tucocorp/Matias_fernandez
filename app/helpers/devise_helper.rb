module DeviseHelper
  def devise_error_messages!
    html = ""

    unless @user.blank?
      @user.errors.full_messages.each do |e|
        html += "#{e}<br/>"
      end
    end
	html.html_safe
  end
end