package com.trivadis.ms.sample.salesorder.model;

public enum OrderStatusEnum {
    IN_PROCESS(1), APPROVED(2), BACKORDERED(3), REJECTED(4), SHIPPED(5), CANCELLED(6);
    private int id;

    OrderStatusEnum(int id){
        this.id = id;
    }

    public int getID() {
        return id;
    }
}
