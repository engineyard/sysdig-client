class Sysdig::Alert < Sysdig::Model

  identity :id, type: :integer

  attribute :condition
  attribute :created_at,         alias: "createdOn",  parser: method(:epoch_time)
  attribute :description
  attribute :enabled,            type:  :boolean,     default: true
  attribute :filter,             parser: lambda { |v, _| Sysdig::AlertFilter.load(v) }
  attribute :group_aggregations, type:  :array,       alias: "groupAggregations"
  attribute :group_by,           type:  :array,       alias: "groupBy"
  attribute :group_condition,    alias: "groupCondition"
  attribute :modified_at,        alias: "modifiedOn", parser: method(:epoch_time)
  attribute :name
  attribute :notification_count, type:  :integer,     alias: "notificationCount"
  attribute :notify,             parser: lambda { |v, _| (Array(v) || []).map { |x| x.to_s.upcase } }
  attribute :segment_by,         alias: "segmentBy"
  attribute :segment_condition,  alias: "segmentCondition"
  attribute :severity,           type:  :integer
  attribute :targets,            type:  :array
  attribute :timespan,           parser: lambda { |v, _| i = v.to_i; i > 1_000_000 ? i / 1_000_000 : i }
  attribute :type,               parser: lambda { |v, _| v.to_s.upcase }
  attribute :version,            type:  :integer

  def destroy
    requires :identity

    service.destroy_alert(identity)
  end

  def save
    params = {
      "condition"         => self.condition,
      "description"       => self.description,
      "enabled"           => self.enabled,
      "filter"            => Sysdig::AlertFilter.dump(filter || {}),
      "groupAggregations" => self.group_aggregations,
      "groupBy"           => self.group_by,
      "groupCondition"    => self.group_condition,
      "name"              => self.name,
      "notify"            => self.notify,
      "segmentBy"         => self.segment_by,
      "segmentCondition"  => self.segment_condition,
      "severity"          => self.severity,
      "timespan"          => self.timespan * 1_000_000,
      "type"              => self.type,
    }

    data = (
      (new_record? && service.create_alert(params)) ||
      service.update_alert(self.identity, params.merge("version" => self.version))
    ).body.fetch("alert")

    merge_attributes(data)
  end

end
