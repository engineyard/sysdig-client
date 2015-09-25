require "sysdig/version"

class Sysdig::Client < Cistern::Service

  recognizes :url, :adapter, :logger
  requires :username, :password

end

# clients
require 'sysdig/client/real'
require 'sysdig/client/mock'
require 'sysdig/client/model'
require 'sysdig/client/response'

require 'sysdig/client/alert'
require 'sysdig/client/alerts'
require 'sysdig/client/get_alerts'
require 'sysdig/client/get_notification'
require 'sysdig/client/get_notifications'
require 'sysdig/client/login'
require 'sysdig/client/notification'
require 'sysdig/client/notifications'
