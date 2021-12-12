module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
    #base.instances = 0
  end

  module ClassMethods
    def instances
      @instances ||= 0
    end
    attr_writer :instances
  end

  module InstanceMethods
    
    protected
    def register_instance
      self.class.instances+=1
    end
  end



end