class Sysdig::AlertNotification < Sysdig::Model

  identity :id, type: :integer

  attribute :timespan,           type: :integer
  attribute :severity,           type: :integer
  attribute :target
  attribute :alert_id,           type: :integer, alias: "alert"
  attribute :type
  attribute :criteria
  attribute :resolved,           type: :boolean
  attribute :condition
  attribute :state
  attribute :group_aggregations, type: :array,   alias: "groupAggregations"
  attribute :entities,           type: :array

end
