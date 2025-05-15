<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<title>메인 페이지</title>
	
	<!-- src/main/resources/static 경로에 있는 css 파일 연결 -->
	<link rel="stylesheet" href="/css/style.css">
    <!-- 근데 아래처럼 작성해도 css 적용이 됨 -->
    <!-- <link rel="stylesheet" href="/style.css">  -->
</head>
<body>
	
	<%=	session.getAttribute("userId") %>
	<%=	session.getAttribute("userName") %>
	
	<br>
	
    <h1>사용자 목록 - DB 조회</h1>
    <table border="1">
        <tr>
            <th>ID</th><th>Name</th><th>Email</th>
        </tr>
        <c:forEach var="user" items="${users}">
            <tr>
                <td>${user.id}</td>
                <td>${user.name}</td>
                <td>${user.email}</td>
            </tr>
        </c:forEach>
    </table>
    
    <br>
    <!-- src/main/resources/static 경로에 있는 이미지 파일 연결 -->
    <img src="/images/망곰이.png" alt="" width="200">
    <br>
    
	<%
		// 세션에 값 세팅
		String userId = "User123";
		String userName = "이유저";
		
		session.setAttribute("userId", userId);
		session.setAttribute("userName", userName);
	%>
	
    <a href="/secondPage">
        <button>두 번째 페이지로 이동</button>
    </a>
    
</body>
</html>