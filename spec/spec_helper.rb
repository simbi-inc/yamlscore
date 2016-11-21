require 'simplecov'
SimpleCov.start

require 'yaml_score'
require 'hashie'

RSpec.configure do |config|
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true
end

# fake context
class Context < Hashie::Mash
  attr_accessor :context

  def initialize(hash)
    super(hash)
    self.context = self
  end

  class << self
    def sample
      sample_hash = {
        user: {
          profile: { influence: 100 },
          recommendations: [0, 1],
          reviews: [0, 1],
          last_login_at: { ago: 10 }
        }
      }
      new(sample_hash)
    end
  end
end
