module Converse
  module ConversationOptions
    attr_reader :options

    def method_missing(method, *args)
      return options.fetch method if options.key? method
      super
    end

    private

    def guard_options!(options)
      result = ConversationOptionsValidator.new.validate options
      raise InvalidOptionsError.new(result.error_messages) unless result.success?
    end
  end
end
