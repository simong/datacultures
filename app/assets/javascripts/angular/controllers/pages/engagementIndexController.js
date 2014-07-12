(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexController', function($scope, studentFactory) {

    studentFactory.getStudents().
      success(function(results) {
        $scope.people = results.students;

        // Default Sort
        $scope.predicate = 'position';
    });
  });

}(window.angular));
