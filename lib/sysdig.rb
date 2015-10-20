require "sysdig/version"

require "cistern"
require "faraday"
require "faraday_middleware"
require "faraday/cookie_jar"
require "logger"
require "ey/logger"
require "ey/logger/faraday"

class Sysdig
  include Cistern::Client

  recognizes :url, :adapter, :logger
  requires :username, :password

end

# clients
require 'sysdig/real'
require 'sysdig/mock'
require 'sysdig/model'
require 'sysdig/response'

require 'sysdig/login'

require 'sysdig/alert'
require 'sysdig/alerts'
require 'sysdig/create_alert'
require 'sysdig/get_alert'
require 'sysdig/get_alerts'
require 'sysdig/update_alert'

require 'sysdig/get_notification'
require 'sysdig/get_notifications'
require 'sysdig/notification'
require 'sysdig/notifications'
