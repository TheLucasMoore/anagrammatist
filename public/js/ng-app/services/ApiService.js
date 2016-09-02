function ApiService($http) {
  return {
    getAnagrams: function(query) {
      return $http.get('/anagrams/' + query + '.json').then(res => {
        return res.data.anagrams;
      });
    }
  }
}

angular
  .module('app')
  .service('ApiService', ApiService)
