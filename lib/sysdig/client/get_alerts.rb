class Sysdig::Client::GetAlerts < Sysdig::Client::Request
  def real(params={})
    service.request(
      :method => :get,
      :path   => "/api/alerts",
    )
  end
end
