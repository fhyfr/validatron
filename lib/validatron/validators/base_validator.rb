module Validatron
  module Validators
    class BaseValidator
      attr_reader :key, :value, :options, :errors

      def initialize(key, value, options, errors)
        @key = key
        @value = value
        @options = options
        @errors = errors
      end

      def validate
        raise NotImplementedError, "Subclasses must implement the validate method"
      end

      protected

      def add_error(message, nested_key = nil)
        error_key = nested_key ? "#{key}.#{nested_key}".to_sym : key
        errors[error_key] = message
      end
    end
  end
end
