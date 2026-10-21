class ActionLogListener
  def call(event)
    ActionLog.create!(
      user: event.user,
      action: event.name,
      subject: event.subject,
      details: event.details,
      created_at: event.occurred_at
    )
  end
end
