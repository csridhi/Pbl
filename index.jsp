<%-- 
  This is a JSP comment -- it does NOT appear in the browser's output,
  unlike an HTML comment <!-- like this --> which would.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 
  The line above is a "page directive" -- one of the JSP directives 
  mentioned in your learning objectives. It tells Tomcat how to process 
  this page: what content type to send back, and that scriptlets (the 
  Java code blocks) are written in Java.
--%>

<!DOCTYPE html>
<html>
<head>
    <title>Green Mobility - Test Page</title>
</head>
<body>
    <h1>Tomcat + JSP is working!</h1>

    <%-- 
      This is a JSP EXPRESSION: <%= ... %>
      Whatever Java expression is inside gets evaluated and its result 
      is printed directly into the HTML output. This is the "clean" way 
      to output dynamic values -- your learning objectives mention 
      preferring expressions over scriptlets.
    --%>
    <p>The current server time is: <%= new java.util.Date() %></p>

    <%-- 
      This is a JSP SCRIPTLET: <% ... %>
      Unlike an expression, a scriptlet can contain any Java code -- 
      loops, if-statements, variable declarations -- but it does NOT 
      automatically print anything. You'd need System.out.print-style 
      calls (actually "out.println" in JSP) to show something.
      
      Scriptlets are the "old-school" way of doing logic in JSP, and 
      part of your learning objective is to MINIMIZE these in favor of 
      expressions/JSTL. This one is just here to demonstrate the syntax.
    --%>
    <%
        int testNumber = 5 + 5;
    %>
    <p>5 + 5 calculated in a scriptlet = <%= testNumber %></p>

</body>
</html>
