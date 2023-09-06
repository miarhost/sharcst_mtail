class ApplicationService
  def initialize(*args); end

  def self.call(*args)
    new(*args).call
  end

  def call; end
end
