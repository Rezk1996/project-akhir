package com.boniewijaya2021.springboot.pojo;

public class OrderPojo {
    private String shippingAddress;
    private String phoneNumber;
    private String notes;
    private String paymentMethod;
    private Double shippingCost;

    public OrderPojo() {}

    public OrderPojo(String shippingAddress, String phoneNumber, String notes, String paymentMethod, Double shippingCost) {
        this.shippingAddress = shippingAddress;
        this.phoneNumber = phoneNumber;
        this.notes = notes;
        this.paymentMethod = paymentMethod;
        this.shippingCost = shippingCost;
    }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public Double getShippingCost() { return shippingCost; }
    public void setShippingCost(Double shippingCost) { this.shippingCost = shippingCost; }
}