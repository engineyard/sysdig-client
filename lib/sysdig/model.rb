class Sysdig::Model
  def self.epoch_time(v, _)
    Time.at(v / 1000)
  end

  def self.microsecond_datetime(v, _)
    i = v.to_i

    i > 1_000_000 ? i / 1_000_000 : i
  end

  def self.upcase(v, _)
    v.nil? ? v : v.to_s.upcase
  end
end
