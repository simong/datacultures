(function(angular, document) {

  'use strict';

  angular.module('datacultures.services').factory('utilService', function() {

    /**
     * Scroll to an element on the page
     * @param {String} elementId The ID of the element we should scroll to
     */
    var scrollToElement = function(elementId) {
      document.getElementById(elementId).scrollIntoView(true);
    };

    return {
      scrollToElement: scrollToElement
    };

  });

}(window.angular, document));
