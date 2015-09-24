class Sysdig::Client::Alert < Sysdig::Client::Model

  identity :id, type: :integer

  attribute :condition
  attribute :created_at,         alias: "createdOn",  parser: method(:epoch_time)
  attribute :description
  attribute :enabled,            type:  :boolean
  attribute :group_aggregations, type:  :array,       alias:  "groupAggregations"
  attribute :group_by,           type:  :array,       alias:  "groupBy"
  attribute :group_condition,    alias: "groupCondition"
  attribute :modified_at,        alias: "modifiedOn", parser: method(:epoch_time)
  attribute :name
  attribute :notification_count, type:  :integer,     alias:  "notificationCount"
  attribute :notify
  attribute :severity,           type:  :integer
  attribute :targets,            type:  :array
  attribute :timespan,           type:  :integer
  attribute :version,            type:  :integer

end
