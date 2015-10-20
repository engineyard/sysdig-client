class Sysdig::Login < Sysdig::Request
  def real(username, password)
    service.request_without_authentication(
      :method => :post,
      :path   => "/api/login",
      :body   => { "username"  => username, "password" => password },
    )
  end
end
