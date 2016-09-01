function AppController($scope, ApiService) {
  $scope.search = function() {
    ApiService.getAnagrams($scope.anagramSearch)
  }
}

angular
  .module('app')
  .controller('AppController', AppController);
