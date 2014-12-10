(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryController', function(assignmentFactory, galleryFactory, userInfoFactory, viewFactory, $scope) {

    $scope.resetOptions = function() {
      $scope.selectedItem = {
        itemId: ''
      };
      $scope.search = {
        author: ''
      };
      $scope.assignmentFilter = '';
      $scope.typeFilter = '';
      // Default should be the first one (date)
      $scope.sort = {
        option: $scope.sortOptions[0]
      };
    };

    $scope.searchAuthor = function(authorName) {
      $scope.resetOptions();
      $scope.search.author = authorName;
    };

    $scope.refreshSubmissions = function() {
      return galleryFactory.getSubmissions().success(function(results) {
        $scope.items = results.files;
      });
    };

    var incrementViews = function(item) {
      viewFactory.increment({
        gallery_id: item.id
      }).success(function() {
        item.views++;
      });
    };

    $scope.selectItem = function(item) {
      $scope.selectedItem.itemId = item.id;
      incrementViews(item);
    };

    userInfoFactory.me().success(function(data) {
      $scope.currentUser = data;
    }).then($scope.refreshSubmissions);

    assignmentFactory.getAssignments().success(function(data) {
      $scope.assignments = data;
    });

    // Type Filter
    $scope.typeOptions = [
      {
        display: 'Image',
        value: 'image'
      },
      {
        display: 'Video',
        value: 'video'
      }
    ];

    // Sorting
    $scope.sortOptions = [
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
    ];

    $scope.resetOptions();

  });

})(window.angular);
