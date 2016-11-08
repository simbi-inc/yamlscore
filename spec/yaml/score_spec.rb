require 'spec_helper'
require 'yaml'
require 'hashie'

module YamlScore
  describe 'YamlScore' do
    it 'has a version number' do
      expect(YamlScore::VERSION).not_to be nil
    end

    class Context < Hashie::Mash
      attr_accessor :context

      def initialize(hash)
        super(hash)
        self.context = self
      end
    end

    let(:ctx) { Context.new({ user: { profile: { influence: 5 } } }) }
    
    describe 'context should have members accessible as methods' do
      it 'should be accessible via context' do
        expect(ctx.user.profile.influence).to eq(5)
      end
    end

    describe 'evaluation should work correctly' do
      let(:formulas) { Hashie::Mash.new(::YAML.load(File.read('spec/fixtures/user_score.yml'))['v1']) }
      let(:evaluated) { YamlScore::Evaluator.new(formulas).evaluate(ctx) }
      
      it 'should have the result' do
        expect(evaluated.factors.additive.profile_influence.result).to eq(1)
      end
      
      describe 'calculating the final result' do
        let(:result) { YamlScore::Calculator.new(evaluated).result }
    
        it 'should correctly calculate' do
          expect(result).to eq(1)
        end
      end
    end
    
      

  end
end
