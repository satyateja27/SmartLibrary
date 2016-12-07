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
    
    <title>Book | Reissue</title>
    
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
	<div ng-app="myApp" ng-controller="myCtrl" ng-init="getBookstoReturn()">
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
         		<h3 style="text-align:center">Your books </h3>
         		<div class="row" ng-hide="booksReissueFlag">
         		{{nobooks}}
	         		<table>
	         			<tr>
	         				<th>Author</th>
	         				<th>Title</th>
	         				<th>Publisher</th>
	         				<th>Publication Year</th>
	         				<th>Due Date</th>
	         				<th>Return</th>
	         			</tr>
	         			<tr ng-repeat="book in books">
	         				<td>{{book.book.author}}</td>
	         				<td>{{book.book.title}}</td>
	         				<td>{{book.book.publisher}}</td>
	         				<td>{{book.book.yearOfPublication}}</td>
	         				<td>{{book.endDate | date}}</td>
	         				<td><button class="btn" style="color:white;background-color:#f4426b" ng-click="reissuebook(book)" ng-disabled="book.disabled">Reissue</button></td>
	         			
	         				</tr>
	         				
	         		</table>
	         		
	         		
         		</div>
         		<div class="row" ng-hide="reissued">
         		<h3>Your book has been reissued</h3>
	         		<table>
	         			<tr>
	         				<th>Author</th>
	         				<th>Title</th>
	         				<th>Publisher</th>
	         		
	         				<th>New Due Date is</th>
	         				<th>Extended Times</th>
	         				
	         			</tr>
	         			<tr >
	         				<td>{{data.Book.author}}</td>
	         				<td>{{data.Book.title}}</td>
	         				<td>{{data.Book.publisher}}</td>	         				
	         				<td>{{data.duedate}}</td>
	         				<td>{{data.extended}}</td>
	         				<td></td>
	         				
	         				</tr>      				
	         				
	         		</table>
	         		<div class="row">
	         		<div class="col-md-4"></div>
	         		<br>
	         		<button class="btn" style="color:white;background-color:#f4426b" ng-click="getBookstoReturn()">Reissue more books</button>
	         		<br>
	         		<div class="col-md-4"></div>
	         		</div>
	         		<br/>
	         		
         		</div>
         		
         		<br/>
         	</div>
         	<div class="col-sm-1"></div>
         </div>
         </div>
         <script>
         	var app = angular.module('myApp',['ngStorage']);
         	app.controller('myCtrl', function($scope, $http, $window, $localStorage){
         		$scope.booksReissueFlag=false;
         		$scope.reissued=true;
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
         		$scope.getBookstoReturn=function(){
         			
         			$http.get('/api/book/getIssuedBook').success(function(response){
         			
         				if(response.status==200){
         					$scope.booksReissueFlag=false;
         					$scope.reissued=true;
         					console.log(response.books);
         					console.log(response.books[0].book);
         					$scope.books=response.books;
         				}
         				else{
         					$scope.nobooks="No books are issued for this user";
         				}
         			})
         		}
         		$scope.reissuebook=function(book){
         			book.disabled=true;
					$scope.transactionId=book.transactionId;
					console.log("Inside reissue book"+book.transactionId);
					var payload = new FormData();
					payload.append("transactionid",$scope.transactionId);;
         			$http({
             				method:"POST",
             				url: '/api/book/extendBook',
             				data:payload ,
        				    headers: { 'Content-Type': undefined },
        				    transformRequest: angular.identity
             			}).success(function(data){
             				if(data.status ==200){
             					console.log(data);
             					alert("Books Successfully reissued");
             					$scope.data=data;
             					
             					$scope.booksReissueFlag=true;
             	         		$scope.reissued=false;
             	         		
             				}
             				else{
             					alert("Can not reissue a book more than twice");
             					$scope.booksReissueFlag=false;
             	         		$scope.reissued=true;
             					$scope.getBookstoReturn();
             				}
             			});
         			
         		}
         	});
         </script>
	
</body>
</html>