class Sysdig::Client::Real
  attr_reader :url, :path, :connection, :parser, :logger, :adapter, :authentication

  def initialize(options={})
    @url = URI.parse(options[:url] || "https://app.sysdigcloud.com")

    adapter            = options[:adapter]            || Faraday.default_adapter
    connection_options = options[:connection_options] || {}
    logger, @logger    = options[:logger]             || Logger.new(nil)

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
      builder.use :cookie_jar

      builder.use Faraday::Response::RaiseError
      builder.use Ey::Logger::Faraday, format: :machine, device: logger

      builder.adapter(*adapter)
    end

    @username, @password = *options.values_at(:username, :password)

    @authentication = Mutex.new
    @authenticated  = false
  end

  def request(options={})
    if !@authenticated
      @authentication.synchronize {
        if !@authenticated
          login(@username, @password)
          @authenticated = true
        end
      }
    end

    _request(options)
  end

  def authenticate!
    _request(
      :method => :post,
      :path   => "/api/login",
      :params => { username: @username, password: @password },
    )
  end

  protected

  def _request(options={})
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
end
