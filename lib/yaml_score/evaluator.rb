# frozen_string_literal: true

module YamlScore
  class Evaluator
    attr_accessor :hash

    def initialize(hash)
      self.hash = hash
    end

    def evaluate(context) # rubocop:disable Lint/UnusedMethodArgument
      hash.factors.each_with_object(hash) do |(_key, val)|
        val.each_with_object(val) do |(_k, v)|
          value = eval(v.value) # rubocop:disable Security/Eval, Lint/UselessAssignment
          v.result = eval(v.formula) # rubocop:disable Security/Eval
        end
      end

      { result: hash }
    rescue StandardError => e
      { errors: e }
    end
  end
end
