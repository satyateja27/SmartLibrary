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
	<div ng-app="myApp" ng-controller="myCtrl" ng-init="">
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
         		<div class="row">
	         		<h3>Books in Cart</h3><br/>
	         		<table>
	         			<tr>
	         				<th>Author</th>
	         				<th>Title</th>
	         				<th>Call Number</th>
	         				<th>Publisher</th>
	         				<th>Publication Year</th>
	         				<th>Available Copies</th>
	         				<th>Operation</th>
	         			</tr>
	         			<tr ng-repeat="book in books">
	         				<td>{{book.author}}</td>
	         				<td>{{book.title}}</td>
	         				<td>{{book.callNumber}}</td>
	         				<td>{{book.publisher}}</td>
	         				<td>{{book.yearOfPublication}}</td>
	         				<td>{{book.numberOfCopies}}</td>
	         				<td><button class="btn" style="color:white;background-color:#f4426b" ng-click="remove(book)">Remove</button></td>
	         			</tr>
	         		</table>
	         		<br/>
	         		
         		</div><br/>
         		
         		<div class="row" ng-show="checkout">
	         			<div class="col-lg-4"></div>
	         			<div class="col-lg-4"><input type="submit" class="btn btn-primary form-control" value="Proceed to Checkout" ng-click="proceed()"></button></div>
	         	</div>
	         	<div class="row" ng-show="error">
	         	  	<h4>{{errormessage}}</h4>
	         	  	</div>
         	</div>
         	<div class="col-sm-1"></div>
       
         </div>
         </div>
         <script>
         	var app = angular.module('myApp',['ngStorage']);
         	app.controller('myCtrl', function($scope, $http, $window, $localStorage){
         		$scope.books = $localStorage.items;
         		$scope.waitlist=$localStorage.waitlist;
         		if($localStorage.items.length === 0 && $localStorage.waitlist.length===0){$scope.checkout=false}else{$scope.checkout=true};
         		$scope.remove = function(book){
         			$scope.checkout=true;
         			$scope.error=false;
         			var index = $localStorage.items.indexOf(book);
         			$localStorage.items.splice(index,1);
         			if($localStorage.items.length === 0){$scope.checkout=false}else{$scope.checkout=true};
         		};
         		$scope.logout = function(){
         			$http.get('/api/deleteSession').success(function(response){
         				$localStorage.items = "";
         				window.location.href="/";
         			});
         		};
         		$http.get('/api/checkSession').success(function(response){
    				if(response.message == 'absent'){
    					window.location.href="/";
    				}
    			});
         		$scope.proceed = function(){
         			var bookids = [];
         			for(var i=0; i<$localStorage.items.length; i++){
         				bookids.push($localStorage.items[i].bookId);
         			}
         			$http({
         				method:"POST",
         				url: '/api/book/checkout',
         				data: {book_id: bookids},
         				header:{'Content-Type': 'application/json'}
         			}).success(function(data){
         				if(data.Message === 'Checkout successful'){
         					$localStorage.transaction = data;
         					console.log(data);
         					console.log(data.books);
         					$localStorage.items="";
         					window.location.href = "/afterCheckout";
         				}
         				else if(data.Message==="Can not check out more than 5 books in a day"){
         					console.log(data);
         					$scope.checkout=false;    					
         					$scope.errormessage="Cannot check out more than 5 books in a day";
         					$scope.error=true;
         				}
         				else{
         					$scope.checkout=false;
         					
         					$scope.errormessage="You have reached your limit of 10 books";
         					$scope.error=true;
         				}
         				
         			});
         		};
         		
         	});
         </script>
	
</body>
</html>