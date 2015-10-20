class Sysdig::CreateAlerts < Sysdig::Request
  def real(alert)
    service.request(
      :method => :post,
      :path   => "/api/alerts",
      :body   => { "alert" => alert },
    )
  end
end
