module ApplicationHelper
  def alert_message?
    ( !flash[:success].blank? or !flash[:danger].blank? )
  end

  def alert_type
    return 'alert-success' unless flash[:success].blank?
    return 'alert-danger'  unless flash[:danger].blank?
  end

  def alert_content
    if !flash[:success].blank?
      flash[:success]
    elsif !flash[:danger].blank?
      flash[:danger]
    else
      ''
    end
  end

  def relative_days(object)
    start_date = object.try(:start_date)
    end_date = object.try(:end_date)

    return "" if start_date.nil? && end_date.nil?

    today = Time.now.to_date

    if today < end_date
      "Finaliza en #{time_ago_in_words(end_date)}, #{I18n.l(end_date, format: :short)}"
    elsif today == end_date
      "Finaliza hoy, #{I18n.l(end_date, format: :short)}"
    else
      "Finalizó hace #{time_ago_in_words(end_date)}, #{I18n.l(end_date, format: :short)}"
    end
  end

  def short_text(text, length = 100)
    if text.length > length
      "#{text[0..length]}..."
    else
      text
    end
  end

  def remaining_constraints(activity)
    removed_count = activity.constraints.removed.count
    total_count   = activity.constraints.count

    "#{removed_count}/#{total_count}"
  end

  def date_range_from_query(query)
    range = query.where_values.last.right.children
    range.map{ |d| l(d, format: :short) }.join(' - ')
  end

  # def options_from_collection_for_select(collection, value_method, text_method, selected = nil)
  #   options =
  #     if collection.is_a?(ActiveRecord::Relation) && ['User', 'ProjectMember'].include?(collection.klass.to_s) && user_signed_in?
  #       collection.map do |element|
  #         user_name = (element.try(:user) || element == current_user) ? "#{element.send(text_method)} (yo)" : element.send(text_method)
  #         [user_name, value_for_collection(element, value_method), option_html_attributes(element)]
  #       end
  #     else
  #       collection.map do |element|
  #         [value_for_collection(element, text_method), value_for_collection(element, value_method), option_html_attributes(element)]
  #       end
  #     end

  #   selected, disabled = extract_selected_and_disabled(selected)
  #   select_deselect = {
  #     selected: extract_values_from_collection(collection, value_method, selected),
  #     disabled: extract_values_from_collection(collection, value_method, disabled)
  #   }

  #   options_for_select(options, select_deselect)
  # end
end
