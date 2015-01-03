(function(angular) {

  'use strict';

  /**
   * Engagement Index Factory
   */
  angular.module('datacultures.factories').factory('engagementIndexFactory', function($http) {

    /**
     * Get the list of students and their engagement index points in the
     * engagement index
     *
     * @return {Promise<EngagementIndexData[]>}               $http promise returning the engagement index data for all students
     */
    var getEngagementIndexList = function() {
      return $http.get('/api/v1/engagement_index/data');
    };

    /**
     * Save whether a student's engagement index points should be shared with
     * the entire course
     *
     * @param  {String}                             id        The canvas user id of the students for which to set the share status
     * @param  {Boolean}                            share     Whether the student's engagement index points should be shared with the entire course
     * @return {Promise}                                      $http promise
     */
    var setEngagementIndexStatus = function(id, share) {
      var url = '/api/v1/students/' + id;
      var data = {
        status: share
      };
      return $http.post(url, data);
    };

    return {
      getEngagementIndexList: getEngagementIndexList,
      setEngagementIndexStatus: setEngagementIndexStatus
    };

  });

}(window.angular));
