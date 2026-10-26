module AdminHelper
  def log_details(log)
    return "" if log.details.blank?

    log.details.compact_blank.map { |key, value| "#{key.to_s.humanize}: #{log_value(key, value)}" }.join(" · ")
  end

  def log_subject(log)
    return "—" if log.subject_type.blank?

    case log.subject
    when Photo then link_to("Photo ##{log.subject_id}", log.subject)
    when User then link_to(log.subject.name, edit_admin_user_path(log.subject))
    else "#{log.subject_type} ##{log.subject_id} (deleted)"
    end
  end

  def bar_percent(value, max)
    max.to_i.zero? ? 0 : (value * 100.0 / max).round(1)
  end

  private
    def log_value(key, value)
      case value
      when Hash then value.map { |inner_key, inner| "#{inner_key}=#{inner}" }.join(", ")
      when Integer then key.to_s == "byte_size" ? number_to_human_size(value) : value.to_s
      when Array then value.join(", ")
      else value.to_s
      end
    end
end
