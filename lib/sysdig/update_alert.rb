class Sysdig::UpdateAlert < Sysdig::Request
  def real(alert_id, alert)
    #{"alert":{"version":7,"createdOn":1438965688000,"modifiedOn":1442349562000,"name":"Memory usage critical","description":"Memory utilization is currently >= 98%","enabled":false,"filter":null,"type":"MANUAL","condition":"timeAvg(memory.used.percent) >= 98","timespan":60000000,"severity":2,"notify":["SNS"],"segmentBy":["agent.tag.id"],"segmentCondition":{"type":"ANY"}}}
    # @todo alert[version] might mean lock version which should be fun
    service.request(
      :method => :put,
      :path   => File.join("/api/alerts", alert_id.to_s),
      :body   => { "alert" => alert },
    )
  end
end
