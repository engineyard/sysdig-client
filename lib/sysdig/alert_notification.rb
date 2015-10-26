class Sysdig::AlertNotification < Sysdig::Model

  # @arg v String like "container.name = 'deis-builder' and agent.tag.id = '8dbf0cfb-7b4b-42ea-b1f1-b742a5bdebf4'"
  def self.parse_filter(s, _)
    s.split(" and ").
      map        { |c| c.split(" = ") }.
      inject({}) { |r,(k,v)| r.merge(k => Sysdig::AlertFilter.normalize_condition(v)) }
  end

  identity :id, type: :integer

  attribute :alert_id,           type: :integer, alias: "alert"
  attribute :condition
  attribute :entities,           type: :array # @todo map to object
  attribute :filter,             parser: method(:parse_filter)
  attribute :resolved,           type: :boolean
  attribute :severity,           type: :integer
  attribute :state,              parser: method(:upcase)
  attribute :timespan,           parser: method(:microsecond_datetime)
  attribute :timestamp,          parser: method(:epoch_time)

  # @todo get target information out of an alert notification
  def save
    {"notification"=>
     {"timestamp"=>1445878320000000,
      "severity"=>2,
      "filter"=>
     "container.name = 'deis-builder' and agent.tag.id = '8dbf0cfb-7b4b-42ea-b1f1-b742a5bdebf4'",
       "timespan"=>60000000,
       "condition"=>"timeAvg(uptime) = 0",
       "entities"=>
     [{"filter"=>
       "container.name = 'deis-builder' and agent.tag.id = '8dbf0cfb-7b4b-42ea-b1f1-b742a5bdebf4'",
         "target"=>
       {"id"=>"group@agent_tag_id-8dbf0cfb-7b4b-42ea-b1f1-b742a5bdebf4",
        "type"=>"GROUP",
        "subTarget"=>[{"metric"=>"container.name", "value"=>"deis-builder"}]},
       "metricValues"=>
       [{"metric"=>"uptime", "aggregation"=>"timeAvg", "value"=>0}]}],
     "state"=>"ACTIVE",
     "resolved"=>true,
     "alert"=>"31586"}}
  end

end
