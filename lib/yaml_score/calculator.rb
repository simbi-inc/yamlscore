# frozen_string_literal: true

require 'active_support/core_ext/enumerable'

module YamlScore
  # evaluator of main formula in yml
  class Calculator
    def initialize(evaluated_hash)
      @evaluated = evaluated_hash
    end

    def result(context = nil) # rubocop:disable Lint/UnusedMethodArgument
      { value: eval(evaluated.formula) } # rubocop:disable Security/Eval
    rescue StandardError => e
      { errors: e }
    end

    private

    def evaluated
      @evaluated.factors.each_value do |v|
        v.each_value do |val|
          next factors[val[:tag]] << val[:result] if factors[val[:tag]]
          factors[val[:tag]] = [val[:result]]
        end
      end

      @evaluated
    end

    def factors
      @factors ||= Hashie::Mash.new
    end
  end
end
