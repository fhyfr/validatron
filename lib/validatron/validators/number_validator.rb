module Validatron
  module Validators
    class NumberValidator < BaseValidator
      def validate
        return unless value

        custom_message = options[:message]

        unless value.is_a?(Numeric)
          add_error(custom_message || "must be a number")
          return
        end

        add_error(custom_message || "must be at least #{options[:min]}") if options[:min] && value < options[:min]

        add_error(custom_message || "must be at most #{options[:max]}") if options[:max] && value > options[:max]

        add_error(custom_message || "must be an integer") if options[:integer] && !value.is_a?(Integer)

        add_error(custom_message || "must be a float") if options[:float] && !value.is_a?(Float)

        add_error(custom_message || "must be positive") if options[:positive] && value <= 0

        add_error(custom_message || "must be negative") if options[:negative] && value >= 0

        return unless options[:precision] && value.to_s.split(".").last.length != options[:precision]

        add_error(custom_message || "must have #{options[:precision]} decimal places")
      end
    end
  end
end
