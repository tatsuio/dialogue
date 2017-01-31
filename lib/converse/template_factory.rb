require "singleton"

module Converse
  class TemplateFactory
    include Singleton

    attr_reader :templates

    def initialize
      @templates = []
    end

    def find(name)
      templates.find { |template| template.name.to_s == name.to_s }
    end

    def register(template)
      raise TemplateAlreadyRegisteredError.new(template) if registered?(template)
      templates << template
    end

    def registered?(template)
      !find(template.name).nil?
    end
  end
end
