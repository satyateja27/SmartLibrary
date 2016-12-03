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
    
    <title>Book | Edit</title>
    
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
                           <a class="nav-link" href="/book/create"style="color:white">Create Book</a>
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
         		<h1>Edit Book</h1><br/><br/>
         		<form class="form-group col-sm-3" method="post" action="/api/book/${book.bookId}/edit">
	         		<b>Author:</b> <input class="form-control" type="text" placeholder="${book.author}" value="${book.author}" name="author"/><br/><br/>
	         		<b>Title:</b> <input class="form-control" type="text" placeholder="${book.title}" value="${book.title}" name="title"/><br/><br/>
	         		<b>Publisher:</b> <input class="form-control" type="text" placeholder="${book.publisher}" value="${book.publisher}" name="publisher"/><br/><br/>
	         		<b>Publication Year:</b> <input class="form-control" type="text" placeholder="${book.yearOfPublication}" value="${book.yearOfPublication}" name="publicationYear"/><br/><br/>
         			<b>Call Number:</b> <input class="form-control" type="text" placeholder="${book.callNumber}" value="${book.callNumber}" name="callNumber"/><br/><br/>
         			<b>Location:</b> <input class="form-control" type="text" placeholder="${book.location}" value="${book.location}" name="location"/><br/><br/>
         			<input type="submit" value="Update" class="btn btn-primary"/>
         		</form><br/>
         	</div>
         	<div class="col-sm-1"></div>
         </div>
         </div>
         <script>
         	var app = angular.module('myApp',[]);
         	app.controller('myCtrl', function($scope, $http){
         		$scope.logout = function(){
         			$http.get('/api/deleteSession').success(function(response){
         				window.location.href="/";
         			});
         		};
         	});
         </script>
	
</body>
</html>