require 'spec_helper'

class PercentileTester < Array

  require 'percentile'
  using Percentile
  def rank_proxy(score:, fill_zeroes_to_size:)
    self.rank(score: score, fill_zeroes_to_size: fill_zeroes_to_size)
  end

end

RSpec.describe Array do

  let(:scores) do
    [103, 16, 137, 29, 74, 197, 39, 88, 148, 72, 122, 38, 118, 115, 113, 16, 71, 69, 138,
     30, 74, 126, 169, 46, 14]
  end

  let(:array_size) do
    scores.size
  end

  context '#rank' do

    it "gives the correct rank for the top unique scorer of 96% for a size of 25"  do
      expect(PercentileTester.new(scores).rank_proxy(score: scores.max, fill_zeroes_to_size: array_size)).to eq(96.0)
    end

    it "gives the same results regardless of order" do
      expect(PercentileTester.new(scores).rank_proxy(score: scores.max, fill_zeroes_to_size: array_size)).to \
        eq(PercentileTester.new(scores.sort).rank_proxy(score: scores.max, fill_zeroes_to_size: array_size))
    end

    it "when tied 2 ways, next-to-lowest is 6.0% - if unique would be 8%" do
      percentile_tester = PercentileTester.new(scores)
      next_to_lowest_score = percentile_tester[1]
      expect(PercentileTester.new(scores).rank_proxy(score: next_to_lowest_score, fill_zeroes_to_size: array_size)).to eq(6.0)
    end

    it "with 50% students not participating, the lowest score of any kind is 53% when 25 participate" do
      percentile_tester = PercentileTester.new(scores)
      next_to_lowest_score = percentile_tester[1]
      expect(PercentileTester.new(scores).rank_proxy(score: next_to_lowest_score, fill_zeroes_to_size: array_size * 2)).to eq(53.0)
    end


  end

end
