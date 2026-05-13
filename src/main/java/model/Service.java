package model;

public class Service {
    private int serviceId;
    private String serviceName;
    private int categoryId;
    private String unit;
    private double price;
    private boolean status;

    public Service() {}

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
}