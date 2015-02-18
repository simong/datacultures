(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('PointsConfigurationController', function(analyticsService, pointsConfigurationFactory, userService, utilService, $scope) {

    // Variable that keeps track of whether the points configuration is shown
    // in view or edit mode
    $scope.editMode = false;

    // Variable that keeps track of the configuration before it is modified. This
    // will be used to revert to when the cancel button is clicked
    var cachedConfiguration = null;

    /**
     * Retrieve the current points configuration and render it
     */
    var getPointsConfiguration = function() {
      pointsConfigurationFactory.getPointsConfiguration().then(function(configuration) {
        $scope.configuration = configuration;
      });
    };

    /**
     * Check whether the points configuration contains any removed activities. Removed
     * activities are activities that will not generate activity points
     *
     * @return {Boolean}                    Whether the points configuration contains any removed activities
     */
    $scope.hasRemovedActivities = function() {
      if ($scope.configuration) {
        for (var i = 0; i < $scope.configuration.length; i++) {
          if ($scope.configuration[i].active === false) {
            return true;
          }
        }
      }

      return false;
    };

    /**
     * Remove an activity from the points configuration. These activities will not
     * generate activity points
     *
     * @param  {Activity}     activity      The activity to remove from the points configuration
     */
    $scope.removeActivity = function(activity) {
      activity.active = false;
    };

    /**
     * Add an activity back to the points configuration. These activities will generate
     * activity points
     *
     * @param  {Activity}     activity      The activity to add to the points configuration
     */
    $scope.enableActivity = function(activity) {
      activity.active = true;
    };

    /**
     * Change the points configuration to edit mode
     */
    $scope.editPointsConfiguration = function() {
      // Cache the current points configuration. When changes are made and the
      // cancel button is clicked, we'll revert back to this cached configuration
      cachedConfiguration = angular.copy($scope.configuration);
      // Switch to edit mode
      $scope.editMode = true;

      // Track that the points configuration is being edited
      analyticsService.track('Edit Points Configuration');
    };

    /**
     * Cancel points configuration editing and revert back to the previous
     * points configuration
     */
    $scope.cancelPointsConfiguration = function() {
      // Revert back to the cached points configuration
      $scope.configuration = cachedConfiguration;
      // Switch to view mode
      $scope.editMode = false;

      // Track that the points configuration has been cancelled
      analyticsService.track('Cancel Points Configuration');
    };

    /**
     * Save the modified points configuration
     */
    $scope.savePointsConfiguration = function() {
      // Filter out the removed activities
      // TODO: Improve the API endpoint so removed activities can be sent along
      // with `active: false`
      var toSave = [];
      for (var i = 0; i < $scope.configuration.length; i++) {
        if ($scope.configuration[i].active) {
          toSave.push($scope.configuration[i]);
        }
      }
      // Switch to view mode
      $scope.editMode = false;
      // Track that the points configuration has been saved
      analyticsService.track('Save Points Configuration');
      pointsConfigurationFactory.updatePointsConfiguration(toSave).success(getPointsConfiguration);
    };

    /**
     * Get the detailed information about the current user and load
     * the points configuration for the current course
     */
    userService.getMe().then(function(me) {
      $scope.me = me;
      // Track that the points configuration tool has been loaded
      analyticsService.track('Load Points Configuration Tool');
      getPointsConfiguration();
    });

  });

})(window.angular);
