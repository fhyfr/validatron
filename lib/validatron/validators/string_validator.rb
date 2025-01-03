module Validatron
  module Validators
    class StringValidator < BaseValidator
      def validate
        return unless value

        custom_message = options[:message]

        unless value.is_a?(String)
          add_error(custom_message || "must be a string")
          return
        end

        if options[:min] && value.length < options[:min]
          add_error(custom_message || "must be at least #{options[:min]} characters long")
        end

        if options[:max] && value.length > options[:max]
          add_error(custom_message || "must be at most #{options[:max]} characters long")
        end

        if options[:length] && value.length != options[:length]
          add_error(custom_message || "must be exactly #{options[:length]} characters long")
        end

        return unless options[:pattern] && value !~ options[:pattern]

        add_error(custom_message || "is invalid")
      end
    end
  end
end
