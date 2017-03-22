module Dialogue
  class ConversationOptionsValidator
    VALID_OPTIONS = [:access_token, :author_id].freeze

    def validate(options)
      errors = []
      options.keys.each do |key|
        errors << "#{key} is not a valid option" unless VALID_OPTIONS.include?(key)
      end

      ValidationResult.new errors
    end

    private

    class ValidationResult
      attr_reader :errors

      def initialize(errors)
        @errors = errors.freeze
      end

      def error_messages
        @errors.join(", ")
      end

      def success?
        @errors.empty?
      end
    end
  end
end
