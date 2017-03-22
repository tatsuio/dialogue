module Dialogue
  class DSL
    def on(intent, &block)
      #Dialogue.register_conversation(ConversationTemplate.new(intent))
    end

    def self.run(block)
      new.instance_eval(&block)
    end
  end
end
