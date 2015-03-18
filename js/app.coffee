eBookApp = angular.module 'EbookApp', []

eBookApp.controller 'MainCtrl', ($scope, $http, Ebook)->
  $scope.onChange = ->
    Ebook.getJSON($scope.search).then (data)-> if data.responseStatus is 200 then $scope.res = data.responseData.feed.entries

# factory
eBookApp.factory 'Ebook', ($http, $q)->
  class Ebook
    getJSON : (word)->
      deferred = $q.defer()
      $uri = "http://ajax.googleapis.com/ajax/services/feed/load?&v=1.0&output=json&callback=JSON_CALLBACK&num=40&q="+encodeURIComponent("http://hon.jp/rest/2.1/"+word+"/ehonsearch/xslt=http://hon.jp/csv/rest_xslsample/sample_20_rss2.xsl&max=20")
      config =
        params:
          timeout: 10000
      $http.jsonp($uri, config).success (data)->
        deferred.resolve data
      deferred.promise
  new Ebook()

