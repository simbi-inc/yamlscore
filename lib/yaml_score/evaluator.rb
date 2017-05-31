# frozen_string_literal: true

module YamlScore
  class Evaluator
    attr_accessor :hash

    def initialize(hash)
      self.hash = hash
    end

    # rubocop:disable Lint/UselessAssignment, Lint/UnusedMethodArgument
    def evaluate(context)
      hash.factors.each_with_object(hash) do |(_key, val)|
        val.each_with_object(val) do |(_k, v)|
          value = eval(v.value) # rubocop:disable Security/Eval
          v.result = eval(v.formula) # rubocop:disable Security/Eval
        end
      end

      { result: hash }
    rescue => e
      { errors: e }
    end
    # rubocop:enable all
  end
end
