module Dialogue
  class ConversationTemplate
    attr_reader :name, :template

    def initialize(name=nil, &block)
      @name = name
      @template = block
    end

    def self.build(name, &block)
      ConversationTemplate.new name, &block
    end

    def register
      Dialogue.register_template self
      self
    end

    def start(message, options={})
      ConversationTemplateRunner.new(message, options).run self
    end
  end
end
