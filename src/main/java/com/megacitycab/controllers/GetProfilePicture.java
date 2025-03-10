package com.megacitycab.controllers;

import com.megacitycab.utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/GetProfilePicture")
public class GetProfilePicture extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdParam = request.getParameter("userID");

        // ✅ Check if userID parameter is missing
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing userID parameter");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);

            String sql = "SELECT ProfilePicture FROM Users WHERE UserID = ?";
            
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();

                if (rs.next() && rs.getBinaryStream("ProfilePicture") != null) {
                    response.setContentType("image/png");
                    OutputStream out = response.getOutputStream();
                    rs.getBinaryStream("ProfilePicture").transferTo(out);
                    out.close();
                } else {
                    // ✅ If no image, return default profile picture
                    response.sendRedirect(request.getContextPath() + "/Images/default_driver.png");
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid userID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
