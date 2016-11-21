module YamlScore
  class Evaluator
    attr_accessor :hash

    def initialize(hash)
      self.hash = hash
    end

    def evaluate(context)
      hash.factors.each_with_object(hash) do |(_key, val)|
        val.each_with_object(val) do |(_k, v)|
          value = eval(v.value)
          v.result = eval(v.formula)
        end
      end
    rescue => e
      puts e
    end
  end
end
