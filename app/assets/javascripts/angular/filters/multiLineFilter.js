(function(angular) {

  'use strict';

  angular.module('datacultures.filters').filter('multiLineFilter', function() {

    return function(input) {
      if (!input) {
        return input;
      }
      var output = input
        // replace possible line breaks.
        .replace(/(\r\n|\r|\n)/g, '<br/>')
        // replace tabs
        .replace(/\t/g, '&nbsp;&nbsp;&nbsp;')
        // replace spaces.
        .replace(/ /g, '&nbsp;');

      return output;
    };

  });

}(window.angular));
