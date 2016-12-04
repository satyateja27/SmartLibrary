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
    
    <title>Librarian | Create Book</title>
    
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	  <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
	  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
	  
	  <style>
		table {
		    border-collapse: collapse;
		    width: 100%;
		}
		
		th, td {
		    text-align: left;
		    padding: 8px;
		}
		
		tr:nth-child(even){background-color: #f2f2f2}
		
		th {
		    background-color: #5784cc;
		    color: white;
		}
	</style>
	  
</head>
<body>
	<div ng-app="myApp" ng-controller="myCtrl" ng-init="show=true; created=false">
	<div class = "panel panel-default">
            <div class = "panel-body bg-primary" style=" height:65px">
               <nav class="navbar navbar-light">
                  <div class="container-fluid">
                     <ul class="nav navbar-nav">
                        <li class="nav-item">
                           <a class="nav-link" href="/librarianDashboard" style="color:white">Librarian Dashboard</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/createBook"style="color:white">Create Book</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/librarianSearch" style="color:white">Search Books</a>
                        </li>
                     </ul>
                     <ul class="nav navbar-nav navbar-right">
                     	<li class="nav-item">
                           <button class="nav-link btn" ng-click="logout()" style="color:white"><span class="glyphicon glyphicon-off"></span> Logout</button>
                        </li>
                     </ul>
                  </div>
               </nav>
            </div>
         </div>
         <div>
         	<div class="col-sm-1"></div>
         	<div class="col-sm-10">
         		<h1>Create Book</h1><br/><br/>
         		<div>
         			<div class="row">
         				<div class="col-lg-4"></div>
						<div class="col-lg-3 alert alert-success alert-dismissable" ng-show="created">
					    	<a href="/createBook" class="close" data-dismiss="alert" aria-label="close">×</a>
					   		<label style="text-align:center"><strong>Success !</strong> Book has been Created</label>
				 		 </div>
	 				 </div>
	         		<div class="row">
		         		<div class="col-lg-5" style="font-size:150%">Specify how do you want to create the Book</div>
		         		<div class="col-lg-2">
		         			<select class="form-control" ng-change="onOptionChange(createBy)" ng-model="createBy" required>
	                        	<option disabled value="">Select Method</option>
	                        	<option value="manual">Add Manually</option>
	                            <option value="isbn">Add Using ISBN</option>
	                         </select>
	                    </div>   
	         		</div><br/>
	         		<div class="row" ng-hide="show">
	         			<div class="col-lg-3"><input type="text" class="form-control" placeholder="Enter ISBN" ng-model="isbnValue"/></div>
	         			<div class="col-lg-2"><button class="btn btn-primary" ng-click="getIsbnBook()">Get Book Details</button></div>
	         		</div><br/>
	         		<div class="row col-lg-4">
	         			<input type="text" class="form-control" placeholder="Author" ng-model="author"/><br/>
	         			<input type="text" class="form-control" placeholder="Title" ng-model="title"/><br/>
	         			<input type="text" class="form-control" placeholder="Publisher" ng-model="publisher"/><br/>
	         			<input type="text" class="form-control" placeholder="Year of Publication" ng-model="yearOfPublication"/><br/>
	         			<input type="text" class="form-control" placeholder="Number of Copies" ng-model="numberOfCopies"/><br/>
	         			<input type="text" class="form-control" placeholder="Call Number" ng-model="callNumber"><br/>
	         			<input type="text" class="form-control" placeholder="Location" ng-model="location"><br/>
	         			<input type="text" class="form-control" placeholder="Keyword 1" ng-model="keyword1"/><br/>
	         			<input type="text" class="form-control" placeholder="Keyword 2" ng-model="keyword2"/><br/>
	         			<input type="text" class="form-control" placeholder="Keyword 3" ng-model="keyword3"/><br/>
	         			<button type="button" class="btn btn-primary" ng-click="createBook()">Add Book</button>
	         		</div><br/>
         		</div><br/>
         	</div>
         	<div class="col-sm-1"></div>
         </div>
         </div>
         <script>
         	var app = angular.module('myApp',[]);
         	app.controller('myCtrl', function($scope, $http){
         		$http.get('/api/checkSession').success(function(response){
    				if(response.message == 'absent'){
    					window.location.href="/";
    				}
    			});
         		$scope.logout = function(){
         			$http.get('/api/deleteSession').success(function(response){
         				window.location.href="/";
         			});
         		};
         		$scope.onOptionChange = function(option){
         			if(option === 'isbn'){
         				$scope.show = false;
         			}
         		};
         		$scope.getIsbnBook = function(){
         			$http({
         				method:"GET",
         				url:'/api/book/getBookByIsbn',
         				params: {isbn: $scope.isbnValue},
         	            headers : {'Content-Type': 'application/json'}
         			}).success(function(response){
         				$scope.author = response.author;
         				$scope.title = response.title;
         				$scope.publisher = response.publisher;
         			});
         		};
         		$scope.createBook = function(){
         			var copies = parseInt($scope.numberOfCopies);
         			var year = parseInt($scope.yearOfPublication);
         			$http({
         				method:"POST",
         				url:'/api/book/add',
         				data: {author: $scope.author,
         					title: $scope.title,
         					callNumber: $scope.callNumber,
         					publisher: $scope.publisher,
         					yearOfPublication: year,
         					location: $scope.location,
         					numberOfCopies: copies,
         					status: true,
         					keywords: [$scope.keyword1, $scope.keyword2, $scope.keyword3]},
         	            headers : {'Content-Type': 'application/json'}
         			}).success(function(response){
         				$scope.created = true;
         			});
         		};
         	});
         	
         </script>
	
</body>
</html>