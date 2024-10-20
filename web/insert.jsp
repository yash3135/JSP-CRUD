<%@page contentType="text/html" import="java.sql.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"
        />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
        Connection connection = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3307/students", "root", "");


            String name = request.getParameter("name");
            
            int grade = (request.getParameter("grade") != null && !request.getParameter("grade").isEmpty()) ? Integer.parseInt(request.getParameter("grade")) : 0;
            
            String idParam = request.getParameter("userid");
            int id = (idParam != null && !idParam.isEmpty()) ? Integer.parseInt(idParam) : -1;
            
            String deletedIdParam = request.getParameter("deletedId");
            int deletedId = (deletedIdParam != null && !deletedIdParam.isEmpty()) ? Integer.parseInt(deletedIdParam) : -1;
            
            if (deletedId != -1) {
                String deleteQuery = "DELETE FROM data WHERE id = ?";
                PreparedStatement statement = connection.prepareStatement(deleteQuery);
                statement.setInt(1, deletedId);

                int effected_rows = statement.executeUpdate();
                if (effected_rows > 0) {
                    response.sendRedirect("index.jsp?action=delete&status=success");
                } else {
                    response.sendRedirect("index.jsp?action=delete&status=error");
                }


            } else if(id == -1) {
                String query = "INSERT INTO data (name, grade) VALUES(?, ?)";
                PreparedStatement statement = connection.prepareStatement(query);
    
                statement.setString(1, name);
                statement.setInt(2, grade);

                int effected_rows = statement.executeUpdate();
                if (effected_rows > 0) {
                    response.sendRedirect("index.jsp?action=insert&status=success");
                } else {
                    response.sendRedirect("index.jsp?action=insert&status=error");
                }
                statement.close();

            } else {
                String query = "UPDATE data SET name = ?, grade = ? WHERE id = ?";
                PreparedStatement statement = connection.prepareStatement(query);

                statement.setString(1, name);
                statement.setInt(2, grade);
                statement.setInt(3, id);
    
                int effected_rows = statement.executeUpdate();
                if (effected_rows > 0) {
                    response.sendRedirect("index.jsp?action=update&status=success");
                } else {
                    response.sendRedirect("index.jsp?action=update&status=error");
                }
                
                statement.close();
            }
            

            connection.close();
        } catch (Exception e) {
            out.println(e);
        } 
        
        %>
    </body>
</html>
