(function(angular) {

  'use strict';

  angular.module('datacultures.services').service('galleryService', function() {

    var hasLoaded = false;
    var options = {
      sortOptions: [
        {
          display: 'Date',
          type: 'submitted_at'
        },
        {
          display: 'Views',
          type: 'views'
        },
        {
          display: 'Comments',
          type: 'comment_count'
        },
        {
          display: 'Likes',
          type: 'likes'
        },
        {
          display: 'Dislikes',
          type: 'dislikes'
        }
      ],
      typeOptions: [
        {
          display: 'Image',
          value: 'image'
        },
        {
          display: 'Video',
          value: 'video'
        },
        {
          display: 'Website URL',
          value: 'url'
        }
      ]
    };

    /**
     * Reset all the filter, sort & search options for the gallery
     */
    var resetOptions = function() {
      options.search = {
        author: ''
      };
      options.assignmentFilter = '';
      options.typeFilter = '';
      setDefaultSort();
    };

    /**
     * Default sort should be the first one (date)
     */
    var setDefaultSort = function() {
      options.sort = {
        option: options.sortOptions[0]
      };
    };

    if (!hasLoaded) {
      setDefaultSort();
      hasLoaded = true;
    }

    // Expose methods
    return {
      options: options,
      resetOptions: resetOptions
    };

  });

}(window.angular));
