<!DOCTYPE HTML>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="true" %>

<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Pragma" content="no-cache"> 
    <meta http-equiv="Cache-Control" content="no-cache"> 
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
    
    <title>Task Manager | Home</title>
    
    <link href="static/css/bootstrap.min.css" rel="stylesheet">
     <link href="static/css/style.css" rel="stylesheet">
    
    <!--[if lt IE 9]>
		<script src="static/js/html5shiv.min.js"></script>
		<script src="static/js/respond.min.js"></script>
	<![endif]-->
</head>
<body>

	<div role="navigation">
		<div class="navbar navbar-inverse">
			<a href="/" class="navbar-brand">Bootsample</a>
			<div class="navbar-collapse collapse">
				<ul class="nav navbar-nav">
					<li><a href="new-task">New Task</a></li>
					<li><a href="all-tasks">All Tasks</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div ng-app="myApp" ng-controller="myCtrl">

	<p>Today's welcome message is:</p>

	<h1>{{myWelcome.data.name}}</h1>
	<h1>${sessionScope.user.userId}</h1>
	<h1>{{name}}</h1>  <button ng-click="myFunc()">OK</button>
  	<p>The button has been clicked {{count}} times.</p>
	</div>
	
	
<script>
var app = angular.module('myApp', []);
app.controller('myCtrl', function($scope, $http,$window) {
  $http.get("/hello")
  .then(function(response) {
      $scope.myWelcome = response;
  });
  $scope.count = 0;
  $scope.myFunc = function() {
	  $window.location.href = "http://google.com";
      $scope.count++;
  };
  $http.get("/api/setSampleSession")
  .then(function(response) {
	  $scope.user = sessionStorage.getItem("user");
  });
  $scope.myFunction = function(){
	  $window.location.href = "http://google.com";
	  $scope.name = "Vimal";
  }
});
</script>
	
</body>
</html>