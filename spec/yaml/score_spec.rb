require 'spec_helper'
require 'yaml'
require 'hashie'

module YamlScore
  describe 'YamlScore' do
    it 'has a version number' do
      expect(YamlScore::VERSION).not_to be nil
    end

    let(:ctx) { Context.sample }

    describe 'context should have members accessible as methods' do
      it 'should be accessible via context' do
        expect(ctx.user.profile.influence).to eq(100)
      end
    end

    describe 'evaluation should work correctly' do
      let(:formulas) { Hashie::Mash.new(::YAML.load(File.read('spec/fixtures/user_score.yml'))['v1']) }
      let(:evaluated) { YamlScore::Evaluator.new(formulas).evaluate(ctx) }

      it 'should have the result' do
        expect(evaluated.factors.additive.profile_influence.result).to eq(1)
        expect(evaluated.factors.additive.recommendations.result).to eq(2)
        expect(evaluated.factors.additive.reviews.result).to eq(2)

        temp_val = [1 - (Time.now.to_i - 10) * 0.005, 1 - (Time.now.to_i - 10) * 0.30].max
        expect(evaluated.factors.temporal.last_seen.result).to eq(temp_val)
      end

      context 'with broken yml' do
        let(:formulas) { Hashie::Mash.new(::YAML.load(File.read('spec/fixtures/user_score.yml'))['broken']) }

        it 'should handle errors' do
          evaluated = YamlScore::Evaluator.new(formulas).evaluate(ctx)
          p evaluated
        end
      end

      describe 'calculating the final result' do
        let(:result) { YamlScore::Calculator.new(evaluated).result }

        it 'should correctly calculate' do
          expect(result).to eq(5)
        end
      end
    end
  end
end
