class Sysdig::UpdateAlertNotifications < Sysdig::Request
  def self.params
    %w[alert condition entities filter resolved severity state timespan timestamp]
  end

  def self.slice(notification)
    Cistern::Hash.slice(notification, *Cistern::Hash.stringify_keys(notification))
  end

  def real(notification_id, notification)
    service.request(
      :method => :put,
      :path   => File.join("/api/notifications", notification_id.to_s),
      :body   => { "notification" => self.class.slice(notification) },
    )
  end

  def mock(notification_id, notification)
    update_notification   = self.class.slice(notification)
    existing_notification = service.data[:alert_notifications].fetch(notification_id)

    service.response(
      :body => { "notification" => existing_notification.merge!(update_notification) },
    )
  end
end
