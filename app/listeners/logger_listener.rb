class LoggerListener
  def call(event)
    parts = [ "[ACTION]", event.name, "by", actor(event.user) ]
    parts += [ "on", "#{event.subject.class.name}##{event.subject.id}" ] if event.subject
    parts << event.details.to_json if event.details.present?
    Rails.logger.info(parts.join(" "))
  end

  private

  def actor(user)
    user&.email_address || "guest"
  end
end
