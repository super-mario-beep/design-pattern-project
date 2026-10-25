class UploadCheck
  def set_next(next_check)
    @next_check = next_check
  end

  def check(user, file)
    problem(user, file) || @next_check&.check(user, file)
  end

  private
    def problem(user, file)
      raise NotImplementedError
    end

    def human_size(bytes)
      ActiveSupport::NumberHelper.number_to_human_size(bytes)
    end
end
