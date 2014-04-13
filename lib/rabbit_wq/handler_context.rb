module RabbitWQ
  module HandlerContext
    include Logging
    def initialize_handler_context(config)
      RabbitWQ.handler_context = class_from_string(config['handler_class']).new(config['config'])
    end

    protected

      def class_from_string(constant_name)
        constant_name.split('::').inject(Object) do |mod, class_name|
          mod.const_get(class_name)
        end
      end
  end
end
