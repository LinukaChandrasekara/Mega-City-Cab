package com.megacitycab.servlets;
import java.sql.Connection;

import com.megacitycab.utils.DBUtil;

public class TestDB {
    public static void main(String[] args) {
        try {
            Connection conn = DBUtil.getConnection();
            if (conn != null) {
                System.out.println("✅ Connected to the database successfully!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ Database connection failed!");
        }
    }
}
