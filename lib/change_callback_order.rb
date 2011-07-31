# coding: UTF-8

module ChangeCallbackOrder
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

    base.class_eval do
    end
  end

  module ClassMethods
    def change_callback_order(option, &block)
      if (option != :as_predefined)
        raise "option error"
      end

      old_callbacks = ActiveRecord::Callbacks::CALLBACKS.collect do |name|
        callback = change_callback_order_get_callback_variable(name)
        next callback ? callback.clone : nil
      end

      block.call

      new_callbacks = ActiveRecord::Callbacks::CALLBACKS.collect do |name|
        callback = change_callback_order_get_callback_variable(name)
        next callback ? callback.clone : nil
      end

      ActiveRecord::Callbacks::CALLBACKS.zip(old_callbacks, new_callbacks) do |name, old, new|
        if (old && new)
          if (option == :as_predefined)
            if (new != old)
              if (new.first(old.size) == old)
                change_callback_order_set_callback_variable(name, (new - old) + old)
              else
                change_callback_order_set_callback_variable(name, old + (new - old))
              end
            end
          end
        end
      end
    end

    def change_callback_order_get_callback_variable(name)
      return instance_variable_get("@#{name}_callbacks")
    end

    def change_callback_order_set_callback_variable(name, value)
      return instance_variable_set("@#{name}_callbacks", value)
    end
  end

  module InstanceMethods
  end
end

ActiveRecord::Base.send(:include, ChangeCallbackOrder)

