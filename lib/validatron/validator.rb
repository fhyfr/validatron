module Validatron
  class Validator
    REQUIRED_OPTIONS = [:type].freeze

    def self.validate(params, schema)
      errors = {}

      schema.rules.each do |key, options|
        value = params[key.to_s] || params[key.to_sym]
        custom_message = options[:message]

        missing_options = REQUIRED_OPTIONS.select { |option| options[option].nil? }
        unless missing_options.empty?
          errors[key] = custom_message || "must have a #{missing_options.join(", ")} defined"
        end

        # Validate required fields
        if options[:required] && value.nil?
          errors[key] = custom_message || "is required"
        # Validate type of field
        elsif options[:type] && !value.nil? && !value.is_a?(Object.const_get(options[:type].capitalize))
          errors[key] = custom_message || "must be a #{options[:type]}"
        # Check for format validation
        elsif options[:format] && value !~ options[:format]
          errors[key] = custom_message || "is invalid"
        # Validate greater than fields
        elsif options[:gt] && value.to_i <= options[:gt]
          errors[key] = custom_message || "must be greater than #{options[:gt]}"
        end
      end

      raise ValidationError.new(errors) unless errors.empty?
    end
  end
end
