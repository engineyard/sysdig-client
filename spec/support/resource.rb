module ResourceHelper
  def create_alert(client: create_client, alert: {})
    tag = SecureRandom.uuid

    client.alerts.create(
      :type              => alert[:type] || "manual",
      :name              => alert[:name] || Faker::Company.name,
      :description       => alert[:description] || Faker::Lorem.sentence,
      :enabled           => alert.fetch(:enabled, true),
      :filter            => alert[:filter] || "agent.tag.id = \"#{tag}\"",
      :severity          => alert[:severity] || rand(0..9),
      :notify            => alert[:notify] || [ ],
      :timespan          => alert[:timespan] || 60,
      :notificationCount => 0,
      :condition         => alert[:condition] || "timeAvg(uptime) = 0",
    )
  end
end

RSpec.configure { |config|
  config.include(ResourceHelper)
}
