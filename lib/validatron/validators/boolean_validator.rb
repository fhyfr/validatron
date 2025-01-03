module Validatron
  module Validators
    class BooleanValidator < BaseValidator
      # Available validations for BooleanValidator:
      # - type: :boolean => must be a boolean
      # - truthy: true => must be true
      # - falsy: true => must be false
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
