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
    
    <title>Librarian | Dashboard</title>
    
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
	<div ng-app="myApp" ng-controller="myCtrl">
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
                   <div align=right>
              
                     <h5>Date, ${sessionScope.systemDate}</h5>
                    <br><br>
                  
                     <h5>Set Date and Time</h5>
                     <form ng-submit="setDate()">
                     <input type="datetime-local"  ng-model="date"  >
                     <input type="submit" name="postDate"  value="Set Date">
                     </form>
                     </div>
         </div>
         <div>
         	<div class="col-sm-1"></div>
         	<div class="col-sm-10">
         		<h1>Librarian Dashboard</h1><br/><br/>
         		<div>
	         		<h3>All Created Books</h3>
	         		<table>
	         			<tr>
	         				<th>Author</th>
	         				<th>Title</th>
	         				<th>Call Number</th>
	         				<th>Publisher</th>
	         				<th>Publication Year</th>
	         				<th>Number of Copies</th>
	         				<th>Last Updated By</th>
	         			</tr>
	         			<tr ng-repeat="book in books">
	         				<td>{{book.author}}</td>
	         				<td>{{book.title}}</td>
	         				<td>{{book.callNumber}}</td>
	         				<td>{{book.publisher}}</td>
	         				<td>{{book.yearOfPublication}}</td>
	         				<td>{{book.numberOfCopies}}</td>
	         				<td>{{book.updatedUser.firstName}} {{book.updatedUser.lastName}}</td>	
	         			</tr>
	         		</table>
         		</div><br/>
         	</div>
         	<div class="col-sm-1"></div>
         </div>
         </div>
         <script>
         	var app = angular.module('myApp',[]);
         	app.controller('myCtrl', function($scope, $http){
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
          				window.location.href="/librarianDashboard";
                 	 });
                 	 
                  }
                 	 }
         		$http.get('/api/checkSession').success(function(response){
    				if(response.message == 'absent'){
    					window.location.href="/";
    				}else{
    					$http.get("/api/book/getByLibrarian").then(function(response){
    	         			$scope.books = response.data.books;
    	         		});
    				}
    			});
         		$scope.logout = function(){
         			$http.get('/api/deleteSession').success(function(response){
         				window.location.href="/";
         			});
         		};
         	});
         	
         </script>
	
</body>
</html>