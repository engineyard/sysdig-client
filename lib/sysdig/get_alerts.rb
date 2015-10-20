class Sysdig::GetAlerts < Sysdig::Request
  def real(params={})
    service.request(
      :method => :get,
      :path   => "/api/alerts",
    )
  end
end
