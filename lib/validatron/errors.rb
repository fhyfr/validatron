module Validatron
  class ValidationError < StandardError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
      super(errors.map { |field, message| "#{field} #{message}" }.join(", "))
    end
  end
end
