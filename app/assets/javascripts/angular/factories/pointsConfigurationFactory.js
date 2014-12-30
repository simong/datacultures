(function(angular) {

  'use strict';

  /**
   * Points Configuration Factory
   */
  angular.module('datacultures.factories').factory('pointsConfigurationFactory', function($http) {

    /**
     * Get the points configuration for the current course
     */
    var getPointsConfiguration = function() {
      return $http.get('/api/v1/points_configuration');
    };

    /**
     * Update the points configuration for the current course
     *
     * @param  {Object[]}     configuration     The updated points configuration
     */
    var updatePointsConfiguration = function(configuration) {
      return $http.put('/api/v1/points_configuration/update', configuration);
    };

    return {
      getPointsConfiguration: getPointsConfiguration,
      updatePointsConfiguration: updatePointsConfiguration
    };

  });

}(window.angular));
