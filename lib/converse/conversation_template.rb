module Converse
  class ConversationTemplate
    attr_reader :name, :template

    def initialize(name=nil, &block)
      @name = name
      @template = block
    end

    def self.build(name, &block)
      template = ConversationTemplate.new name, &block
      Converse.register_template template
      template
    end

    def start(message, options={})
      ConversationTemplateRunner.new(message, options).run self
    end
  end
end
