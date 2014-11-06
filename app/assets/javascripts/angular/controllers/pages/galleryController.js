(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryController', function(galleryFactory, userInfoFactory, $scope, $routeParams) {

    $scope.itemId = $routeParams.itemId;

    $scope.refreshSubmissions = function() {
      return galleryFactory.getSubmissions().success(function(results) {
        $scope.items = results.files;
      });
    };

    userInfoFactory.me().success(function(data) {
      $scope.currentUser = data;
    }).then($scope.refreshSubmissions);

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

    // Sorting
    $scope.sortOptions = [
      {
        display: 'Date',
        type: 'date'
      },
      {
        display: 'Comments',
        type: 'comments.length'
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

    // Default should be the first one (date)
    $scope.sortOption = $scope.sortOptions[0];

  });

})(window.angular);
