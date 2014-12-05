require 'spec_helper'

class StringRefinementTester < String

  require 'string_refinement'
  using StringRefinement
  def extract_site_and_slug_proxy
    self.extract_site_and_slug
  end

end

RSpec.describe String do

  context '#extract_site_and_slug' do

    context "for Youtube URLs" do

      let(:youtube_video_id) {
        'D2SoGHFM18I'
      }

      let(:youtube_embed_url) {
        'http://www.youtube.com/embed/' + youtube_video_id
      }

      let(:youtube_view_url) {
        'https://www.youtube.com/watch?v=' + youtube_video_id
      }

      let(:youtube_short_url) {
        'http://youtu.be/' + youtube_video_id
      }

      context "has the correct :site_tag of 'youtube_id'" do

        it "for embedded URLs" do
          expect(StringRefinementTester.new(youtube_embed_url).extract_site_and_slug_proxy[:site_tag]).to eq('youtube_id')
        end

        it "for page URLs" do
          expect(StringRefinementTester.new(youtube_view_url).extract_site_and_slug_proxy[:site_tag]).to eq('youtube_id')
        end

        it "for short URLs" do
          expect(StringRefinementTester.new(youtube_short_url).extract_site_and_slug_proxy[:site_tag]).to eq('youtube_id')
        end

      end

      context "has the correct :site_id of 'D2SoGHFM18I'"     do

        it "for embedded URLs" do
          expect(StringRefinementTester.new(youtube_embed_url).extract_site_and_slug_proxy[:site_id]).to eq(youtube_video_id)
        end

        it "for page URLs" do
          expect(StringRefinementTester.new(youtube_view_url).extract_site_and_slug_proxy[:site_id]).to eq(youtube_video_id)
        end

        it "for short URLs" do
          expect(StringRefinementTester.new(youtube_short_url).extract_site_and_slug_proxy[:site_id]).to eq(youtube_video_id)
        end

      end

    end

    context "for Vimeo URLs" do

      let(:api_request_url_base) {
        'http://vimeo.com/api/v2/video/'
      }

      let(:vimeo_id) {
        '74539208'
      }

      let(:vimeo_browser_url) {
        "http://vimeo.com/74539208"
      }

      before(:each) do
        stub_request(:get, api_request_url_base + vimeo_id + '.json').
          to_return({body: [{"thumbnail_medium" => "http://i.vimeocdn.com/video/448930908_200x150.jpg"}]})
      end

      it "finds the Vimeo site tag" do
        expect(StringRefinementTester.new(vimeo_browser_url).extract_site_and_slug_proxy[:site_tag]).to eq('vimeo_id')
      end

      it "finds the Vimeo site id" do
        expect(StringRefinementTester.new(vimeo_browser_url).extract_site_and_slug_proxy[:site_id]).to eq(vimeo_id)
      end

    end

    context "for any other string" do

      it "returns nil with any other input" do
        expect(StringRefinementTester.new('foxes').extract_site_and_slug_proxy).to be_nil
      end

    end

  end

end
