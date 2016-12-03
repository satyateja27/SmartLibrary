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
                           <a class="nav-link" href="/testing" style="color:white">Patron Dashboard</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/book/create"style="color:white">Your books</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/book/PatronSearch" style="color:white">Search Books</a>
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
         	<div class="col-sm-1" ></div>
         	<div class="col-sm-8" ng-init=getAllBooks()>
         		<h1>Patron Dashboard</h1><br/><br/>
         		<div>
	         		<h3>Books available</h3>
	         		<table>
	         			<tr>
	         				<th>Author</th>
	         				<th>Title</th>
	         				<th>Call Number</th>
	         				<th>Publisher</th>
	         				<th>Publication Year</th>
							<th>Take them home</th>
	         			</tr>
	         			<tr ng-repeat="book in books">
	         				<td>{{book.author}}</td>
	         				<td>{{book.title}}</td>
	         				<td>{{book.callNumber}}</td>
	         				<td>{{book.publisher}}</td>
	         				<td>{{book.yearOfPublication}}</td>
	         				<td>  <button type="button" class="btn btn-success" ng-click=Cart(book)>Add to cart</button>
	         			</tr>
	         		</table>
         		</div><br/>
         	</div>
         	<div class="col-sm-3" style="border-color:#cccccc;border-style:solid; border-width:1px;">
         	<div ng-repeat="book in cart">
         	         {{book.author}}
                     {{book.title}}
      				 {{book.callNumber}}
                     {{book.publisher}}
            	     {{book.yearOfPublication}}
         	</div>
         	</div>
         </div>
         </div>
         <script>
         	var app = angular.module('myApp',['ngStorage']);
         	app.controller('myCtrl', function($scope, $http,$localStorage){
                 $scope.cart=[];
         		$scope.getAllBooks=function(){
         		        $http.get("/api/book/getAllBooks").then(function(response){
         			     console.log(response)
         		        	$scope.books = response.books;
         		});
         		}
         		$scope.Cart=function(book){
                    var length=$scope.cart.length;
         			if($scope.cart.length<=5){
                    count=0;
                    for(var i=0;i<length;i++){
                        if($scope.cart.book[i].title==book.title){
                            count++;
                        }
                    }
                    if(count>0){

                    }
                    else{
                    $scope.cart.push(book);
                    $localStorage.cart=$scope.cart;
                    }
                                        }
                    else{
                    $scope.message="You have exceeded the limit if you want to add more books please delete the previous books";
         		}
         		}
         	});

         </script>

</body>
</html>