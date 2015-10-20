class Sysdig::Model
  def self.epoch_time(v, _)
    Time.at(v / 1000)
  end
end
