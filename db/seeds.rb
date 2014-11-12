ACTIVITY_POINTS_PER_TYPE =     # CYB-146
    {'DiscussionTopic' => 10,
     'DiscussionEntry' => 5,
     'DiscussionEdit'  => 2,
     'Submission' => 15,
     'GalleryComment' => 5,
     'GetAComment' => 5,
     'Like' => 1,
     'Dislike' => -1,
     'GetALike' => 1,
     'GetADislike' => -1
    }

pcid = 1
ACTIVITY_POINTS_PER_TYPE.each_pair do |at, av|
  points_configuration = PointsConfiguration.find_or_initialize_by({interaction: at})
  points_configuration.points_associated = av if points_configuration.points_associated.nil?
  points_configuration.pcid = pcid.to_s if points_configuration.pcid.nil?
  points_configuration.save unless points_configuration.persisted?
  pcid += 1
end
