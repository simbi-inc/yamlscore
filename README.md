# YamlScore

Calculate a score based on YAML rules and formulas.

## Overview

We want to be able to read the formulas from YAML file, then pass a context into the evaluation, and have the gem automatically calcualate the score for a given context.

We will define the scoring algorithm by a combination of:

 * Overall agreement over the context score formulae (SSF)
 * A YAML file defining each scoring sub-formula, and grouping various scoring components into eg. `quality`, `feedback`, `engagement` and `recency`, as well as possibly other classes in the future.
 * Using pure ruby code in YAML values (which can be `eval`-ed in the context of the context) in order to compute the source `value` of the score (ie. # of compliments the user has could be defined as `user.compliments.count`, and then referenced as a `value` in the formula
 * Using pure ruby code in YAML values (which can be `eval`-ed in the context of the context) define the actual formula to apply to the `value` to compute the score for this particular factor.
 * Agreement on which are the variables available in the formula definitions
 * Supporting multiple versions of the scoring algorithm (which can be used to A/B test each algorithm) by using built-in to [YAML inheritance](http://www.yaml.org/spec/1.2/spec.html).

### Top level namespace

We'll use to identify versions in the top level namespace:

```yaml
default: &default
# the default values that will be overridden by specific versions
v1: <<: *default
# formulae overrides for version 1
v2: # formulae overrides for version 2
v3-aggressive-recency: # example of v3 overrides with a specific name
```

### Static versus Temporal Calculations

There are two types of formulae that may exist:

* Some factors are calculated as _static_ scores for any given context, and expressed as `x_1 .... x_n`. These are the scores that do not linearly (or gradually) change over time, and only changes discreetly.

* All of the `recency` factors can be viewed as _temporal_ coefficients `t_1, ... t_m`, and are linearly affected by the recency, or _age_ of various models or events. Recency is proportional to the score (ie, the more recent, the higher the score), and are applied separately: most likely at the __read time__ when the score of the context is needed in order to sort contexts within the grid. The temporal factors should be recomputed each time a score is needed from a context, in order to support linearly decaying functions based on recency.

* They are applied as multipliers (coefficients) ranging from 0 to 1 only (ie, expressed in percentages). For example, to reduce the overall score by 30% the coefficient must be `0.7` (or `1 - 0.3)`.

### Overall Score Formulae

The overall formula for calculating a score of a given context is as follows:

```ruby
SCORE(context) = SUM(x_1, x_2, ..., x_n) * t_1(age) * t_2(age) * ... * t_n(age)
```

##### Defining Factors and Formulas in YAML

Here is an example of the YAML file containing most of the numbers. The values of each component are meant to be strings that can be evaluated in Ruby code, and then put together as components in the above formula. Note the `formula` definition at the top level: to compute the final score for a context, each of `quality`, `feedback` or `engagement` and `recency` would represent an array of values. These values can be summed or any other operation performed on them to compute the final score.

```yaml
default: &default
  formula: "(quality.sum + feedback.sum + engagement.sum) * recency.product"
  factors:
    additive:
      profile_strength:
        value: "context.user.profile.influence"
        formula: "[ value * 0.01, 10].min"
        tag: quality
      recommendations:
        value: "context.user.recommendations.count"
        formula: "[value, 3].min"
        tag: retention
    temporal:
      last_seen:
        value: "Time.now - user.last_login_at.ago"
        formula: "[1 - value * 0.005, 1 - value * 0.30 ].max"
        tag: recency
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yaml-score'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yaml-score


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Simbi-inc/yaml-score.

