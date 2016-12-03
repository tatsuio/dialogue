module Converse
  class ConversationTemplate
    attr_reader :intent

    def initialize(intent)
      @intent = intent
    end
  end
end
