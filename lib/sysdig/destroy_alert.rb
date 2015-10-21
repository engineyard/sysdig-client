class Sysdig::DestroyAlert < Sysdig::Request
  def real(identity)
    service.request(
      :method => :delete,
      :path   => File.join("/api/alerts", identity.to_s)
    )
  end

  def mock(identity)
    service.data[:alerts].fetch(identity)
    service.data[:alerts].delete(identity)

    service.response(
      :status => 204,
    )
  end
end
