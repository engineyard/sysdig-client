class Sysdig::GetAlertNotification < Sysdig::Request
  def real(notification_id)
    service.request(
      :path => File.join("/api/notifications", notification_id.to_s),
    )
  end

  def mock(notification_id)
    service.response(
      :body => {
        "notification" => service.data[:alert_notifications].fetch(notification_id.to_i)
      },
    )
  end
end
