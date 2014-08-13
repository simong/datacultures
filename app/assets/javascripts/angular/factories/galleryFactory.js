(function(angular) {

  'use strict';

  /**
   * Gallery Factory - Managing submissions, likes, and comments
   */
  angular.module('datacultures.factories').factory('galleryFactory', function($http) {

    var getSubmissions = function() {
      var url = '/api/v1/gallery/index';
      return $http.get(url);
    };

    var createComment = function(data) {
      var url = '/api/v1/comments/new';
      return $http.post(url, data);
    };

    return {
      getSubmissions: getSubmissions,
      createComment: createComment
    };

  });

}(window.angular));
