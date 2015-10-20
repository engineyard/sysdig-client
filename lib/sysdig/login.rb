class Sysdig::Login < Sysdig::Request
  def real(username, password)
    service.send(:_request, {
      :method => :post,
      :path   => "/api/login",
      :body   => { "username"  => username, "password" => password },
    })
  end
end
