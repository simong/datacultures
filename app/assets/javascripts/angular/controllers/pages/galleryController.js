(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryController', function(galleryFactory, userInfoFactory, $scope, $routeParams) {

    $scope.itemId = $routeParams.itemId;

    userInfoFactory.me().success(function(data) {
      $scope.currentUser = data;
    }).then(function() {
      return galleryFactory.getSubmissions().success(function(results) {
        $scope.items = results.files;
      });
    });

    // FILTER & MODULES

    $scope.moduleOptions = {
      types: [
        {display: 'All Modules', name: 'All'},
        {display: 'Module 1', name: 1},
        {display: 'Module 2', name: 2},
        {display: 'Module 3', name: 3}
      ]
    };

    $scope.filterOptions = {
      types: [
        {display: 'All Types', name: 'All Types'},
        {display: 'Image', name: 'image'},
        {display: 'Video', name: 'video'},
        {display: 'Other', name: 'other'}
      ]
    };

    $scope.appliedFilters = {
      filters: []
    };

    $scope.filterModules = {
      types: $scope.moduleOptions.types[0]
    };

    $scope.filterGallery = {
      types: $scope.filterOptions.types[0]
    };

    $scope.customFilter = function(items) {
      $scope.appliedFilters.filters.push({
        type: $scope.filterGallery.types.name,
        module: $scope.filterModules.types.name
      });

      if (($scope.filterGallery.types.name === 'All Types') && ($scope.filterModules.types.name === 'All')) {
        return true;
      }
      if ($scope.filterGallery.types.name === 'All Types' && items.module === $scope.filterModules.types.name) {
        return true;
      }
      if ($scope.filterModules.types.name === 'All' && items.type === $scope.filterGallery.types.name) {
        return true;
      }
      if ($scope.filterGallery.types.name !== 'All Types') {
        if (items.type === $scope.filterGallery.types.name && items.module === $scope.filterModules.types.name) {
          return true;
        }
      }
      if ($scope.filterModules.types.name !== 'All') {
        if (items.type === $scope.filterGallery.types.name && items.module === $scope.filterModules.types.name) {
          return true;
        }
      }
    };

    // SORTING

    $scope.sortOptions = [
      {display: 'Unsorted', type: 'naturalOrder'},
      {display: 'Comments', type: 'numComments'},
      {display: 'Date', type: 'date'},
      {display: 'Likes', type: 'numLikes'},
      {display: 'Views', type: 'numViews'}
    ];

    $scope.sortGallery = 'naturalOrder';

    $scope.switch = function(type) {
      $scope.sortGallery = type.type;
    };

    var findItem = function(id) {
      for (var i = 0; i < $scope.items.length; i++) {
        if ($scope.items[i].id === id) {
          return $scope.items[i];
        }
      }
    };

    var like = function(item, liked) {
      galleryFactory.like({
        id: item.id,
        liked: liked
      }).success(function() {
        if (item.liked === true && liked === null) {
          item.likes--;
        } else if (item.liked === false && liked === null) {
          item.dislikes--;
        } else if (item.liked === false && liked === true) {
          item.dislikes--;
          item.likes++;
        } else if (item.liked === true && liked === false) {
          item.dislikes++;
          item.likes--;
        } else {
          if (liked === true) {
            item.likes++;
          } else {
            item.dislikes++;
          }
        }
        item.liked = liked;
      });
    };

    $scope.like = function(id) {
      var item = findItem(id);
      like(item, item.liked ? null : true);
    };

    $scope.dislike = function(id) {
      var item = findItem(id);
      like(item, item.liked === false ? null : false);
    };

  });

})(window.angular);
