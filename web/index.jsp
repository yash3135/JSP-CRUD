

<%@page contentType="text/html" import="java.sql.*" pageEncoding="UTF-8"%>
 
<!DOCTYPE html>
<html data-bs-theme="dark">
  <head>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"
    />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.min.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>JSP Page</title>
  </head>
  <body>
    <div class="container">
      <h1 class="h1 text-center mt-2">JSP CRUD</h1>
        <form action="insert.jsp" method="post">
      <div class="row d-flex justify-content-center align-items-center">
        <div class="col-4">
          <label for="name" class="form-label">Name</label>
          <input
            type="text"
            name="name"
            id="name"
            class="form-control"
            placeholder="enter your name"
          />
          <input
            type="hidden"
            name="userid"
            id="userid"
            class="form-control"
          />
        </div>
        <div class="col-4">
          <label for="grade" class="form-label">Grade</label>
          <input
            type="text"
            name="grade"
            id="grade"
            class="form-control"
            placeholder="enter your grade"
          />
        </div>
      </div>

      <div class="d-flex justify-content-center align-items-center mt-3">
        <button type="submit" class="btn btn-success" name="submit" id="submitbtn">
          Insert
        </button>
      </div>
    </form>

      <table class="table mt-5 table-striped table-hover table-bordered table-responsive">
        <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col">Name</th>
            <th scope="col">Grade</th>
            <th scope="col" colspan="2">Actions</th>
          </tr>
        </thead>
        <tbody>
            <%
            Connection connection = null;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                connection = DriverManager.getConnection("jdbc:mysql://localhost:3307/students", "root", "");
                Statement statement = connection.createStatement();
                String select_query = "SELECT * FROM data";
                ResultSet resultSet = statement.executeQuery(select_query);
                int rowIndex = 1;
                while(resultSet.next()) {
                    int Id = resultSet.getInt("id");
                    String Name = resultSet.getString("name");
                    int Grade = resultSet.getInt("grade");

            %>
                <tr>
                    <th scope="row"><%= rowIndex %></th>
                    <td><%= Name %></td>
                    <td><%= Grade %></td>
                    <td colspan="2">
                      <button type="button" class="btn btn-primary" name="button" onclick="editRecord('<%= Id %>','<%= Name %>', '<%= Grade %>')">
                        Edit
                      </button>
                      <form action="insert.jsp" method="post" style="display: inline;">
                        <input type="hidden" name="deletedId" id="deletedId" value="<%= Id %>">
                        <button type="submit" class="btn btn-danger ms-2" name="button">
                          Delete
                        </button>
                    </form>
                    </td>
                </tr>
            <%
              rowIndex++;
                }
                resultSet.close();
                statement.close();
                connection.close();
            } catch (Exception e) {
                System.out.println(e);
            }

            %>
        </tbody>
      </table>
    </div>
    <div id="toastMsg" class="toast align-items-center text-bg-primary border-0 position-fixed mt-2 top-0 end-0" role="alert" aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body">
          Record inserted successfully!
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
    </div>
    
    <div id="toastError" class="toast align-items-center text-bg-danger border-0 position-fixed mt-2 top-0 end-0" role="alert" aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body">
          Something went wrong!
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
    </div>    
  </body>
  <script>
    function editRecord(id,name,grade) {
      document.getElementById("userid").value = id; 
      document.getElementById("name").value = name;   
      document.getElementById("grade").value = grade;
      
      document.getElementById("submitbtn").textContent = "Update";
    }
  </script>
  <script>
    window.onload = function() {
      const urlParams = new URLSearchParams(window.location.search);
      const action = urlParams.get('action');
      const status = urlParams.get('status');
  
      if (status === 'success') {
          var message = '';
          if (action === 'insert') message = 'Record inserted successfully!';
          else if (action === 'update') message = 'Record updated successfully!';
          else if (action === 'delete') message = 'Record deleted successfully!';
          
          document.querySelector('.toast-body').textContent = message;
          var toastElement = document.getElementById('toastMsg');
          var toast = new bootstrap.Toast(toastElement);
          toast.show();
      } else if (status === 'error') {
          document.querySelector('.toast-body').textContent = 'An error occurred during the operation.';
          var toastElement = document.getElementById('toastError');
          var toast = new bootstrap.Toast(toastElement);
          toast.show();
      }
  };
  
</script>

</html>
