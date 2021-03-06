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
	<script src="//ajax.googleapis.com/ajax/libs/angularjs/1.4.5/angular-animate.js"></script>
    <script src="//angular-ui.github.io/bootstrap/ui-bootstrap-tpls-0.13.4.js"></script>
</head>
<body ng-app="myApp" ng-controller="myCtrl" ng-init="emailAlert=false">
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
	   		<strong>Error !</strong> {{message}}
	 		 </div>
	 		 <div class="alert alert-danger alert-dismissable" ng-show="emailAlert">
	    	<a href="#" class="close" data-dismiss="alert" aria-label="close">�</a>
	   		<strong>Error !</strong> Please Enter '@sjsu.edu' Domain Email
	 		 </div>
	 		 <div class="alert alert-danger alert-dismissable" ng-show="numberAlert">
	    	<a href="#" class="close" data-dismiss="alert" aria-label="close">�</a>
	   		<strong>Error !</strong> Please Enter valid Domain Email
	 		 </div>
	 		 <div class="alert alert-danger alert-dismissable" ng-show="reCheck">
	    	<a href="#" class="close" data-dismiss="alert" aria-label="close">�</a>
	   		<strong>Error !</strong> Your Email is invalid. Please Enter Valid mail
	 		 </div>
 		 </div>
			<h3>Sign Up for Smart Library</h3>
			<form ng-submit="register()" >
			<div><input type="text" class="form-control" placeholder="First Name" ng-model="firstName" pattern="[A-Za-z].{1,}" title="Please enter only alphabets" required ><br></div>
			<div><input type="text" class="form-control" placeholder="Last Name" ng-model="lastName" required pattern="[A-Za-z].{1,}" title="Please enter only alphabets"><br></div>
			<div><input type="text" class="form-control" placeholder="University Id" ng-model="universityid" required pattern="[0-9]{6}" title="Please enter 6 Digit UID"><br></div>
			<div><input type="email" class="form-control" placeholder="Email id" ng-model="email" required pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{1,}$" title="Please enter correct Email"><br></div>		
			<div><input type="password" class="form-control" placeholder="Password" ng-model="password" required><br></div>
			<div>
		         <select class="form-control" ng-change="getRole(role)" ng-model="role" required>
	             	<option disabled value="" selected>Select the Role</option>
	                <option value="librarian">Librarian</option>
	                <option value="patron">Patron</option>
	             </select>
	        </div>
			<!-- <div class="btn-group">
            <label class="btn btn-primary" ng-model="role" btn-radio="'user'">User</label>
            <label class="btn btn-primary" ng-model="role" btn-radio="'librarian'">Librarian</label>
    		</div> -->

			<br>
			<br>
			<div><input type="submit"  value="SignUp"  class="btn btn-primary"></div>

			<br>
			</form>
			<div><p>Already have an account?  <a href="/">Login here</a></p></div>
		</div>
		<script type="text/javascript">
		var app = angular.module('myApp',['ngAnimate', 'ui.bootstrap']);
		app.controller('myCtrl', function ($scope, $http,$window) {
			$scope.register = function () {
				console.log($scope.role);
				var flag;
				if($scope.role === 'librarian'){
					if($scope.email == undefined){
						console.log('Give Properly');
						$scope.numberAlert = true;
						flag=false;
					}else{
						$scope.numberAlert = false;
						if($scope.role === 'librarian'){
						if(!$scope.email.includes('@sjsu.edu')){
							$scope.emailAlert = true;
							flag=false;
						}else{
							var length = $scope.email.length;
							if($scope.email.lastIndexOf('@sjsu.edu') === length-10){
								$scope.emailAlert = true;
								flag=false;
							}else{$scope.emailAlert = false;
								flag=true;	
							}
						};
						}else{$scope.emailAlert = false
								flag=true;	
						};
					}
					
				}else{
					flag=true;
				} 
				if(flag){
					var request = $http({	
					    method: "POST",
					    url: "/api/register",
					    data:{
					    	'firstName':$scope.firstName,
					    	'lastName' :$scope.lastName,
					    	'universityid':$scope.universityid,
					    	'email':$scope.email,
					    	'password':$scope.password,
					    	'role':$scope.role
					    },
					    headers: { 'Content-Type': 'application/json' }
					});
					request.success(function (data) {
						if(data.message.includes("exists")){
							$scope.error = true;
							$scope.message = data.message;
						}else{
							$window.location.href = "/";
						}	
					});
				}else{
					console.log('recheck');
					$scope.reCheck = true;
				}
			
			};
			$scope.getRole = function(role){
				if($scope.email == undefined){
					console.log('Give Properly');
					$scope.numberAlert = true;
				}else{
					$scope.numberAlert = false;
					if(role === 'librarian'){
					if(!$scope.email.includes('@sjsu.edu')){
						$scope.emailAlert = true;
					}else{
						var length = $scope.email.length;
						if($scope.email.lastIndexOf('@sjsu.edu') === length-10){
							$scope.emailAlert = true;
						}else{$scope.emailAlert = false;}
					};
				}else{$scope.emailAlert = false};
				}
				
			};
			
		});
		</script>
	
</body>
</html>