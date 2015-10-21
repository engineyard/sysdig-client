module ClientHelper
  def create_client(attributes={})
    merged_attributes = attributes.dup

    verbose = !!ENV['VERBOSE']

    if verbose
      merged_attributes.merge!(logger: Logger.new(STDERR))
    end

    Sysdig.new(merged_attributes.merge(adapter: :net_http_persistent))
  end
end

RSpec.configure { |config|
  config.include(ClientHelper)
  config.before { Sysdig.reset! }
  config.before {
    unless Sysdig.mocking?
      create_client.reset!
    end
  }
}
