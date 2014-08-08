require 'rails_helper'

RSpec.describe Canvas::PagedApiProcessor, :type => :model do

  let(:processor) do
    Canvas::PagedApiProcessor.new({})
  end

  let(:link_header) do
    "<http://localhost:3100/api/v1/courses/2/discussion_topics?page=1&per_page=20>; rel=\"current\",<http://localhost:3100/api/v1/courses/2/discussion_topics?page=2&per_page=20>; rel=\"next\",<http://localhost:3100/api/v1/courses/2/discussion_topics?page=1&per_page=20>; rel=\"first\",<http://localhost:3100/api/v1/courses/2/discussion_topics?page=2&per_page=20>; rel=\"last\""
  end

  context '#links_hash (private)' do

    it 'transforms the links header into a hash for each type of link'  do
      expect(processor.send(:links_hash, link_header)).to be_kind_of Hash
    end

  end

 end

