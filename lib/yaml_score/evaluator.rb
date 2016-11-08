module YamlScore
  class Evaluator
    attr_accessor :hash

    def initialize(hash)
      self.hash = hash
    end

    def evaluate(context)
      # TODO: evaluate the hash
      hash
    end
  end
end
