function AppController($scope) {
  $scope.hello = "hello world"
  $scope.search = function() {
    console.log("hey!")
    // ApiService.getAnagrams($scope.anagramSearch)
  }
}

angular
  .module('app')
  .controller('AppController', AppController);
