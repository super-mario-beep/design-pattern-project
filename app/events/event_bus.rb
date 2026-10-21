class EventBus
  class << self
    def subscribe(listener)
      listeners << listener
    end

    def publish(name, user: nil, subject: nil, details: {})
      event = Event.new(name: name, user: user, subject: subject, details: details)
      listeners.each { |listener| listener.call(event) }
      event
    end

    private

    def listeners
      @listeners ||= []
    end
  end
end
