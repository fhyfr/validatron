require "date"

module Validatron
  module Validators
    class DateValidator < BaseValidator
      # Available validations for DateValidator:
      # - iso: true => must be in ISO 8601 format
      # - min: "2020-01-01" => must be on or after 2020-01-01
      # - max: "2020-12-31" => must be on or before 2020-12-31
      # - timestamp: true => must be a valid timestamp (Time object)
      def validate
        return unless value

        custom_message = options[:message]

        unless value.is_a?(Date) || value.is_a?(Time) || value.is_a?(String)
          add_error(custom_message || "must be a valid date")
          return
        end

        begin
          parsed_date = parse_date(value)
        rescue ArgumentError
          add_error(custom_message || "must be a valid date")
          return
        end

        add_error(custom_message || "must be in ISO 8601 format") if options[:iso] && !iso_format?(value)

        if options[:min] && parsed_date < parse_date(options[:min])
          add_error(custom_message || "must be on or after #{options[:min]}")
        end

        if options[:max] && parsed_date > parse_date(options[:max])
          add_error(custom_message || "must be on or before #{options[:max]}")
        end

        # handle for timestamp
        return unless options[:timestamp]

        add_error(custom_message || "must be a valid timestamp") unless value.is_a?(Time)
      end

      private

      def parse_date(value)
        case value
        when Date
          value
        when Time
          value.to_date
        when String
          Date.parse(value)
        else
          raise ArgumentError, "Invalid date format"
        end
      end

      def iso_format?(value)
        value.is_a?(String) && value.match?(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:\d{2})\z/)
      end
    end
  end
end
