activity_types = ['DiscussionTopic', 'DiscussionEntry', 'DiscussionEdit', 'Submission']

pcid = 1
activity_types.each do |at|
  points_configuration = PointsConfiguration.find_or_initialize_by({interaction: at})
  points_configuration.points_associated = (rand(10) - rand(3)) if points_configuration.points_associated.nil?
  points_configuration.pcid = pcid.to_s if points_configuration.pcid.nil?
  points_configuration.save unless points_configuration.persisted?
  pcid += 1
end
