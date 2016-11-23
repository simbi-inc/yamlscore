require 'active_support/core_ext/enumerable'

module YamlScore
  # evaluator of main formula in yml
  class Calculator
    attr_accessor :evaluated

    def initialize(evaluated_hash)
      self.evaluated = evaluated_hash
    end

    def result(context = nil)
      factors = Hashie::Mash.new

      evaluated.factors.each do |_k, v|
        v.each do |_key, val|
          if factors[val[:tag]]
            factors[val[:tag]] << val[:result]
          else
            factors[val[:tag]] = [val[:result]]
          end
        end
      end

      eval(evaluated.formula)
    rescue => e
      puts e.message
    end
  end
end
