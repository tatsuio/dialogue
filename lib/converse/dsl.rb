module Converse
  class DSL
    def on(intent, &block)
      conversation = Conversation.new(intent)

      Converse.register_conversation(conversation)
    end

    def self.run(block)
      new.instance_eval(&block)
    end
  end
end
