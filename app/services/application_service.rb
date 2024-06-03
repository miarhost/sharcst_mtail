class ApplicationService
  include Errors::Helpers
  def initialize(*args); end

  def self.call(*args)
    new(*args).call
  end

  def call; end
end
