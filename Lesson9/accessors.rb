module Acсessors

  module ClassMethods
    
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        arr_name = "@#{name}_his".to_sym
        define_method(name) { instance_variable_get(var_name) }
        
        define_method("#{name}=".to_sym) do |value| 
          if instance_variable_get(arr_name).nil? 
            instance_variable_set(arr_name, [])
          end
          instance_variable_set(var_name, value)
          instance_variable_get("#{arr_name}") << value
        end
        var_name_his = "@#{name}_his".to_sym
        def_name = "#{name}_history".to_sym
        define_method(def_name) { instance_variable_get(var_name_his) } 
      end
    end

    def strong_attr_accessor(name)
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value| 
        var = instance_variable_get(var_name)
        if value.class == var.class
          instance_variable_set(var_name, value)
        else
          puts "Тип присваемого значения не совпадает с типом переменной"
          raise RuntimeError 
        end
      end 
    end

  end
  
  module InstanceMethods
    
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end

