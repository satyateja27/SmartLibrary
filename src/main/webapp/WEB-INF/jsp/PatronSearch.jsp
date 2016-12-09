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
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/ngStorage/0.3.10/ngStorage.js"></script>
	  
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
	<div ng-app="myApp" ng-controller="myCtrl" ng-init="show=true; added=false; limitExceed=false; alreadyExist=false">
	<div class = "panel panel-default">
            <div class = "panel-body bg-primary" style=" height:65px">
               <nav class="navbar navbar-light">
                  <div class="container-fluid">
                     <ul class="nav navbar-nav">
                        <li class="nav-item">
                           <a class="nav-link" href="/patronDashboard" style="color:white">Patron Dashboard</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/patronSearch" style="color:white">Search Books</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/returnBook"style="color:white">Return Book</a>
                        </li>
                         <li class="nav-item">
                           <a class="nav-link" href="/reissueBook"style="color:white">Reissue Book</a>
                        </li>
                     </ul>
                     <ul class="nav navbar-nav navbar-right">
                     	<li class="nav-item">
                           <a class="nav-link" href="#" style="color:white"> Hi, ${sessionScope.user.firstName}</a>
                        </li>
                     	<li class="nav-item">
                           <a class="nav-link" href="/cart" style="color:white"><span class="glyphicon glyphicon-shopping-cart"></span> Cart</a>
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
         		<h1 class="row">Patron Search</h1><br/><br/>
         		<div class="row" ng-show="alreadyExist">
         			<div class="col-lg-4"></div>
					<div class="col-lg-4 alert alert-danger alert-dismissable">
				    	<a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
				   		<label style="text-align:center"><strong>Error !</strong> The book is already in cart</label>
			 		 </div>
	 		 	</div>
	 		 	<div class="row" ng-show="added">
         				<div class="col-lg-4"></div>
						<div class="col-lg-4 alert alert-success alert-dismissable">
					    	<a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
					   		<label style="text-align:center"><strong>Success !</strong> Book has been Added to Cart</label>
				 		 </div>
	 			</div>
	 		 	<div class="row" ng-show="limitExceeded">
	 		 		<div class="col-lg-4"></div>
					<div class="col-lg-4 alert alert-danger alert-dismissable">
				    	<a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
				   		<label style="text-align:center"><strong>Error !</strong> Your limit for Cart has Exceed 5</label>
			 		 </div>
	 		 	</div>
         		<div class="row">
         			<div class="col-lg-2">
         				<select class="form-control" ng-change="onOptionChange(searchBy)" ng-model="searchBy" required>
                        	<option disabled value="">Search By</option>
                            <option ng-repeat="option in bookSearchOptions" ng-value="option.value">{{option.name}}</option>
                         </select>
         			</div>	
         			<div class="col-lg-4"><input type="text" ng-model="searchContent" class="form-control"/></div>
         			<div class="col-lg-2"><button class="btn btn-primary" ng-click="search()">Search</button></div>
         		</div><br/>
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
	         				<td><button class="btn" style="background-color:#42f4b6" ng-click="addCart(book)" ng-show="{{book.status}}">Add to Cart</button>
	         					<button class="btn" style="background-color:#f48342" ng-click="addWaitList(book)" ng-hide="{{book.status}}">Add to Wait List</button></td>	
	         			</tr>
	         		</table>
         		</div><br/>
         	</div>
         	<div class="col-sm-1"></div>
         </div>
         </div>
         <script>
         	var app = angular.module('myApp',['ngStorage']);
         	app.controller('myCtrl', function($scope, $http, $window, $localStorage){
         		$scope.bookSearchOptions = [{'value':'author', 'name':'Author'}, {'value':'title', 'name':'Title'},
         		                          {'value':'publisher', 'name':'Publisher'}, {'value':'publicationYear', 'name':'Publication Year'},
         		                          {'value':'tag', 'name' :'Keywords'}];
         		var searchBy;
         		$scope.onOptionChange = function(input){
         			searchBy = input;
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
         				$scope.show = false;
         				$scope.books = response.books;
         			});
         		};
         		$scope.logout = function(){
         			$http.get('/api/deleteSession').success(function(response){
         				$localStorage.items = "";
         				$localStorage.waitlist="";
         				window.location.href="/";
         			});
         		};
         		$http.get('/api/checkSession').success(function(response){
    				if(response.message == 'absent'){
    					window.location.href="/";
    				}
    			});
         		$scope.cart = [];
         		
         		if($localStorage.items==""){
         			
         		}
         		else{
         		$scope.cart=$localStorage.items;
         		}
         		$scope.addCart = function(book){
         			
         			var length = $scope.cart.length;
         			var flag;
         			console.log(length);
         			if(length===0){
         				$scope.cart.push(book);
         				$scope.added = true;
         			}else if(length>=5){
         				$scope.added = false;
         				$scope.alreadyExist = false;
         				$scope.limitExceeded = true;        				
         			}else{
         				for(var i=0; i<length; i++){
         					if($scope.cart[i].bookId === book.bookId){
         						$scope.alreadyExist = true;
         						$scope.added = false;
         						$scope.limitExceeded = false;
								flag = false;
								break;
                            }else{
                            	flag = true;
                            }	
         				}
         				if(flag == true){
         					if(length<5){
         						$scope.cart.push(book);
                            	$scope.added = true;
                            	$scope.alreadyExist = false;
                 				$scope.limitExceeded = false;
         					}
         					
         				}	
         			};
         			$localStorage.items = $scope.cart;
         		};
         		$scope.waitlist = [];
         		if($localStorage.waitlist==""){
     		}
     			else{
     			$scope.waitlist=$localStorage.waitlist;
     		}
         		$scope.addWaitList=function(book){
         			console.log(book);
         			$scope.waitlist.push(book);
         		console.log(book);
         		$localStorage.waitlist=$scope.waitlist;
         		}
         	});
         </script>
	
</body>
</html>