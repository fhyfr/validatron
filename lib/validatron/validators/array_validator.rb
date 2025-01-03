module Validatron
  module Validators
    class ArrayValidator < BaseValidator
      def validate
        return unless value

        custom_message = options[:message]

        unless value.is_a?(Array)
          add_error(custom_message || "must be an array")
          return
        end

        if options[:length] && value.length != options[:length]
          add_error(custom_message || "must have exactly #{options[:length]} items")
        end

        if options[:min] && value.length < options[:min]
          add_error(custom_message || "must have at least #{options[:min]} items")
        end

        if options[:max] && value.length > options[:max]
          add_error(custom_message || "must have at most #{options[:max]} items")
        end

        if options[:items]
          item_schema = Validatron::Schema.new
          item_schema.required(:item, options[:items])
          value.each_with_index do |item, index|
            item_params = { item: item }
            begin
              Validator.validate(item_params, item_schema)
            rescue ValidationError => e
              e.errors.each do |error_key, error_message|
                errors[:"items[#{index}].#{error_key}"] = error_message
              end
            end
          end
        end

        return unless options[:unique] && value.uniq.length != value.length

        add_error(custom_message || "must have unique items")
      end
    end
  end
end
