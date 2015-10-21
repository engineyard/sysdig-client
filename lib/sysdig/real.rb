class Sysdig::Real

  attr_reader :url, :path, :connection, :parser, :logger, :adapter, :authentication, :token

  def initialize(options={})
    @url = URI.parse(options[:url] || "https://app.sysdigcloud.com")

    adapter            = options[:adapter]            || Faraday.default_adapter
    connection_options = options[:connection_options] || {}
    logger, @logger    = options[:logger]             || Logger.new(nil)

    @username, @password = *options.values_at(:username, :password)

    unless @username && @password
      token = @token = options.fetch(:token)
    end

    @authentication = Mutex.new
    @authenticated  = false

    @connection = Faraday.new({url: @url}.merge(connection_options)) do |builder|
      # response
      builder.response :json

      # request
      builder.request :retry,
        :max                 => 30,
        :interval            => 1,
        :interval_randomness => 0.05,
        :backoff_factor      => 2
      builder.request :multipart
      builder.request :json

      if token
        builder.authorization :Bearer, token
      else
        builder.use :cookie_jar
      end

      builder.use Faraday::Response::RaiseError
      builder.use Ey::Logger::Faraday, format: :machine, device: logger

      builder.adapter(*adapter)
    end
  end

  def request_with_authentication(options={})
    if !@authenticated && token.nil?
      @authentication.synchronize {
        if !@authenticated
          login(@username, @password)
          @authenticated = true
        end
      }
    end

    request_without_authentication(options)
  end

  def request_without_authentication(options={})
    method  = (options[:method] || "get").to_s.downcase.to_sym
    url     = URI.parse(options[:url] || File.join(@url.to_s, options[:path] || "/"))
    params  = options[:params] || {}
    body    = options[:body]
    headers = options[:headers] || {}

    headers["Content-Type"] ||= if body.nil?
                                  if !params.empty?
                                    "application/x-www-form-urlencoded"
                                  else # Rails infers a Content-Type and we must set it here for the canonical string to match
                                    "text/plain"
                                  end
                                end

    response = @connection.send(method) do |req|
      req.url(url.to_s)
      req.headers.merge!(headers)
      req.params.merge!(params)
      req.body = body
    end

    Sysdig::Response.new(
      :status  => response.status,
      :headers => response.headers,
      :body    => response.body,
      :request => {
        :method  => method,
        :url     => url,
        :headers => headers,
        :body    => body,
        :params  => params,
      }
    ).raise!
  end

  alias_method :request, :request_with_authentication
end
