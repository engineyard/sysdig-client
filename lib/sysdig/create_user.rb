class Sysdig::CreateUser < Sysdig::Request
  def self.params
    %w[username]
  end

  def real(email)
    service.request(
      :method => :post,
      :path   => "/api/users", # https://app.sysdigcloud.com/api/users
      :body   => { "username" => email },
    )
  end

  #{
    #"version" => 0,
    #"username" => "jlane+dev2@engineyard.com",
    #"enabled" => false,
    #"status" => "registered", # confirmed
    #"termsAndConditions" => false,
    #"pictureUrl" => "http://www.gravatar.com/avatar/5abf7bc4cb5c22d5d98e51a717ff4d4d",
    #"properties" => {},
    #"customerSettings" => {
      #"version" => 1,
      #"sysdig" => {
        #"enabled" => false,
        #"buckets" => []
      #},
      #"plan" => {
        #"maxAgents" => 10,
        #"groupingEnabled" => false,
        #"warnIfThresholdReached" => true,
        #"subscriptions" => [
          #[0] {
            #"id" => 9942239,
            #"state" => "active",
            #"balance_in_cents" => 0,
            #"total_revenue_in_cents" => 37079,
            #"product_price_in_cents" => 0,
            #"product_version_number" => 2,
            #"current_period_ends_at" => 1445468379000,
            #"next_assessment_at" => 1445468379000,
            #"activated_at" => 1440197981000,
            #"created_at" => 1440197979000,
            #"updated_at" => 1444091709000,
            #"cancel_at_end_of_period" => false,
            #"current_period_started_at" => 1442876379000,
            #"previous_state" => "active",
            #"signup_payment_id" => 104989687,
            #"signup_revenue" => "0.00",
            #"payment_collection_method" => "invoice",
            #"customer" => {
              #"first_name" => "Engine Yard",
              #"last_name" => "Internal",
              #"email" => "sysdig+internal@engineyard.com",
              #"organization" => "sysdig+internal@engineyard.com",
              #"reference" => "2892",
              #"id" => 9525077,
              #"created_at" => 1438965926000,
              #"updated_at" => 1442515339000,
              #"address" => "",
              #"address_2" => "",
              #"city" => "",
              #"state" => "",
              #"zip" => "",
              #"country" => "",
              #"phone" => "1-866-518-9273",
              #"verified" => false
            #},
            #"product" => {
              #"id" => 3678636,
              #"name" => "Sysdig Cloud - Monthly Subscription",
              #"handle" => "monthly",
              #"description" => "",
              #"accounting_code" => "",
              #"price_in_cents" => 0,
              #"interval" => 1,
              #"interval_unit" => "month",
              #"expiration_interval_unit" => "never",
              #"trial_interval_unit" => "day",
              #"return_params" => "",
              #"request_credit_card" => true,
              #"require_credit_card" => false,
              #"created_at" => 1428489497000,
              #"updated_at" => 1436301416000,
              #"update_return_url" => "",
              #"product_family" => {
                #"id" => 488513,
                #"name" => "Basic",
                #"handle" => "basic",
                #"description" => ""
              #},
              #"public_signup_pages" => [],
              #"taxable" => false,
              #"version_number" => 2,
              #"update_return_params" => ""
            #},
            #"agent_licenses" => 10,
            #"components" => [
              #[0] {
                #"component_id" => 102746,
                #"subscription_id" => 9942239,
                #"allocated_quantity" => 10,
                #"pricing_scheme" => "per_unit",
                #"name" => "Monthly Agent License ($25)",
                #"kind" => "quantity_based_component",
                #"unit_name" => "agent",
                #"unit_balance" => 0,
                #"unit_price" => 25.0,
                #"archived" => false
              #}
            #],
            #"ondemand_agents" => 0,
            #"On-demand agent cap" => "0",
            #"next_product_id" => nil,
            #"current_billing_amount_in_cents" => "15000"
          #}
        #]
      #}
    #},
    #"roles" => [
      #[0] "ROLE_USER"
    #],
    #"customer" => {
      #"id" => 2892,
      #"version" => 0,
      #"name" => "Engine Yard",
      #"accessKey" => "4a869ba9-dd0a-4262-8617-0abfb7d02f36",
      #"dateCreated" => 1438965688000,
      #"lastUpdated" => 1438965688000
    #},
    #"timezone" => "+00:00",
    #"encodedToken" => "amxhbmUrZGV2MkBlbmdpbmV5YXJkLmNvbXw4MDg5OGVhNC0xMWUzLTQ5N2MtOGIxMS1mYjRjNzE0MWUyNmYtMTQ0NTUzMDgwNzE2M3x8",
    #"dateCreated" => 1445530807000,
    #"lastUpdated" => 1445530807000,
    #"agentInstallParams" => {
      #"accessKey" => "4a869ba9-dd0a-4262-8617-0abfb7d02f36"
    #},
    #"accessKey" => "4a869ba9-dd0a-4262-8617-0abfb7d02f36"
  #}

  def mock(alert)
    alert_id = service.serial_id
    body     = Cistern::Hash.slice(Cistern::Hash.stringify_keys(alert), *self.class.params)

    service.data[:alerts][alert_id] = body.merge!("id" => alert_id)

    service.response(
      :status => 201,
      :body   => {"alert" => body},
    )
  end
end
