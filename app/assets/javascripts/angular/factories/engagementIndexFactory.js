(function(angular) {

  'use strict';

  /**
   * Roster Factory - get data from the roster API
   * @param {Object} $http The $http service from Angular
   */
  angular.module('datacultures.factories').factory('studentFactory', function($http) {

    var getStudents = function() {
      var url = '/api/v1/engagement_index/data';
      return $http.get(url);
    };

    var postStudentStatus = function(canvasUserID, share) {
      var url = '/api/v1/students/' + canvasUserID;
      var data = {'status': share};
      return $http.post(url, data);
    };

    return {
      postStudentStatus: postStudentStatus,
      getStudents: getStudents
    };

  });

}(window.angular));
