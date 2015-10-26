class Sysdig::UpdateAlertNotification < Sysdig::Request
  def self.params
    %w[alert condition entities filter resolved severity state timespan timestamp]
  end

  def slice(notification)
    Cistern::Hash.slice(notification, *Cistern::Hash.stringify_keys(self.class.params))
  end

  # "notification"=>
  # {"timestamp"=>1445878320000000,
  #  "severity"=>2,
  #  "filter"=>
  # "container.name = 'deis-builder' and agent.tag.id = '8dbf0cfb-7b4b-42ea-b1f1-b742a5bdebf4'",
  #   "timespan"=>60000000,
  #   "condition"=>"timeAvg(uptime) = 0",
  #   "entities"=>
  # [{"filter"=>
  #   "container.name = 'deis-builder' and agent.tag.id = '8dbf0cfb-7b4b-42ea-b1f1-b742a5bdebf4'",
  #     "target"=>
  #   {"id"=>"group@agent_tag_id-8dbf0cfb-7b4b-42ea-b1f1-b742a5bdebf4",
  #    "type"=>"GROUP",
  #    "subTarget"=>[{"metric"=>"container.name", "value"=>"deis-builder"}]},
  #   "metricValues"=>
  #   [{"metric"=>"uptime", "aggregation"=>"timeAvg", "value"=>0}]}],
  # "state"=>"ACTIVE",
  # "resolved"=>true,
  # "alert"=>"31586"}}
  def real(notification_id, notification)
    service.request(
      :method => :put,
      :path   => File.join("/api/notifications", notification_id.to_s),
      :body   => { "notification" => self.slice(notification) },
    )
  end

  def mock(notification_id, notification)
    update_notification   = self.slice(notification)
    existing_notification = service.data[:alert_notifications].fetch(notification_id)

    service.response(
      :body => { "notification" => existing_notification.merge!(update_notification) },
    )
  end
end
