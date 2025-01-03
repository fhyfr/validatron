module Validatron
  class Validator
    REQUIRED_OPTIONS = [:type].freeze

    def self.validate(params, schema)
      errors = {}

      schema.rules.each do |key, options|
        value = params[key.to_s] || params[key.to_sym]

        missing_options = REQUIRED_OPTIONS.select { |option| options[option].nil? }
        errors[key] = "must have a #{missing_options.join(", ")} defined" unless missing_options.empty?

        # Validate required fields
        if options[:required] && value.nil?
          errors[key] = "is required"
        # Validate type of field
        elsif options[:type] && !value.nil? && !value.is_a?(Object.const_get(options[:type].capitalize))
          errors[key] = "must be a #{options[:type]}"
        # Check for format validation
        elsif options[:format] && value !~ options[:format]
          errors[key] = "is invalid"
        # Validate greater than fields
        elsif options[:gt] && value.to_i <= options[:gt]
          errors[key] = "must be greater than #{options[:gt]}"
        end
      end

      raise ValidationError.new(errors) unless errors.empty?
    end
  end
end
