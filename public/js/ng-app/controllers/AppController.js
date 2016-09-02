function AppController($scope, ApiService) {
  $scope.title = "Anagrammatist"
  $scope.search = function() {
    $scope.results = '';
    ApiService.getAnagrams($scope.anagramSearch)
      .then(res => {
      console.log(res)
      return $scope.results = res;
    })
  }
}

angular
  .module('app')
  .controller('AppController', AppController);
