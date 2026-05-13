package dao;

import config.DatabaseConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import model.Invoice;

public class InvoiceDAO {

    public boolean createInvoice(Invoice invoice) {

        String sql =
                "INSERT INTO invoices("
                + "booking_id, "
                + "room_total, "
                + "service_total, "
                + "total_amount, "
                + "payment_method, "
                + "payment_status"
                + ") "
                + "VALUES(?, ?, ?, ?, ?, ?)";

        try {

            Connection conn =
                    DatabaseConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, invoice.getBookingId());

            ps.setDouble(2, invoice.getRoomTotal());

            ps.setDouble(3, invoice.getServiceTotal());

            ps.setDouble(4, invoice.getTotalAmount());

            ps.setString(5, invoice.getPaymentMethod());

            ps.setString(6, invoice.getPaymentStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

    public boolean checkoutBooking(
            int bookingId
    ) {

        String sql =
                "UPDATE bookings "
                + "SET booking_status = 'CHECKED_OUT', "
                + "check_out = NOW() "
                + "WHERE booking_id = ?";

        try {

            Connection conn =
                    DatabaseConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, bookingId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

    public boolean updateRoomAvailable(
            int roomId
    ) {

        String sql =
                "UPDATE rooms "
                + "SET status = 'AVAILABLE' "
                + "WHERE room_id = ?";

        try {

            Connection conn =
                    DatabaseConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, roomId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }
}