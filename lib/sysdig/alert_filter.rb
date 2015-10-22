class Sysdig::AlertFilter
  def self.dump(hash)
    hash.map { |k,v| [k, normalize_condition(v).inspect].join(" = ") }.join(", ")
  end

  def self.load(hash_or_string)
    case hash_or_string
    when NilClass, Hash
      hash_or_string
    when String
      hash_or_string.split(", ").map { |t| t.split(" = ") }.inject({}) { |r,(k,c)|
        r.merge(k => normalize_condition(c))
      }
    else nil
    end
  end

  def self.normalize_condition(string)
    string.gsub(/(^\\?\")|(\\?\"$)/, "")
  end
end
