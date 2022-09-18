Table "person_t" {
  "business_entity_id" INTEGER [pk]
  "person_type" VARCHAR2(100)
  "name_style" VARCHAR2(1)
  "first_name" VARCHAR2(100)
  "middle_name" VARCHAR2(100)
  "last_name" VARCHAR2(100)
  "email_promotion" NUMBER(10)
  "demographics" VARCHAR2(2000)
  "created_date" timestamp
  "modified_date" timestamp
}

Table "address_t" {
  "address_id" INTEGER [pk]
  "address_line_1" VARCHAR2(200)
  "address_line_2" VARCHAR2(200)
  "city" VARCHAR2(200)
  "state_province_id" INTEGER
  "postal_code" VARCHAR2(50)
  "created_date" timestamp
  "modified_date" timestamp
}

Table "person_address_t" {
  "business_entity_id" INTEGER
  "address_id" INTEGER
  "address_type_id" INTEGER
  "created_date" timestamp
  "modified_date" timestamp

Indexes {
  (business_entity_id, address_id, address_type_id) [pk]
}
}

Table "email_address_t" {
  "business_entity_id" INTEGER
  "email_address_id" INTEGER
  "email_address" VARCHAR2(200)
  "created_date" timestamp
  "modified_date" timestamp

Indexes {
  (business_entity_id, email_address_id) [pk]
}
}

Table "person_phone_t" {
  "business_entity_id" INTEGER
  "phone_number" VARCHAR2(50)
  "phone_number_type_id" INTEGER
  "created_date" timestamp
  "modified_date" timestamp

Indexes {
  (business_entity_id, phone_number, phone_number_type_id) [pk]
}
}

Table "password_t" {
  "business_entity_id" INTEGER [pk]
  "password_hash" VARCHAR2(100)
  "password_salt" VARCHAR2(100)
  "created_date" timestamp
  "modified_date" timestamp
}

Table "state_province_t" {
  "state_province_id" INTEGER [pk]
  "state_province_code" VARCHAR2(3)
  "country_region_code" VARCHAR2(2)
  "is_only_state_province_flag" VARCHAR2(1)
  "name" VARCHAR2(50)
  "territory_id" INTEGER
  "created_date" timestamp
  "modified_date" timestamp
}

Table "country_region_t" {
  "country_region_code" VARCHAR2(2) [pk]
  "name" VARCHAR2(50)
  "created_date" timestamp
  "modified_date" timestamp
}

Table "phone_number_type_t" {
  "phone_number_type_id" INTEGER [pk]
  "name" VARCHAR2(20)
  "created_date" timestamp
  "modified_date" timestamp
}

Table "address_type_t" {
  "address_type_id" INTEGER [pk]
  "name" VARCHAR2(20)
  "created_date" timestamp
  "modified_date" timestamp
}
