module ArrayRefinement

  refine Array do

    def name_sortable
      family = self.last
      given = (size > 1) ? self.first : nil
      mid = (!(family.nil? || family.to_s.empty?) && !(given.nil? || given.to_s.empty?)) ? ', ' : ''
      family.to_s + mid + given.to_s
    end

    def personal_data
      {name: first['lis_person_name_full'], sortable_name: last,
       primary_email: first['lis_person_contact_email_primary']
      }
    end

    #  removes & returns the rendered attachment's data
    def extract_rendering_attachments!
      rendered_url_index = find_index{|a| (a.kind_of?(Hash) && a['content-type'] == 'image/png' && a['filename'] =~ /websnappr/)}
      delete_at(rendered_url_index)
    end

  end

end

# section of returned JSON for a generated image
# { "content-type"=>"image/png", "filename"=>"websnappr20141118-13944-yzpnmg.png" }

