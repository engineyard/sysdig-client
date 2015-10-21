class Sysdig::UpdateUserNotifications < Sysdig::Request
  def real(notification)
    service.request(
      :method => :put,
      :path   => "/api/settings/notifications",
      :body   => { "userNotification" => notification },
    )
  end

  def mock(notification)
    user_notification = Cistern::Hash.slice(Cistern::Hash.stringify_keys(notification), "sns", "email", "pagerDuty")

    schema = {
      "sns"       => %w[enabled topics],
      "email"     => %w[enabled recipients],
      "pagerDuty" => %w[enabled integrated resolveOnOk connectUrl],
    }

    sliced = schema.each_with_object({}) { |(type, keys), r|
      u = user_notification[type]

      if u
        r.merge!(type => Cistern::Hash.slice(u, *keys))
      end
    }

    service.response(
      :body => { "userNotification" => service.data[:user_notifications].merge!(sliced) },
    )
  end
end
