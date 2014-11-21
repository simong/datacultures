class ProcessMediaUrlWorker
  include Sidekiq::Worker

  require 'string_refinement'
  using StringRefinement

  def perform(url, canvas_user_id, assignment_id, author)
    site_and_slug = url.extract_site_and_slug
    user_submission_traits = {canvas_user_id: canvas_user_id,
                              canvas_assignment_id: assignment_id }
    if site_and_slug
      previous_entry =  MediaUrl.where(user_submission_traits).first
      thumbnail_url  =  Video::Metadata.thumbnail_url(site_and_slug[:site_tag], site_and_slug[:site_id])
      if !previous_entry
        MediaUrl.create(site_and_slug.merge(user_submission_traits).merge({author: author, thumbnail_url: thumbnail_url}))
      else
        old_values = {site_tag: previous_entry.site_tag.to_sym, site_id: previous_entry.site_id }
        if (old_values != site_and_slug)
          previous_entry.update_attributes(site_and_slug.merge({thumbnail_url: thumbnail_url}))
        end
      end
    end
  end
end
