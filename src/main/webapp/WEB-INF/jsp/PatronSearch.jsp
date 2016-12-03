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
    
    <title>Book | Search</title>
    
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
	<div ng-app="myApp" ng-controller="myCtrl" ng-init="show=true">
	<div class = "panel panel-default">
            <div class = "panel-body bg-primary" style=" height:65px">
               <nav class="navbar navbar-light">
                  <div class="container-fluid">
                     <ul class="nav navbar-nav">
                        <li class="nav-item">
                           <a class="nav-link" href="/testing" style="color:white">Librarian Dashboard</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/book/create"style="color:white">Create Book</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/book/librarianSearch" style="color:white">Search Books</a>
                        </li>
                     </ul>
                     <ul class="nav navbar-nav navbar-right">
                     	<li class="nav-item">
                           <a class="nav-link" href="#" style="color:white"><span class="glyphicon glyphicon-off"></span> Logout</a>
                        </li>
                     </ul>
                  </div>
               </nav>
            </div>
         </div>
         <div>
         	<div class="col-sm-1"></div>
         	<div class="col-sm-10">
         		<h1 class="row">Librarian Search</h1><br/><br/>
         		<div class="row">
         			<div class="col-lg-2">
         				<select class="form-control" ng-change="onOptionChange(searchBy)" ng-model="searchBy" required>
                        	<option disabled value="">Search By</option>
                            <option ng-repeat="option in bookSearchOptions" ng-value="option.value">{{option.name}}</option>
                         </select>
         			</div>	
         			<div class="col-lg-4"><input type="text" ng-model="searchContent" class="form-control"/></div>
         			<div class="col-lg-2"><button class="btn btn-primary" ng-click="search(searchContent)">Search</button></div>
         		</div>
         		<br/>
         		<div class="row" ng-hide="show">
	         		<h3>Search Results</h3>
	         		<table>
	         			<tr>
	         				<th>Author</th>
	         				<th>Title</th>
	         				<th>Call Number</th>
	         				<th>Publisher</th>
	         				<th>Publication Year</th>
	         				<th>Available Copies</th>
	         				<th>Created By</th>
	         				<th>Last Updated By</th>
	         				<th>Operation</th>
	         			</tr>
	         			<tr ng-repeat="book in books">
	         				<td>{{book.author}}</td>
	         				<td>{{book.title}}</td>
	         				<td>{{book.callNumber}}</td>
	         				<td>{{book.publisher}}</td>
	         				<td>{{book.yearOfPublication}}</td>
	         				<td>{{book.numberOfCopies}}</td>
	         				<td>{{book.createdUser.firstName}} {{book.createdUser.lastName}}</td>
	         				<td>{{book.updatedUser.firstName}} {{book.updatedUser.lastName}}</td>
	         				<td><button class="btn" style="background-color:#42f4b6" ng-click="addCart(book.bookId)">Add to Cart</button></td>	
	         			</tr>
	         		</table>
         		</div><br/>
         	</div>
         	<div class="col-sm-1"></div>
         </div>
         </div>
         <script>
         	var app = angular.module('myApp',[]);
         	app.controller('myCtrl', function($scope, $http, $window){
         		$scope.bookSearchOptions = [{'value': 'author', 'name': 'Author'}, {'value': 'title', 'name': 'Title'},
         		                          {'value': 'publisher', 'name': 'Publisher'}, {'value': 'publicationYear', 'name': 'Publication Year'}];
         		var searchBy;
         		$scope.onOptionChange = function(input){
         			searchBy = input;
         		};
         		$scope.search = function(searchContent){
         			$http({
         				method:"GET",
         				url:'/api/book/search/'+searchBy,
         				params: {author: searchContent,
         					title: searchContent,
         					publisher: searchContent,
         					publicationYear: searchContent},
         	            headers : {'Content-Type': 'application/json'}
         			}).success(function(response){
         				$scope.show = false;
         				$scope.books = response.books;
         			});
         		};
         		$scope.addCart = function(id){
         			$http({
         				method:"POST",
         				url:'/api/book/delete',
         				params: {bookId:id},
         	            headers : {'Content-Type': 'application/json'}
         			}).success(function(response){
         				window.location.href="/book/patronSearch";
         			});
         		};
         		
         	});
         </script>
	
</body>
</html>