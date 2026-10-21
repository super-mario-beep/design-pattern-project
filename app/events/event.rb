class Event
  attr_reader :name, :user, :subject, :details, :occurred_at

  def initialize(name:, user: nil, subject: nil, details: {})
    @name = name
    @user = user
    @subject = subject
    @details = details
    @occurred_at = Time.current
  end
end
