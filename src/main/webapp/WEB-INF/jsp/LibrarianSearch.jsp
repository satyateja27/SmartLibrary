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
	<div ng-app="myApp" ng-controller="myCtrl" ng-init="results=false; normalSearch=false; advancedSearch=false; deleted=false">
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
                           <a class="nav-link" href="#" style="color:white"> Hi, ${sessionScope.user.firstName}</a>
                        </li>
                     	<li class="nav-item">
                           <a class="nav-link btn" ng-click="logout()" style="color:white"><span class="glyphicon glyphicon-off"></span> Logout</a>
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
         				<div class="col-lg-4"></div>
						<div class="col-lg-3 alert alert-success alert-dismissable" ng-show="deleted">
					    	<a href="/librarianSearch" class="close" data-dismiss="alert" aria-label="close">×</a>
					   		<label style="text-align:center"><strong>Success !</strong> Book has been Deleted</label>
				 		 </div>
	 			</div><br/>
         		<div class="row">
		         	<div class="col-lg-5" style="font-size:150%">Specify how do you want to Search the Book</div>
		         	<div class="col-lg-3">
		         		<select class="form-control" ng-change="onMethodChange(method)" ng-model="method" required>
	                        <option disabled value="">Select Method</option>
	                        <option value="otherLibrarian">Search Books By Other Librarian</option>
	                        <option value="allBooks">Search Among all the Books</option>
	                    </select>
	                </div>   
	         	</div><br/><br/>
	         	<div class="row" ng-show="normalSearch">
	         		<div class="col-lg-2">
         				<select class="form-control" ng-change="onOptionChange(searchBy)" ng-model="searchBy" required>
                        	<option disabled value="">Search By</option>
                            <option ng-repeat="option in bookSearchOptions" ng-value="option.value">{{option.name}}</option>
                         </select>
         			</div>	
         			<div class="col-lg-4"><input type="text" ng-model="searchContent" class="form-control" placeholder="Enter Search Content"/></div>
         			<div class="col-lg-2"><button class="btn btn-primary" ng-click="search()">Search</button></div>
	         	</div><br/>
         		<div class="row" ng-show="advancedSearch">
         			<div class="col-lg-3">
         				<select class="form-control" ng-change="onLibrarianActionChange(librarianAction)" ng-model="librarianAction" required>
                        	<option disabled value="">Select Librarian Action</option>
                        	<option value="createdBy">Created By</option>
                        	<option value="updatedBy">Updated By</option>
                         </select>
         			</div>
         			<div class="col-lg-2">
         				<select class="form-control" ng-change="onLibrarianChange(librarian)" ng-model="librarian" required>
                        	<option disabled value="">Select Other Librarian</option>
                            <option ng-repeat="option in librarianSearchOptions" ng-value="option.userId">{{option.firstName}}</option>
                         </select>
         			</div>
         			<div class="col-lg-2"><button class="btn btn-primary" ng-click="getBooks()">Get All Books</button></div>
         		</div><br/>
         		<div class="row" ng-show="results">
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
	         				<td><button class="btn" style="background-color:#42f4b6" ng-click="edit(book.bookId)">Edit</button> 
	         				<button class="btn" style="background-color:#f4426b" ng-click="remove(book.bookId)">Delete</button></td>	
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
         		$scope.bookSearchOptions = [{'value':'author', 'name':'Author'}, {'value':'title', 'name':'Title'},
         		                          {'value':'publisher', 'name':'Publisher'}, {'value':'publicationYear', 'name':'Publication Year'},
         		                          {'value':'tag', 'name' :'Keywords'}];
         		$http.get("/api/user/findOtherLibrarian").then(function(response){
         			$scope.librarianSearchOptions = response.data.users;
         		});
         		var method, searchBy, librarian, librarianAction;
         		$scope.onMethodChange = function(input){
         			method = input;
         			if(input === 'allBooks'){
         				$scope.advancedSearch = false;
         				$scope.normalSearch = true;
         			}else{
         				$scope.advancedSearch = true;
         				$scope.normalSearch = false;
         			}
         		};
         		$scope.onOptionChange = function(input){
         			searchBy = input;console.log(input);
         		};
         		$scope.onLibrarianChange = function(input){
         			librarian = input;console.log(input);
         		};
         		$scope.onLibrarianActionChange = function(input){
         			librarianAction = input;console.log(input);
         		};
         		$scope.search = function(){
         			$http({
         				method:"GET",
         				url:'/api/book/search/'+searchBy,
         				params: {author: $scope.searchContent,
         					title: $scope.searchContent,
         					publisher: $scope.searchContent,
         					publicationYear: $scope.searchContent,
         					tagName: $scope.searchContent},
         	            headers : {'Content-Type': 'application/json'}
         			}).success(function(response){
         				$scope.results = true;
         				$scope.books = response.books;
         			});
         		};
         		$scope.getBooks = function(){
         			$http({
         				method:"GET",
         				url:'/api/book/getByOtherLibrarian',
         				params: {userId:librarian},
         				headers: {'Content-Type': 'application/json'}
         			}).success(function(response){
         				$scope.results = true;
         				if(librarianAction === 'createdBy'){
         					$scope.books = response.created;
         				}else{
         					$scope.books = response.edited;
         				}
         				
         			});
         		};
         		$scope.remove = function(id){
         			$http({
         				method:"POST",
         				url:'/api/book/delete',
         				params: {bookId:id},
         	            headers : {'Content-Type': 'application/json'}
         			}).success(function(response){
         				$scope.deleted = true;
         				$scope.results=false;
         			});
         		};
         		$scope.edit = function(id){
         			window.location.href="/book/"+id+"/edit";
         			
         		};
         		$scope.logout = function(){
         			$http.get('/api/deleteSession').success(function(response){
         				window.location.href="/";
         			});
         		};
         		$http.get('/api/checkSession').success(function(response){
    				if(response.message == 'absent'){
    					window.location.href="/";
    				}
    			});
         	});
         </script>
	
</body>
</html>