class Sysdig::UserNotifications < Sysdig::Collection

  model Sysdig::UserNotification

  def all(options={})
    load(service.get_user_notifications.body.fetch("userNotification")).tap { |_| self.records.compact! }
  end

  def get(type)
    all.find { |r| r.identity == type.to_s }
  end

  def new(args)
    type, attributes = *args

    unless attributes.is_a?(::Hash)
      raise(ArgumentError.new("Initialization parameters must be an attributes hash, got #{attributes.class} #{attributes.inspect}"))
    end

    concrete_model = model.types[type]

    if concrete_model
      concrete_model.new(
        {
          :collection => self,
          :service    => service,
        }.merge(attributes)
      )
    end
  end
end
