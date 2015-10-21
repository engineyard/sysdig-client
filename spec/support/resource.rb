module ResourceHelper
  def create_alert(alert={}, client: create_client)
    tag = SecureRandom.uuid

    client.alerts.create(
      type: "MANUAL",
      name: Faker::Company.name,
      description: Faker::Lorem.sentence,
      enabled: true,
      filter: "agent.tag.id = \"#{tag}\"",
      severity: rand(0..9),
      notify: [ ],
      timespan: 60000000,
      targets: [
        {
          subTarget: [
            {
              metric: "agent.tag.id",
              value: tag
            }
          ]
        }
      ],
      notificationCount: 0,
      condition: "timeAvg(uptime) = 0",
      groupAggregations: [
        {
          metric: "uptime",
          aggregation: "avg"
        }
      ]
    )
  end
end

RSpec.configure { |config|
  config.include(ResourceHelper)
}
