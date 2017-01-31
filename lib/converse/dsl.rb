module Converse
  class DSL
    def on(intent, &block)
      #Converse.register_conversation(ConversationTemplate.new(intent))
    end

    def self.run(block)
      new.instance_eval(&block)
    end
  end
end
