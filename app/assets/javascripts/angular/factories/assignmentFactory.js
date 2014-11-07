
(function(angular) {

  'use strict';

  /**
   * Assignment Factory
   * @param {Object} httpService The http service
   */
  angular.module('datacultures.factories').factory('assignmentsFactory', function(httpService) {

    var url = '/api/v1/assignments';

    var getAssignments = function(options) {
      return httpService.request(options, url);
    };

    return {
      getAssignments: getAssignments
    };

  });

}(window.angular));
