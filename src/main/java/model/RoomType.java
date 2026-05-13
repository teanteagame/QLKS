package model;

public class RoomType {
    private int roomTypeId;
    private String typeName;
    private double hourlyPrice;
    private double overnightPrice;
    private double dailyPrice;

    public RoomType() {}

    // Getters và Setters
    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }
    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }
    public double getHourlyPrice() { return hourlyPrice; }
    public void setHourlyPrice(double hourlyPrice) { this.hourlyPrice = hourlyPrice; }
    public double getOvernightPrice() { return overnightPrice; }
    public void setOvernightPrice(double overnightPrice) { this.overnightPrice = overnightPrice; }
    public double getDailyPrice() { return dailyPrice; }
    public void setDailyPrice(double dailyPrice) { this.dailyPrice = dailyPrice; }
}