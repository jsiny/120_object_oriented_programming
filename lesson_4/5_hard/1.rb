class SecretFile
  def initialize(secret_data, logger)
    @data = secret_data
    @logger = logger  # SecurityLogger object
  end

  private

  def data
    @logger.create_log_entry
    @data
  end
end

class SecurityLogger
  def create_log_entry
    # ... implementation omitted ...
  end
end
