class Sysdig::Model
  def self.epoch_time(v, options={})
    divisor = options[:divisor] || 1_000

    case v
    when Time then v
    when Numeric then Time.at(v / divisor)
    else nil
    end
  end

  def self.microsecond_datetime(v, *)
    i = v.to_i

    i > 1_000_000 ? i / 1_000_000 : i
  end

  def self.upcase(v, *)
    v.nil? ? v : v.to_s.upcase
  end
end
