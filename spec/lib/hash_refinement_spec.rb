require 'spec_helper'


class HashRefinementTester < Hash

  require 'hash_refinement'
  using HashRefinement

  def correct_liked_values_proxy
    self.correct_liked_values!
  end

  def transmogrify_video_tags_proxy
    self.transmogrify_video_tags!
  end

  def numerize_count_values_proxy
    self.numerize_count_values!
  end

  def image_transform_proxy
    self.image_transform!
  end

  def video_transform_proxy
    self.video_transform!
  end

 end

RSpec.describe Hash do

  context '#correct_liked_values!' do

    it "returns liked correctly for proper input" do
      expect(HashRefinementTester[{'liked' => 't', 'disliked' => nil}].correct_liked_values_proxy).
             to eq({'liked'=> true})
    end

    it "returns the proper return ({'liked' => nil}) for improper input" do
      expect(HashRefinementTester[{'foo' => 'bar'}].correct_liked_values_proxy.
             select{|k,v| k == 'liked'}).to eq({'liked'=> nil})
    end

  end

  context '#transmogrify_video_tags!' do

    it "changes youtube tags to the correct form" do
      expect(HashRefinementTester[{'site_tag' => 'youtube_id',
             'site_id' => '90210'}].transmogrify_video_tags_proxy).to eq({'youtube_id' => '90210'})
    end

    it "does not modify if 'site_tag' and 'site_id do not exist'" do
      expect(HashRefinementTester[{'foo'=> 'bar'}].transmogrify_video_tags_proxy).to eq({'foo' => 'bar'})
    end

  end

  context '#numerize_count_values!' do

    it 'is fine if a count key is missing' do
      expect(HashRefinementTester[{'comment_count' => '3', 'likes' => '10' }].numerize_count_values_proxy).
             to eq({'comment_count' => 3, 'likes' => 10, 'dislikes' => 0, 'views' => 0})
    end

    it 'works on perfect inputs' do
      expect(HashRefinementTester[{'comment_count' => '3', 'likes' => '10', 'dislikes' => '5', 'views' => '44' }].numerize_count_values_proxy).
          to eq({'comment_count' => 3, 'likes' => 10, 'dislikes' => 5, 'views' => 44})
    end

  end

  context '#image_transform!' do

    it "transforms the fields needed for an image" do
      hash_refinement_tester = HashRefinementTester[{'likes' => '5', 'dislikes' => '7', 'comment_count' => '9',
           'liked' =>'t', 'disliked' => nil, 'views' => '11'}]
      expect(hash_refinement_tester.image_transform_proxy).
          to eq({'likes' => 5, 'dislikes' => 7, 'comment_count' => 9, 'liked' => true, 'views' => 11})
    end

  end

  context "#video_transform" do

    it "transforms video JSON correclty" do
      hash_refinement_tester = HashRefinementTester[{'likes' => '5', 'dislikes' => '7', 'views' => '5',
         'comment_count' => '9', 'liked' =>'t', 'disliked' => nil, 'site_tag' => 'youtube_id', 'site_id' => '546811'}]
      expect(hash_refinement_tester.video_transform_proxy).
          to eq({'likes' => 5, 'dislikes' => 7, 'views' => 5, 'comment_count' => 9, 'liked' => true, 'youtube_id' => '546811'})
    end

  end

end
