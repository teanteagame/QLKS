package model;

import java.sql.Timestamp;

public class BookingDetail {

    private int bookingId;
    private int roomId;
    private String customerName;
    private String roomNumber;
    private String roomType;
    private Timestamp checkIn;
    private Timestamp paymentDate; // Mới thêm
    private double roomPrice;
    private int rentalTypeId;

    public BookingDetail() {
    }

    // Các Getter và Setter cũ giữ nguyên
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }
    public Timestamp getCheckIn() { return checkIn; }
    public void setCheckIn(Timestamp checkIn) { this.checkIn = checkIn; }
    public double getRoomPrice() { return roomPrice; }
    public void setRoomPrice(double roomPrice) { this.roomPrice = roomPrice; }
    public int getRentalTypeId() { return rentalTypeId; }
    public void setRentalTypeId(int rentalTypeId) { this.rentalTypeId = rentalTypeId; }

    // Getter và Setter mới cho paymentDate
    public Timestamp getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Timestamp paymentDate) { this.paymentDate = paymentDate; }
}