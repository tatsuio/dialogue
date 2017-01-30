module Converse
  class ConversationTemplate
    attr_reader :name, :template

    def initialize(name=nil, &block)
      @name = name
      @template = block
    end

    def self.build(name=nil, &block)
      # TODO: Check for a unique name within the factory
      ConversationTemplate.new name, &block
    end

    def start(message, options={})
      Conversation.new(self, options).start message
    end
  end
end
