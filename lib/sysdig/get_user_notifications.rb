class Sysdig::GetUserNotifications < Sysdig::Request
  def real
    service.request(
      :method => :get,
      :path   => "/api/settings/notifications",
    )
  end

  def mock
    service.response(
      :body => { "userNotification" => service.data[:user_notifications] }
    )
  end
end
