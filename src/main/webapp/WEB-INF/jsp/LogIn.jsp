<!DOCTYPE HTML>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Pragma" content="no-cache"> 
    <meta http-equiv="Cache-Control" content="no-cache"> 
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
    
    <title>Smart Library | Login</title>
    
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body ng-app="myApp" ng-controller="myCtrl">
		<div >
			<nav class="navbar navbar-dark bg-primary" style="padding:10px">
				<h2 style="text-align:center"><b><span class="glyphicon glyphicon-book"></span> Smart Library</b></h2>
				<h4><p style="text-align:center">A room without books is like a body without a soul - <i>Marcus Tullius Cicero</i></p></h4>
			</nav>
		</div>
		<div class="col-sm-4" style="text-align:center"></div>
		<div class="col-sm-4" style="text-align:center">
			<div >
			<div class="alert alert-danger alert-dismissable" ng-show="error">
	    	<a href="#" class="close" data-dismiss="alert" aria-label="close">�</a>
	   		<strong>Error !</strong> Invalid Email/Password. Try again!
	 		 </div>
	 		 </div>
			<h3 >Log in to Smart Library</h3><br>
			<div class="input-group">
				<span class="input-group-addon" id="basic-addon1">
					<button type="button" class="btn btn-default">
						<span class="glyphicon glyphicon-user"></span>
					</button>
				</span>
				<input type="email" ng-model="email" class="form-control" placeholder="Email id" name="email" aria-describedby="basic-addon1" style="height:50px"><br>
			</div>
			<br>
			<div class="input-group">	
				<span class="input-group-addon" id="basic-addon1">
					<button type="button" class="btn btn-default">
						<span class="glyphicon glyphicon-lock"></span>
					</button>
				</span>
				<input type="password" class="form-control" placeholder="Password" name="password" ng-model="password" aria-describedby="basic-addon1" style="height:50px"><br>
			</div>
			<br>
			<div><button type="button" ng-click="login()" class="btn btn-primary">Login</button></div>
			<br>
			<div><p>Don't have an account yet?  <a href="/signup">Signup here</a></p></div>
			<span ng-model="test"></span>
		</div>
		
		<script type="text/javascript">
		var app = angular.module('myApp',[]);
		app.controller('myCtrl', function ($scope, $http,$window) {
			$scope.login = function () {
				var payload = new FormData();
				payload.append("email",$scope.email);
				payload.append("password",$scope.password);
				console.log($scope.email);
				var request = $http({	
				    method: "POST",
				    url: "/api/login",
				    data:payload ,
				    headers: { 'Content-Type': undefined },
				    transformRequest: angular.identity
				});
				request.success(function (data) {
					if(data.message.includes("Error")){
						$scope.error = true;
					}else if(data.message.includes("verfied")){
						$window.location.href = "/approveUser";
					}else{
						if(data.role === 'librarian'){
							$window.location.href="/librarianDashboard";
						}else{
							$window.location.href="/userDashboard";
						};
						
					}
				});
			};
			$http.get('/api/checkSession').success(function(response){
				if(response.message == 'present'){
					if(response.role === 'librarian'){
						$window.location.href="/librarianDashboard";
					}else{
						$window.location.href="/userDashboard";
					}
				}
			});
		});
		</script>
	
</body>
</html>