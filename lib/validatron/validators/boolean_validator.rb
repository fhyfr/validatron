module Validatron
  module Validators
    class BooleanValidator < BaseValidator
      def validate
        custom_message = options[:message]

        unless value.is_a?(TrueClass) || value.is_a?(FalseClass)
          add_error(custom_message || "must be a boolean")
          return
        end

        add_error(custom_message || "must be true") if options[:truthy] && value != true

        return unless options[:falsy] && value != false

        add_error(custom_message || "must be false")
      end
    end
  end
end
