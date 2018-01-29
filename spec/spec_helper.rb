# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml_score'
require 'hashie'
require 'pry'

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
    def sample(score: nil)
      if score == :max
        new(max_score_sample)
      else
        new(sample_hash)
      end
    end

    # rubocop:disable Metrics/MethodLength
    def sample_hash
      {
        user: {
          profile_strength: 100, # expect 10
          recommendations_count: 2, # expect 2
          compliments_count: 1, # expect 1
          likes_received_count: 20, # expect 5
          recruits_count: 12, # expected 5
          inquiries_sent_count: 2, # expect 2
          deals_count: 10, # expect 3
          response_rate: 90, # expect 4
          services_count: 10, # expect 4
          has_app: 1,
          manifesto_shared: 0,
          service_shared: 1,
          facebook_liked: 1,
          has_swipes_in_matching: 0,
          posted_request: 1, # expected 3
          completed_order: 0,
          last_seen: Date.today - 6, # expect -3%
          last_message_sent: Date.today - 12, # expect - 0.5%
          last_listing_created: Date.today - 2 # expect -0%
        },
        listing: {
          strength: 100, # expect 10
          quality_rating: 4.7 # expect 2
        }
      }
    end

    def max_score_sample
      {
        user: {
          profile_strength: 100, # expect 10
          recommendations_count: 3, # expect 3
          compliments_count: 5, # expect 5
          likes_received_count: 50, # expect 10
          recruits_count: 12, # expected 5
          inquiries_sent_count: 3, # expect 3
          deals_count: 10, # expect 3
          response_rate: 100, # expect 6
          services_count: 10, # expect 4
          has_app: 1,
          manifesto_shared: 1,
          service_shared: 1,
          facebook_liked: 1,
          has_swipes_in_matching: 1,
          posted_request: 1, # expected 3
          completed_order: 1,
          last_seen: Date.today - 0, # expect -0%
          last_message_sent: Date.today - 2, # expect - 0%
          last_listing_created: Date.today - 2 # expect -0%
        },
        listing: {
          strength: 100, # expect 10
          quality_rating: 5 # expect 5
        }
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
end
