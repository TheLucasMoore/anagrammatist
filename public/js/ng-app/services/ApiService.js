function ApiService($http) {
  return {
    getAnagrams: function(query) {
      $http.get('/anagrams/' + query + '.json').then(res => {
        console.log(res.data.anagrams);
      })
    }
  }
}

angular
  .module('app')
  .service('ApiService', ApiService)
