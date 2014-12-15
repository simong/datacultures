(function(angular) {

  'use strict';

  angular.module('datacultures.services').service('galleryService', function() {

    var hasLoaded = false;
    var options = {
      sortOptions: [
        {
          display: 'Date',
          type: 'date'
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
        }
      ]
    };

    var resetOptions = function() {
      options.search = {
        author: ''
      };
      options.assignmentFilter = '';
      options.typeFilter = '';
    };

    var setDefaultSort = function() {
      // Default should be the first one (date)
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
      setDefaultSort: setDefaultSort,
      resetOptions: resetOptions
    };

  });

}(window.angular));
