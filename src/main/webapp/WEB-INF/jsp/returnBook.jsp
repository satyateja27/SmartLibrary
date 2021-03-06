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
    
    <title>Book | Return</title>
    
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
         <div align=right>
                     <h5>Date, ${sessionScope.systemDate}</h5>
                    
                     </div>
         <div>
         	<div class="col-sm-1"></div>
         	<div class="col-sm-10">
         		<h3 style="text-align:center">Your books </h3>
         		<div class="row" ng-hide="booksReturnedFlag">
	         		<h4>{{nobooks}}</h4><br/>
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
	         				<td><input type="checkbox" ng-model="book.selected" style="background-color:#42f4b6"  ng-change="selectBook(book)" >Add to Return list</td>
	         			
	         				</tr>
	         				
	         		</table>
	         		<br>
	         			<div class="row">
	         			<div class="col-lg-4"></div>
	         			<div class="col-lg-4"><button class="btn btn-primary form-control" ng-click="returnBook()">Proceed to Return Books</button></div>
	         	</div>
	         		<br/>
	         		
         		</div>
         		<div class="row" ng-hide="returnHistoryFlag">
         		<h3>Following Books has been Returned</h3>
	         		<table>
	         			<tr>
	         				<th>Author</th>
	         				<th>Title</th>
	         				<th>Publisher</th>
	         				<th>Due Amount</th>
	         				
	         			</tr>
	         			<tr ng-repeat="book in data.books">
	         				<td>{{book.author}}</td>
	         				<td>{{book.title}}</td>
	         				<td>{{book.publisher}}</td>
	         				<td>{{data.DueAmount[$index]}}</td>
	         			</tr>
	         				
	         		</table>
	         		<br>
	         	
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
         		$scope.booksReturnedFlag=false;
         		$scope.returnHistoryFlag=true;
         		$scope.returnbooks=[];
         		$scope.disabled=
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
         					console.log(response.books);
         					console.log(response.books[0].book);
         					$scope.books=response.books;
         				}
         				else{
         					$scope.nobooks="There are no books checked out to return";
         				}
         			})
         		}
         		$scope.selectBook=function(book){
         			book.disabled=true;
         			if(book.selected){ //If it is checked
         		      
         		      $scope.returnbooks.push(book.transactionId);
         		     console.log("returnbooks"+$scope.returnbooks);
         		   }
         			else{
         				
         				var id=$scope.returnbooks.indexOf(book.transactionId);
         				if(id>-1){
         					$scope.returnbooks.splice(id,1);
         				}
         				console.log("returnbooks"+$scope.returnbooks);
         				
         			}
         		
         		}
         		$scope.returnBook=function(){
         			if($scope.returnbooks.length==0){
         				alert("Please select books to return");
         			}
         			else{
         				
         				$http({
             				method:"POST",
             				url: '/api/book/returnBook',
             				data: {"transactionId":$scope.returnbooks},
             				header:{'Content-Type': 'application/json'}
             			}).success(function(data){
             				if(data.status ==200){
             					$scope.booksReturnedFlag=true;
             					$scope.returnHistoryFlag=false;
             					console.log(data);
             					alert("Books Successfully Returned");
             					$scope.data=data;
             					
             					
             				}
             				else{
             					alert("Internal Error Occurred, couldnot return books please try again");
             					$scope.getBookstoReturn();
             				}
             			});
         			}
         		}
         	});
         </script>
	
</body>
</html>