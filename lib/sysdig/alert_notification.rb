class Sysdig::AlertNotification < Sysdig::Model

  # @arg v String like "container.name = 'deis-builder' and agent.tag.id = '8dbf0cfb-7b4b-42ea-b1f1-b742a5bdebf4'"
  def self.load_filter(s, _)
    case s
    when String
      s.split(" and ").
        map        { |c| c.split(" = ") }.
        inject({}) { |r,(k,v)| r.merge(k => Sysdig::AlertFilter.normalize_condition(v)) }
    else s
    end
  end

  def self.dump_filter(h)
    case h
    when Hash
      h.each_with_object([]) { |(k,v),r|
        r << "#{k} = #{Sysdig::AlertFilter.normalize_condition(v).inspect}"
      }.join(" and ")
    else h
    end
  end

  identity :id, type: :integer

  attribute :alert_id,  type: :integer, alias: "alert"
  attribute :condition
  attribute :entities,  type: :array # @todo map to object
  attribute :filter,    parser: method(:load_filter)
  attribute :resolved,  type: :boolean
  attribute :severity,  type: :integer
  attribute :state,     parser: method(:upcase)
  attribute :timespan,  parser: method(:microsecond_datetime)
  attribute :timestamp, parser: method(:epoch_time)

  # @todo get target information out of an alert notification
  def save
    params = {
      "alert"     => self.alert_id,
      "filter"    => self.class.dump_filter(self.filter),
      "resolved"  => self.resolved,
      "severity"  => self.severity,
      "state"     => self.state,
      "timestamp" => self.timestamp.to_i * 1_000_000,
    }

    data = service.update_alert_notification(self.identity, params).body.fetch("notification")

    merge_attributes(data)
  end

  def resolve!
    self.state = "RESOLVED"
    self.save
  end
end
