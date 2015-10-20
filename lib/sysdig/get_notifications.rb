class Sysdig::GetNotifications < Sysdig::Request
  def real(from, to)
    from_i = from.to_i * 1_000_000
    to_i   = to.to_i   * 1_000_000

    service.request(
      :path   => "/api/notifications",
      :params => {"from" => from_i, "to" => to_i},
    )
  end
end
