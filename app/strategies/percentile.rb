module Percentile

  refine Array do

     def rank(score:, fill_zeroes_to_size:)
       (((count(score)-1)*0.5 + count_lower_than(score: score) + (fill_zeroes_to_size - size)) / fill_zeroes_to_size) * 100.0
     end

     private

     def count_lower_than(score:)
       number_lower = 0
       each do |e|
         number_lower += 1 if (e < score)
       end
       number_lower
     end

  end

end
