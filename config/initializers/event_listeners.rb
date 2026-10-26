Rails.application.config.to_prepare do
  EventBus.subscribe(ActionLogListener.new)
  EventBus.subscribe(LoggerListener.new)
end
