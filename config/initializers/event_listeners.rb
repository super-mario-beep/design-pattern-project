# Subscribed inside to_prepare so listeners are registered again after code reloads in development
Rails.application.config.to_prepare do
  EventBus.subscribe(ActionLogListener.new)
  EventBus.subscribe(LoggerListener.new)
end
