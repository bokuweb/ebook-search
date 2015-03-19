eBookApp = angular.module 'EbookApp', []

eBookApp.controller 'MainCtrl', ($scope, $http, Ebook)->
  $scope.onChange = ->
    res = Ebook.search($scope.searchWord).then (res)->
      unless res is "none" then $scope.res = res

# factory
eBookApp.factory 'Ebook', ($http, $q)->
  class Ebook
    NUM = 20
    GOOGLE_FEED_URI = "http://ajax.googleapis.com/ajax/services/feed/load?&v=1.0&output=json&callback=JSON_CALLBACK&num="+NUM+"&q="

    search : (word)->
      deferred = $q.defer()
      uri = GOOGLE_FEED_URI + encodeURIComponent("http://hon.jp/rest/2.1/"+word+"/ehonsearch/xslt=http://hon.jp/csv/rest_xslsample/sample_20_rss2.xsl&max="+NUM)
      books = []
      _getJSON(uri).then (res)->
        if res.responseStatus is 200
          books.push v for v in res.responseData.feed.entries when _validateTitle(v.title, word) isnt -1
          console.dir books
          deferred.resolve books
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

    _validateTitle = (title, word)->
      reg = new RegExp word , "i"
      title.search reg

  new Ebook()
