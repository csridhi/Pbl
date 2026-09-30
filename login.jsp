<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.greenmobility.dao.StudentDAO, com.greenmobility.dao.Student" %>
<%@ page import="com.greenmobility.dao.AdminDAO, com.greenmobility.dao.Admin" %>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="java.net.URLEncoder" %>

<%
    String errorMessage = null;
    String action = request.getParameter("action");

    if ("login".equals(action)) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        // NEW: which account type the user picked on the form -- "student" or "admin".
        // Defaults to "student" if somehow missing, so old bookmarked links still work.
        String role = request.getParameter("role");
        if (role == null) role = "student";

        if ("admin".equals(role)) {
            // ---- ADMIN LOGIN BRANCH ----
            AdminDAO adminDAO = new AdminDAO();
            Admin admin = null;
            try {
                admin = adminDAO.authenticate(email, password);
            } catch (Exception e) {
                errorMessage = "A database error occurred: " + e.getMessage();
            }

            if (admin != null) {
                // A DIFFERENT session attribute (adminId, not studentId) --
                // this is what lets other pages tell an admin session apart
                // from a student session.
                session.setAttribute("adminId", admin.getAdminId());
                session.setAttribute("adminName", admin.getName());
                response.sendRedirect("admin-dashboard.jsp");
                return;
            } else {
                errorMessage = "Invalid admin email or password.";
            }

        } else {
            // ---- STUDENT LOGIN BRANCH (unchanged from before) ----
            StudentDAO studentDAO = new StudentDAO();
            Student student = null;
            try {
                student = studentDAO.authenticate(email, password);
            } catch (Exception e) {
                errorMessage = "A database error occurred: " + e.getMessage();
            }

            if (student != null) {
                session.setAttribute("studentId", student.getStudentId());
                session.setAttribute("studentName", student.getName());

                String encodedName = URLEncoder.encode(student.getName(), "UTF-8");
                Cookie lastLoginCookie = new Cookie("last_login_name", encodedName);
                lastLoginCookie.setMaxAge(7 * 24 * 60 * 60);
                response.addCookie(lastLoginCookie);

                response.sendRedirect("browse.jsp");
                return;
            } else {
                errorMessage = "Invalid email or password.";
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Green Mobility - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-5">
                <div class="card shadow-sm">
                    <div class="card-body p-4">
                        <h3 class="card-title mb-3 text-center">🌱 Green Mobility Login</h3>

                        <% if (errorMessage != null) { %>
                            <div class="alert alert-danger"><%= errorMessage %></div>
                        <% } %>

                        <form method="post" action="login.jsp">
                            <input type="hidden" name="action" value="login">

                            <!-- NEW: role selector -- lets the same login page/form 
                                 serve both students and admins, routing to the 
                                 right DAO and the right landing page after login. -->
                            <div class="mb-3 text-center">
                                <div class="btn-group" role="group">
                                    <input type="radio" class="btn-check" name="role" id="roleStudent" value="student" checked>
                                    <label class="btn btn-outline-success" for="roleStudent">Login as Student</label>

                                    <input type="radio" class="btn-check" name="role" id="roleAdmin" value="admin">
                                    <label class="btn btn-outline-success" for="roleAdmin">Login as Admin</label>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="text" name="email" class="form-control" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <input type="password" name="password" class="form-control" required>
                            </div>

                            <button type="submit" class="btn btn-success w-100">Login</button>
                        </form>

                        <p class="text-muted small mt-3 text-center">
                            Student: test@campus.edu / test123<br>
                            Admin: admin@campus.edu / admin123
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
