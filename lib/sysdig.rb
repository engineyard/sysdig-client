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

  recognizes :url, :adapter, :logger, :token, :username, :password
end

# clients
require 'sysdig/real'
require 'sysdig/mock'
require 'sysdig/model'
require 'sysdig/response'

require 'sysdig/login'

require 'sysdig/alert_filter'

require 'sysdig/alert'
require 'sysdig/alerts'
require 'sysdig/create_alert'
require 'sysdig/destroy_alert'
require 'sysdig/get_alert'
require 'sysdig/get_alerts'
require 'sysdig/update_alert'

require 'sysdig/get_alert_notification'
require 'sysdig/get_alert_notifications'
require 'sysdig/update_alert_notification'
require 'sysdig/alert_notification'
require 'sysdig/alert_notifications'

require 'sysdig/get_user_notifications'
require 'sysdig/update_user_notifications'
require 'sysdig/user_notifications'
