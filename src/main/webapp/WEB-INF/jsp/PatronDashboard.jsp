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

    <title>Patron | Dashboard</title>

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
	<div ng-app="myApp" ng-controller="myCtrl">
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
                     <br>
                  
                  </div>
               </nav>
                 
            </div>
         </div>
          <div align=right>
                     <h5>Date, ${sessionScope.systemDate}</h5>
                    
                     </div>
         <div>
         	<div class="col-sm-1" ></div>
         	<div class="col-sm-8">
         		<h1>Patron Dashboard</h1><br/><br/>
         		<div>
	         		<h3>Your Waitlisting Books</h3>
	         		<table>
	         			<tr>
	         				<th>Author</th>
	         				<th>Title</th>
	         				<th>Call Number</th>
	         				<th>Publisher</th>
	         				<th>Publication Year</th>
	         				<th>Reservation Status</th>
	         			</tr>
	         			<tr ng-repeat="item in waiting">
	         				<td>{{item.book.author}}</td>
	         				<td>{{item.book.title}}</td>
	         				<td>{{item.book.callNumber}}</td>
	         				<td>{{item.book.publisher}}</td>
	         				<td>{{item.book.yearOfPublication}}</td>
	         				<td><label ng-show="item.reservationFlag" style="color:green">Reserved For You</label>
	         				<label ng-hide="item.reservationFlag" style="color:red">Waiting For Book</label></td>
	         			</tr>
	         		</table>
         		</div><br/>
         	</div>
         	
         	</div>
         </div>
         <script>
         	var app = angular.module('myApp',['ngStorage']);
         	app.controller('myCtrl', function($scope, $http,$localStorage){
                 $scope.cart=[];
                 $scope.setDate=function(){
                	 console.log($scope.date);
                	 if ($scope.date==null){
                		alert("Please enter a valid date and time");
                	 }
                	 else{	$http({
         				method:"POST",
         				url:'/date',
         				data: $scope.date
         			
         			}).success(function(response){
                		 if(response.status==200){
                		 console.log("Date has been set");
                		 }
                		 else{
                			 console.log("Try again");
                		 }
                	 });
                	 
                 }
                	 }
                 
                 
                 
                 $http.get("/api/book/getUserWaiting").then(function(response){
     			     console.log(response)
     		        	$scope.waiting = response.data.waitingBooks;
     			});
         		
         		
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
         	});

         </script>

</body>
</html>