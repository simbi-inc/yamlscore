require 'spec_helper'
require 'yaml'
require 'hashie'

module YamlScore
  describe 'YamlScore' do
    let(:ctx) { Context.sample }
    let(:formulas) { Hashie::Mash.new(::YAML.load(File.read('spec/fixtures/user_score.yml'))['v1']) }
    let(:evaluated) { YamlScore::Evaluator.new(formulas).evaluate(ctx) }

    it 'has a version number' do
      expect(YamlScore::VERSION).not_to be nil
    end

    describe 'context should have members accessible as methods' do
      it 'should be accessible via context' do
        expect(ctx.user.profile_strength).to eq(100)
      end
    end

    describe 'evaluation should work correctly' do
      it 'should have the result' do
        expect(evaluated.factors.additive.profile_strength.result).to eq(10)
        expect(evaluated.factors.additive.recommendations.result).to eq(2)
        expect(evaluated.factors.additive.listing_rating.result).to eq(2)
        expect(evaluated.factors.additive.response_rate.result).to eq(4)
        expect(evaluated.factors.temporal.last_seen.result).to eq(0.03)
      end

      context 'with broken yml' do
        let(:formulas) { Hashie::Mash.new(::YAML.load(File.read('spec/fixtures/user_score.yml'))['broken']) }

        it 'should handle errors' do
          evaluated = YamlScore::Evaluator.new(formulas).evaluate(ctx)
          expect(evaluated).to eq nil
        end
      end
    end

    describe 'calculation should work correctly' do
      let(:evaluated) { YamlScore::Evaluator.new(formulas).evaluate(ctx) }
      let(:ctx) { Context.sample }

      context 'with broken yml' do
        let(:formulas) { Hashie::Mash.new(::YAML.load(File.read('spec/fixtures/user_score.yml'))['broken']) }

        it 'should handle errors' do
          result = YamlScore::Calculator.new(evaluated).result
          expect(result).to eq nil
        end
      end

      describe 'with correct yml' do
        subject { YamlScore::Calculator.new(evaluated).result.round(2) }

        context 'with score' do
          it { is_expected.to eq(54 * 0.965) }
        end

        context 'with max score' do
          let(:ctx) { Context.sample(score: :max) }
          it { is_expected.to eq(75) }
        end

        context 'with max % reduction' do
          before do
            ctx.user.last_seen = Date.today - 60
            ctx.user.last_message_sent = Date.today - 60 * 7
            ctx.user.last_listing_created = Date.today - 100 * 7
          end

          it { is_expected.to eq(54 * 0.3) }
        end
      end
    end
  end
end
