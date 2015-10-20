class Sysdig::Alert < Sysdig::Model

  def self.dump_filter(hash)
    hash.map { |k,v| [k, normalize_filter_condition(v).inspect].join(" = ") }.join(", ")
  end

  def self.load_filter(string)
    string.split(", ").map { |t| t.split(" = ") }.inject({}) { |r,(k,c)| r.merge(k => normalize_filter_condition(c)) }
  end

  def self.normalize_filter_condition(string)
    string.gsub(/(^\\?\")|(\\?\"$)/, "")
  end

  identity :id, type: :integer

  #{\"id\":30395,\"version\":29,\"createdOn\":1441725934000,\"modifiedOn\":1443472841000,\"type\":\"MANUAL\",\"name\":\"Individual - Router uptime check\",\"description\":\"At least 1 router container is down.\",\"enabled\":true,\"filter\":\"container.name = \\\"deis-router\\\"\",\"severity\":2,\"notify\":[\"SNS\"],\"timespan\":60000000,\"targets\":[{\"subTarget\":[{\"metric\":\"container.name\",\"value\":\"deis-router\"}]}],\"notificationCount\":41,\"segmentBy\":[\"agent.tag.id\"],\"segmentCondition\":{\"type\":\"ANY\"},\"condition\":\"timeAvg(uptime) = 0\",\"groupAggregations\":[{\"metric\":\"uptime\",\"aggregation\":\"avg\"}]}
  attribute :condition
  attribute :created_at,         alias: "createdOn",  parser: method(:epoch_time)
  attribute :description
  attribute :enabled,            type:  :boolean,     default: true
  attribute :filter,             parser: lambda { |v, _| load_filter(v) }
  attribute :group_aggregations, type:  :array,       alias:  "groupAggregations"
  attribute :group_by,           type:  :array,       alias:  "groupBy"
  attribute :group_condition,    alias: "groupCondition"
  attribute :modified_at,        alias: "modifiedOn", parser: method(:epoch_time)
  attribute :name
  attribute :notification_count, type:  :integer,     alias:  "notificationCount"
  attribute :notify,             parser: lambda { |v, _| Array(v).map { |x| x.upcase } }
  attribute :severity,           type:  :integer
  attribute :segment_by,         alias: "segmentBy"
  attribute :segment_condition,  alias: "segmentCondition"
  attribute :targets,            type:  :array
  attribute :timespan,           type:  :integer
  attribute :type,               parser: lambda { |v, _| v.to_s.upcase }
  attribute :version,            type:  :integer

  def save
    if new_record?
      response = service.create_alert(
        "version"     => self.version,
        "name"        => self.name,
        "description" => self.description,
        "enabled"     => self.enabled,
        "filter"      => dump_filter(filter || {}),
        "type"        => self.type,
        "condition"   => self.condition,
        "timespan"    => self.timespan,
        "severity"    => self.severity,
        "notify"      => self.notify,
      )

      merge_attributes(response.body.fetch("alert"))
    else
      raise NotImplementedError
    end
  end

end
