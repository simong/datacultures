class MediaUrl < ActiveRecord::Base
  acts_as_paranoid

  require 'string_refinement'
  using StringRefinement

  def self.process_submission_url(url:, canvas_user_id:, assignment_id:, author:)

    site_and_slug = url.extract_site_and_slug
    user_submission_traits = {canvas_user_id: canvas_user_id,
                              canvas_assignment_id: assignment_id }
    if site_and_slug
      previous_entry = where(user_submission_traits).first
      if !previous_entry
        self.create(site_and_slug.merge(user_submission_traits).merge({author: author}))
      else
        old_values = {site_tag: previous_entry.site_tag.to_sym, site_id: previous_entry.site_id }
        if (old_values != site_and_slug)
          previous_entry.update_attributes(site_and_slug)
        end
      end
    end

  end

  def self.hash_for_api
    all.map{|media_url| {media_url.site_tag.to_sym => media_url.site_id, canvas_user_id: media_url.canvas_user_id,
             assignment_id: media_url.canvas_assignment_id, author: media_url.author } }
  end

end