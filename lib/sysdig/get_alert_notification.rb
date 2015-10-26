class Sysdig::GetAlertNotification < Sysdig::Request
  def real(notification_id)
    service.request(
      :path => File.join("/api/notifications", notification_id.to_s),
    )
  end
end
