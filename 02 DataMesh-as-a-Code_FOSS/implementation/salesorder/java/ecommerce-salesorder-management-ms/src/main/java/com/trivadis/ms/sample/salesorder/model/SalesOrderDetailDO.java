package com.trivadis.ms.sample.salesorder.model;

import lombok.*;

import javax.persistence.*;

@Data
@Builder
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "SalesOrderDetail")
public class SalesOrderDetailDO {

    @Id
//    @GeneratedValue(strategy = GenerationType.AUTO, generator="seq")
//    @GenericGenerator(name = "seq", strategy="increment")
    @Column(name = "id")
    private Long id;
    @Column(name = "quantity")
    private Integer quantity;
    @Column(name = "productId")
    private Long productId;
    @Column(name = "specialOfferId")
    private Long specialOfferId;
    @Column(name = "unitPrice")
    private Double unitPrice;
    @Column(name = "unitPriceDiscount")
    private Integer unitPriceDiscount;

//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name="sales_order_header_id", nullable = false)
//    private SalesOrderDO salesOrder;
}
