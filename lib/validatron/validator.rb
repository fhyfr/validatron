module Validatron
  class Validator
    REQUIRED_OPTIONS = [:type].freeze

    def self.validate(params, schema)
      errors = {}

      schema.rules.each do |key, options|
        value = params[key.to_s] || params[key.to_sym]
        message = options[:message]

        missing_options = REQUIRED_OPTIONS.select { |option| options[option].nil? }
        if missing_options.any?
          errors[key] = message || "must have a #{missing_options.join(", ")} defined"
          next
        end

        validate_field(key, value, options, errors)
      end

      raise ValidationError.new(errors) unless errors.empty?
    end

    def self.validate_field(key, value, options, errors)
      message = options[:message]

      if options[:required] && value.nil?
        errors[key] = message || "is required"
      elsif options[:type] && !value.nil? && !value.is_a?(Object.const_get(options[:type].capitalize))
        errors[key] = message || "must be a #{options[:type]}"
      elsif options[:format] && value !~ options[:format]
        errors[key] = message || "is invalid"
      elsif options[:gt] && value.to_i <= options[:gt]
        errors[key] = message || "must be greater than #{options[:gt]}"
      elsif options[:lt] && value.to_i >= options[:lt]
        errors[key] = message || "must be less than #{options[:lt]}"
      elsif options[:gte] && value.to_i < options[:gte]
        errors[key] = message || "must be greater than or equal to #{options[:gte]}"
      elsif options[:lte] && value.to_i > options[:lte]
        errors[key] = message || "must be less than or equal to #{options[:lte]}"
      elsif options[:eq] && value.to_i != options[:eq]
        errors[key] = message || "must be equal to #{options[:eq]}"
      end
    end
  end
end
