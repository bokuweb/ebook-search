eBookApp = angular.module 'EbookApp', []

eBookApp.controller 'MainCtrl', ($scope, $http, Ebook)->
  $scope.onChange = ->
    res = Ebook.search($scope.searchWord).then (res)->
      unless res is "none" then $scope.res = res

# factory
eBookApp.factory 'Ebook', ($http, $q)->
  class Ebook
    GOOGLE_FEED_URI = "http://ajax.googleapis.com/ajax/services/feed/load?&v=1.0&output=json&callback=JSON_CALLBACK&num=40&q="

    search : (word)->
      deferred = $q.defer()
      uri = GOOGLE_FEED_URI + encodeURIComponent("http://hon.jp/rest/2.1/"+word+"/ehonsearch/xslt=http://hon.jp/csv/rest_xslsample/sample_20_rss2.xsl&max=20")
      _getJSON(uri).then (res)->
        if res.responseStatus is 200 then deferred.resolve res.responseData.feed.entries
        else deferred.resolve "none"
      deferred.promise

    _getJSON = (uri)->
      deferred = $q.defer()
      config =
        params:
          timeout: 10000
      $http.jsonp(uri, config).success (data)->
        deferred.resolve data
      deferred.promise

  new Ebook()
