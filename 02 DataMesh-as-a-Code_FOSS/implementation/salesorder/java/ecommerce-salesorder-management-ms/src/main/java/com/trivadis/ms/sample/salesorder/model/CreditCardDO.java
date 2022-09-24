package com.trivadis.ms.sample.salesorder.model;

import lombok.*;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Data
@Builder
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "CreditCard")
public class CreditCardDO {

    @Id
//    @GeneratedValue(strategy = GenerationType.AUTO, generator="seq")
//    @GenericGenerator(name = "seq", strategy="increment")
    @Column(name = "salesOrderId")
    private Long id;
    @Column(name = "cardType")
    private String cardType;
    @Column(name = "cardNumber")
    private String cardNumber;
    @Column(name = "expMonth")
    private Integer expMonth;
    @Column(name = "expYear")
    private Integer expYear;
    @Column(name = "creditCardApprovalCode")
    private String creditCardApprovalCode;
}
