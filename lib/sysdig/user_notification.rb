class Sysdig::UserNotification < Sysdig::Model

  def self.types
    @_types ||= Hash.new
  end

  def self.type(k=nil)
    if k.nil?
      @key
    else
      key = k.to_s
      Sysdig::UserNotification.types[key] = self
      @key = key
    end
  end

  def self.inherited(klass)
    klass.identity :category

    super
  end

  attribute :enabled, type: :boolean

  def initialize(attributes={})
    self.identity = self.class.type

    super
  end

end
