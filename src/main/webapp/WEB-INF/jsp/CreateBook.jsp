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

<title>Create | Book</title>

<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>

<style>
table {
	border-collapse: collapse;
	width: 100%;
}

th, td {
	text-align: left;
	padding: 8px;
}

tr:nth-child(even) {
	background-color: #f2f2f2
}

th {
	background-color: #5784cc;
	color: white;
}
</style>

</head>
<body>
	<div ng-app="myApp" ng-controller="myCtrl">
		<div class="panel panel-default">
			<div class="panel-body bg-primary" style="height: 65px">
				<nav class="navbar navbar-light">
					<div class="container-fluid">
						<ul class="nav navbar-nav">
							<li class="nav-item"><a class="nav-link"
								href="/admin/dashBoard" style="color: white">Librarian
									Dashboard</a></li>
							<li class="nav-item"><a class="nav-link"
								href="/admin/createImage" style="color: white">Create Book</a></li>
							<li class="nav-item"><a class="nav-link"
								href="/admin/changeCost" style="color: white">Search Books</a></li>
						</ul>
						<ul class="nav navbar-nav navbar-right">
							<li class="nav-item"><a class="nav-link" href="#"
								style="color: white"><span class="glyphicon glyphicon-off"></span>
									Logout</a></li>
						</ul>
					</div>
				</nav>
			</div>
		</div>
		<div>
			<div class="col-sm-1"></div>
			<div class="col-sm-11">
				<h1>Create Book</h1>
				<div>
					<form>
						<h3>Enter the details:</h3>
						<select ng-model="myVar">
							<option value="">
							<option value="manual">Enter Manually
							<option value="isbn">Enter by ISBN
						</select>
					</form>						
						<div >
							<br>
							<div class="col-sm-4" style="text-align: center">
								<div class="col-sm-6" style="text-align: center">
									<div>
										<input type="text" class="form-control" placeholder="ISBN"
											ng-model="search"><br>
									</div>
								Book Detail : {{description}}
								</div>
								<div class="col-sm-6" style="text-align: center">
									<div>
										<button type="button" ng-click="findByIsbn()"
											class="btn btn-primary">Search Book</button>
									</div>
									<br>
								</div>
								Book Detail : {{description}}
								<div>
									<input type="text" class="form-control" placeholder="Author"
										ng-model="author"><br>
								</div>
								<div>
									<input type="text" class="form-control" placeholder="Title"
										ng-model="title"><br>
								</div>
								<div>
									<input type="text" class="form-control"
										placeholder="Call Number" ng-model="callNumber"><br>
								</div>
								<div>
									<input type="text" class="form-control" placeholder="Publisher"
										ng-model="publisher"><br>
								</div>
								<div>
									<input type="text" class="form-control"
										placeholder="Year of Publication" ng-model="yearOfPublication"><br>
								</div>
								<div>
									<input type="text" class="form-control" placeholder="Location"
										ng-model="location"><br>
								</div>
								<div>
									<input type="text" class="form-control"
										placeholder="Number of Copies" ng-model="numberOfCopies"><br>
								</div>
								<div>
									<input type="text" class="form-control" placeholder="Keyword 1"
										ng-model="keyword1"><br>
								</div>
								<div>
									<input type="text" class="form-control" placeholder="Keyword 2"
										ng-model="keyword2"><br>
								</div>
								<div>
									<input type="text" class="form-control" placeholder="Keyword 3"
										ng-model="keyword3"><br>
								</div>
								<div>
									<button type="button" ng-click="register()"
										class="btn btn-primary">Add Book</button>
								</div>
								<br>
							</div>
							<div class="col-sm-4" style="text-align: center"></div>
							<div class="col-sm-4" style="text-align: center"></div>
						</div>
				</div>
				<br />
			</div>
		</div>
	</div>
	<script>
		var app = angular.module('myApp', []);
		app.controller('myCtrl', function($scope, $http) {			
			$scope.findByIsbn = function() {
				var payload = new FormData();
				payload.append("isbn",$scope.search);
				console.log(payload);
				var request = $http({
					method : "GET",
					url : "/api/book/getBook",
					params: {isbn:$scope.search},
					headers : {
						'Content-Type' : 'application/json'
					},
				});
				console.log(request);
				request.success(function(data) {
					$scope.publisher = data.publisher;
					$scope.description = data.description;
					$scope.title = data.title;
					$scope.author = data.author;
				});
			}
		});
	</script>

</body>
</html>