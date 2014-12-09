require 'spec_helper'

class ArrayRefinementTester < Array

  require 'array_refinement'
  using ArrayRefinement
  def name_sortable_proxy
    self.name_sortable
  end

  def personal_data_proxy
    self.personal_data
  end

  def extract_rendering_attachments_proxy
    self.extract_rendering_attachments!
  end

end

RSpec.describe Array do

  context '#name_sortable' do

    it 'is OK with Fixnums' do
      expect(ArrayRefinementTester.new([3,9]).name_sortable_proxy).to eq('9, 3')
    end

    it 'works with more than 2 arguments' do
      expect(ArrayRefinementTester.new(['5','7','12']).name_sortable_proxy).to eq('12, 5')
    end

    it 'is OK with a single argument' do
      expect(ArrayRefinementTester.new(['5']).name_sortable_proxy).to eq('5')
    end

    it 'returns an empty string with an empty array' do
      expect(ArrayRefinementTester.new([]).name_sortable_proxy).to eq('')
    end

  end

  context '#personal_data' do

    it 'returns the expect Hash' do
      personal_data = ArrayRefinementTester.new([{'lis_person_name_full' => 'Jonathan Doe',
        'lis_person_contact_email_primary' => 'doe@deer.life'}, 'Doe, Jonathan']).personal_data_proxy
      expect(personal_data).to eq({name: 'Jonathan Doe', primary_email: 'doe@deer.life', sortable_name: 'Doe, Jonathan'})
    end

    it 'raise NoMethodError with empty params' do
      expect{ArrayRefinementTester.new([]).personal_data_proxy}.to raise_error(NoMethodError)
    end

    it 'does not raises an exception with at least one element in the array' do
      expect{ArrayRefinementTester.new(['a']).personal_data_proxy}.not_to raise_error
    end

    it 'results in a Hash with correct keys even without a Hash as the first element' do
      expect(ArrayRefinementTester.new(['a']).personal_data_proxy.keys).to eq([:name, :sortable_name, :primary_email])
    end
  end

  context '#extract_rendering_attachments!' do

    it 'returns a Hash if there is rendered attachment data' do
      emm = ArrayRefinementTester.new([{ "content-type"=>"image/png", "filename"=>"websnappr20141118-13944-yzpnmg.png" },
                                     {foo: 'bar'}, { "content-type"=>"image/svg", "filename"=>"websnappr20141118-13944-yzpnmg.png" }])
      expect(emm.extract_rendering_attachments_proxy).to be_kind_of Hash
    end

    it 'returns the rendered attachment data' do
      emm = ArrayRefinementTester.new([{ "content-type"=>"image/png", "filename"=>"websnappr20141118-13944-yzpnmg.png" },
                                       {foo: 'bar'}, { "content-type"=>"image/svg", "filename"=>"websnappr20141118-13944-yzpnmg.png" }])
      expect(emm.extract_rendering_attachments_proxy).to eq({ "content-type"=>"image/png", "filename"=>"websnappr20141118-13944-yzpnmg.png"})
    end

    it 'removes the rendered attachment data from the receiver Array' do
      emm = ArrayRefinementTester.new([{ "content-type"=>"image/png", "filename"=>"websnappr20141118-13944-yzpnmg.png" },
                                       {foo: 'bar'}, { "content-type"=>"image/svg", "filename"=>"websnappr20141118-13944-yzpnmg.png" }])
      emm.extract_rendering_attachments_proxy
      expect(emm).to_not include({ "content-type"=>"image/png", "filename"=>"websnappr20141118-13944-yzpnmg.png"})
    end

  end


end
