DROP SCHEMA IF EXISTS ecomm_product CASCADE;
CREATE SCHEMA ecomm_product;
	
DROP TABLE IF EXISTS "ecomm_product"."product";
DROP SEQUENCE IF EXISTS "ecomm_product".product_product_id_seq;
CREATE SEQUENCE "ecomm_product".product_product_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "ecomm_product"."product" (
	"product_id" integer DEFAULT nextval('"ecomm_product".product_product_id_seq'::regclass) NOT NULL,
	"name" character varying(50) NOT NULL,
	"product_number" character varying(25) NOT NULL,
	"make_flag" boolean DEFAULT true NOT NULL,
	"finished_goods_flag" boolean DEFAULT true NOT NULL,
	"color" character varying(15),
	"safety_stock_level" smallint NOT NULL,
	"reorder_point" smallint NOT NULL,
	"standard_cost" numeric NOT NULL,
	"list_price" numeric NOT NULL,
	"size" character varying(5),
	"size_unit_measure_code" character(3),
	"weight_unit_measure_code" character(3),
	"weight" numeric(8,2),
	"days_to_manufacture" integer NOT NULL,
	"product_line" character(2),
	"class" character(2),
	"style" character(2),
	"product_sub_category_id" integer,
	"product_model_id" integer,
	"sell_start_date" timestamp NOT NULL,
	"sell_end_date" timestamp,
	"discontinued_date" timestamp,
	"modified_date" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "PK_Product_product_id" PRIMARY KEY ("product_id")
);

COMMENT ON TABLE "ecomm_product"."product" IS 'Products sold or used in the manfacturing of sold products.';

COMMENT ON COLUMN "ecomm_product"."product"."product_id" IS 'Primary key for Product records.';

COMMENT ON COLUMN "ecomm_product"."product"."name" IS 'Name of the product.';

COMMENT ON COLUMN "ecomm_product"."product"."product_number" IS 'Unique product identification number.';

COMMENT ON COLUMN "ecomm_product"."product"."make_flag" IS '0 = Product is purchased, 1 = Product is manufactured in-house.';

COMMENT ON COLUMN "ecomm_product"."product"."finished_goods_flag" IS '0 = Product is not a salable item. 1 = Product is salable.';

COMMENT ON COLUMN "ecomm_product"."product"."color" IS 'Product color.';

COMMENT ON COLUMN "ecomm_product"."product"."safety_stock_level" IS 'Minimum inventory quantity.';

COMMENT ON COLUMN "ecomm_product"."product"."reorder_point" IS 'Inventory level that triggers a purchase order or work order.';

COMMENT ON COLUMN "ecomm_product"."product"."standard_cost" IS 'Standard cost of the product.';

COMMENT ON COLUMN "ecomm_product"."product"."list_price" IS 'Selling price.';

COMMENT ON COLUMN "ecomm_product"."product"."size" IS 'Product size.';

COMMENT ON COLUMN "ecomm_product"."product"."size_unit_measure_code" IS 'Unit of measure for Size column.';

COMMENT ON COLUMN "ecomm_product"."product"."weight_unit_measure_code" IS 'Unit of measure for Weight column.';

COMMENT ON COLUMN "ecomm_product"."product"."weight" IS 'Product weight.';

COMMENT ON COLUMN "ecomm_product"."product"."days_to_manufacture" IS 'Number of days required to manufacture the product.';

COMMENT ON COLUMN "ecomm_product"."product"."product_line" IS 'R = Road, M = Mountain, T = Touring, S = Standard';

COMMENT ON COLUMN "ecomm_product"."product"."class" IS 'H = High, M = Medium, L = Low';

COMMENT ON COLUMN "ecomm_product"."product"."style" IS 'W = Womens, M = Mens, U = Universal';

COMMENT ON COLUMN "ecomm_product"."product"."product_sub_category_id" IS 'Product is a member of this product subcategory. Foreign key to ProductSubCategory.ProductSubCategoryID.';

COMMENT ON COLUMN "ecomm_product"."product"."product_model_id" IS 'Product is a member of this product model. Foreign key to ProductModel.ProductModelID.';

COMMENT ON COLUMN "ecomm_product"."product"."sell_start_date" IS 'Date the product was available for sale.';

COMMENT ON COLUMN "ecomm_product"."product"."sell_end_date" IS 'Date the product was no longer available for sale.';

COMMENT ON COLUMN "ecomm_product"."product"."discontinued_date" IS 'Date the product was discontinued.';


DROP TABLE IF EXISTS "ecomm_product"."product_category";
DROP SEQUENCE IF EXISTS "ecomm_product".productcategory_productcategoryid_seq;
CREATE SEQUENCE "ecomm_product".productcategory_productcategoryid_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "ecomm_product"."product_category" (
	"product_category_id" integer DEFAULT nextval('"ecomm_product".productcategory_productcategoryid_seq'::regclass) NOT NULL,
	"name" character(100) NOT NULL,
	"modified_date" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "PK_ProductCategory_ProductCategoryID" PRIMARY KEY ("product_category_id")
);

COMMENT ON TABLE "ecomm_product"."product_category" IS 'High-level product categorization.';

COMMENT ON COLUMN "ecomm_product"."product_category"."product_category_id" IS 'Primary key for ProductCategory records.';

COMMENT ON COLUMN "ecomm_product"."product_category"."name" IS 'Category description.';


DROP TABLE IF EXISTS "ecomm_product"."product_cost_history";
CREATE TABLE "ecomm_product"."product_cost_history" (
	"product_id" integer NOT NULL,
	"start_date" timestamp NOT NULL,
	"end_date" timestamp,
	"standard_cost" numeric NOT NULL,
	"modified_date" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "PK_ProductCostHistory_product_id_StartDate" PRIMARY KEY ("product_id", "start_date")
);

COMMENT ON TABLE "ecomm_product"."product_cost_history" IS 'Changes in the cost of a product over time.';

COMMENT ON COLUMN "ecomm_product"."product_cost_history"."product_id" IS 'Product identification number. Foreign key to Product.product_id';

COMMENT ON COLUMN "ecomm_product"."product_cost_history"."start_date" IS 'Product cost start date.';

COMMENT ON COLUMN "ecomm_product"."product_cost_history"."end_date" IS 'Product cost end date.';

COMMENT ON COLUMN "ecomm_product"."product_cost_history"."standard_cost" IS 'Standard cost of the product.';


DROP TABLE IF EXISTS "ecomm_product"."product_description";
DROP SEQUENCE IF EXISTS "ecomm_product".productdescription_productdescriptionid_seq;
CREATE SEQUENCE "ecomm_product".productdescription_productdescriptionid_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "ecomm_product"."product_description" (
	"product_description_id" integer DEFAULT nextval('"ecomm_product".productdescription_productdescriptionid_seq'::regclass) NOT NULL,
	"description" character varying(400) NOT NULL,
	"modified_date" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "PK_ProductDescription_ProductDescriptionID" PRIMARY KEY ("product_description_id")
);

COMMENT ON TABLE "ecomm_product"."product_description" IS 'Product descriptions in several languages.';

COMMENT ON COLUMN "ecomm_product"."product_description"."product_description_id" IS 'Primary key for ProductDescription records.';

COMMENT ON COLUMN "ecomm_product"."product_description"."description" IS 'Description of the product.';


DROP TABLE IF EXISTS "ecomm_product"."product_document";
CREATE TABLE "ecomm_product"."product_document" (
	"product_id" integer NOT NULL,
	"modified_date" timestamp DEFAULT now() NOT NULL,
	"document_node" character varying DEFAULT '/' NOT NULL,
	CONSTRAINT "PK_ProductDocument_product_id_DocumentNode" PRIMARY KEY ("product_id", "document_node")
);

COMMENT ON TABLE "ecomm_product"."product_document" IS 'Cross-reference table mapping products to related product documents.';

COMMENT ON COLUMN "ecomm_product"."product_document"."product_id" IS 'Product identification number. Foreign key to Product.product_id.';

COMMENT ON COLUMN "ecomm_product"."product_document"."document_node" IS 'Document identification number. Foreign key to Document.DocumentNode.';

/*
DROP TABLE IF EXISTS "ecomm_product"."product_document";
CREATE TABLE "ecomm_product"."product_document" (
    "title" character varying(50) NOT NULL,
    "owner" integer NOT NULL,
    "folder_flag" boolean DEFAULT false NOT NULL,
    "file_name" character varying(400) NOT NULL,
    "file_extension" character varying(8),
    "revision" character(5) NOT NULL,
    "change_number" integer DEFAULT '0' NOT NULL,
    "status" smallint NOT NULL,
    "document_summary" character varying(4000),
    "modifieddate" timestamp DEFAULT now() NOT NULL,
    "documentnode" character varying DEFAULT '/' NOT NULL,
    "product_id" integer NOT NULL,
    CONSTRAINT "PK_Document_DocumentNode" PRIMARY KEY ("documentnode")
);

COMMENT ON TABLE "ecomm_product"."product_document" IS 'Product maintenance documents.';

COMMENT ON COLUMN "ecomm_product"."product_document"."title" IS 'Title of the document.';

COMMENT ON COLUMN "ecomm_product"."product_document"."owner" IS 'Employee who controls the document.  Foreign key to Employee.BusinessEntityID';

COMMENT ON COLUMN "ecomm_product"."product_document"."folder_flag" IS '0 = This is a folder, 1 = This is a document.';

COMMENT ON COLUMN "ecomm_product"."product_document"."file_name" IS 'File name of the document';

COMMENT ON COLUMN "ecomm_product"."product_document"."file_extension" IS 'File extension indicating the document type. For example, .doc or .txt.';

COMMENT ON COLUMN "ecomm_product"."product_document"."revision" IS 'Revision number of the document.';

COMMENT ON COLUMN "ecomm_product"."product_document"."change_number" IS 'Engineering change approval number.';

COMMENT ON COLUMN "ecomm_product"."product_document"."status" IS '1 = Pending approval, 2 = Approved, 3 = Obsolete';

COMMENT ON COLUMN "ecomm_product"."product_document"."document_summary" IS 'Document abstract.';

COMMENT ON COLUMN "ecomm_product"."product_document"."document" IS 'Complete document.';

COMMENT ON COLUMN "ecomm_product"."product_document"."documentnode" IS 'Primary key for Document records.';
*/

DROP TABLE IF EXISTS "ecomm_product"."product_model";
DROP SEQUENCE IF EXISTS "ecomm_product".productmodel_productmodelid_seq;
CREATE SEQUENCE "ecomm_product".productmodel_productmodelid_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "ecomm_product"."product_model" (
	"product_model_id" integer DEFAULT nextval('"ecomm_product".productmodel_productmodelid_seq'::regclass) NOT NULL,
	"name" character varying(50) NOT NULL,
	"catalog_description" xml,
	"instructions" xml,
	"modified_date" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "PK_ProductModel_ProductModelID" PRIMARY KEY ("product_model_id")
);

COMMENT ON TABLE "ecomm_product"."product_model" IS 'Product model classification.';

COMMENT ON COLUMN "ecomm_product"."product_model"."product_model_id" IS 'Primary key for ProductModel records.';

COMMENT ON COLUMN "ecomm_product"."product_model"."name" IS 'Product model description.';

COMMENT ON COLUMN "ecomm_product"."product_model"."catalog_description" IS 'Detailed product catalog information in xml format.';

COMMENT ON COLUMN "ecomm_product"."product_model"."instructions" IS 'Manufacturing instructions in xml format.';


DROP TABLE IF EXISTS "ecomm_product"."product_model_illustration";
CREATE TABLE "ecomm_product"."product_model_illustration" (
	"product_model_id" integer NOT NULL,
	"illustration_id" integer NOT NULL,
	"modified_date" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "PK_ProductModelIllustration_ProductModelID_IllustrationID" PRIMARY KEY ("product_model_id", "illustration_id")
);

COMMENT ON TABLE "ecomm_product"."product_model_illustration" IS 'Cross-reference table mapping product models and illustrations.';

COMMENT ON COLUMN "ecomm_product"."product_model_illustration"."product_model_id" IS 'Primary key. Foreign key to ProductModel.ProductModelID.';

COMMENT ON COLUMN "ecomm_product"."product_model_illustration"."illustration_id" IS 'Primary key. Foreign key to Illustration.IllustrationID.';


DROP TABLE IF EXISTS "ecomm_product"."product_model_product_description_culture";
CREATE TABLE "ecomm_product"."product_model_product_description_culture" (
	"product_model_id" integer NOT NULL,
	"product_description_id" integer NOT NULL,
	"culture_id" character(6) NOT NULL,
	"modified_date" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "PK_ProductModelProductDescriptionCulture_ProductModelID_Product" PRIMARY KEY ("product_model_id", "product_description_id", "culture_id")
);

COMMENT ON TABLE "ecomm_product"."product_model_product_description_culture" IS 'Cross-reference table mapping product descriptions and the language the description is written in.';

COMMENT ON COLUMN "ecomm_product"."product_model_product_description_culture"."product_model_id" IS 'Primary key. Foreign key to ProductModel.ProductModelID.';

COMMENT ON COLUMN "ecomm_product"."product_model_product_description_culture"."product_description_id" IS 'Primary key. Foreign key to ProductDescription.ProductDescriptionID.';

COMMENT ON COLUMN "ecomm_product"."product_model_product_description_culture"."culture_id" IS 'Culture identification number. Foreign key to Culture.CultureID.';


DROP TABLE IF EXISTS "ecomm_product"."product_photo";
DROP SEQUENCE IF EXISTS "ecomm_product".productphoto_productphotoid_seq;
CREATE SEQUENCE "ecomm_product".productphoto_productphotoid_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "ecomm_product"."product_photo" (
	"product_photo_id" integer DEFAULT nextval('"ecomm_product".productphoto_productphotoid_seq'::regclass) NOT NULL,
	"product_id" integer NOT NULL,
	"is_primary" boolean DEFAULT false NOT NULL,	
	"thumbnail_photo" bytea,
	"thumbnail_photo_filename" character varying(50),
	"large_photo" bytea,
	"large_photo_filename" character varying(50),
	"modified_date" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "PK_ProductPhoto_ProductPhotoID" PRIMARY KEY ("product_photo_id")
);

COMMENT ON TABLE "ecomm_product"."product_photo" IS 'Product images.';

COMMENT ON COLUMN "ecomm_product"."product_photo"."product_photo_id" IS 'Primary key for ProductPhoto records.';

COMMENT ON COLUMN "ecomm_product"."product_photo"."thumbnail_photo" IS 'Small image of the product.';

COMMENT ON COLUMN "ecomm_product"."product_photo"."thumbnail_photo_filename" IS 'Small image file name.';

COMMENT ON COLUMN "ecomm_product"."product_photo"."large_photo" IS 'Large image of the product.';

COMMENT ON COLUMN "ecomm_product"."product_photo"."large_photo_filename" IS 'Large image file name.';

/*
DROP TABLE IF EXISTS "ecomm_product"."product_product_photo";
CREATE TABLE "ecomm_product"."product_product_photo" (
	"product_id" integer NOT NULL,
	"product_photo_id" integer NOT NULL,
	"primary" boolean DEFAULT false NOT NULL,
	"modified_date" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "PK_ProductProductPhoto_product_id_ProductPhotoID" PRIMARY KEY ("product_id", "product_photo_id")
);

COMMENT ON TABLE "ecomm_product"."product_product_photo" IS 'Cross-reference table mapping products and product photos.';

COMMENT ON COLUMN "ecomm_product"."product_product_photo"."product_id" IS 'Product identification number. Foreign key to Product.product_id.';

COMMENT ON COLUMN "ecomm_product"."product_product_photo"."product_photo_id" IS 'Product photo identification number. Foreign key to ProductPhoto.ProductPhotoID.';

COMMENT ON COLUMN "ecomm_product"."product_product_photo"."primary" IS '0 = Photo is not the principal image. 1 = Photo is the principal image.';
*/

DROP TABLE IF EXISTS "ecomm_product"."product_review";
DROP SEQUENCE IF EXISTS "ecomm_product".productreview_productreviewid_seq;
CREATE SEQUENCE "ecomm_product".productreview_productreviewid_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "ecomm_product"."product_review" (
	"product_review_id" integer DEFAULT nextval('"ecomm_product".productreview_productreviewid_seq'::regclass) NOT NULL,
	"product_id" integer NOT NULL,
	"reviewer_name" character varying(50) NOT NULL,
	"review_date" timestamp DEFAULT now() NOT NULL,
	"emailaddress" character varying(50) NOT NULL,
	"rating" integer NOT NULL,
	"comments" character varying(3850),
	"modified_date" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "PK_ProductReview_ProductReviewID" PRIMARY KEY ("product_review_id")
);

COMMENT ON TABLE "ecomm_product"."product_review" IS 'Customer reviews of products they have purchased.';

COMMENT ON COLUMN "ecomm_product"."product_review"."product_review_id" IS 'Primary key for ProductReview records.';

COMMENT ON COLUMN "ecomm_product"."product_review"."product_id" IS 'Product identification number. Foreign key to Product.product_id.';

COMMENT ON COLUMN "ecomm_product"."product_review"."reviewer_name" IS 'Name of the reviewer.';

COMMENT ON COLUMN "ecomm_product"."product_review"."review_date" IS 'Date review was submitted.';

COMMENT ON COLUMN "ecomm_product"."product_review"."emailaddress" IS 'Reviewer''s e-mail address.';

COMMENT ON COLUMN "ecomm_product"."product_review"."rating" IS 'Product rating given by the reviewer. Scale is 1 to 5 with 5 as the highest rating.';

COMMENT ON COLUMN "ecomm_product"."product_review"."comments" IS 'Reviewer''s comments';


DROP TABLE IF EXISTS "ecomm_product"."product_sub_category";
DROP SEQUENCE IF EXISTS "ecomm_product".productsubcategory_productsubcategoryid_seq;
CREATE SEQUENCE "ecomm_product".productsubcategory_productsubcategoryid_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "ecomm_product"."product_sub_category" (
	"product_sub_category_id" integer DEFAULT nextval('"ecomm_product".productsubcategory_productsubcategoryid_seq'::regclass) NOT NULL,
	"product_category_id" integer NOT NULL,
	"name" character varying(50) NOT NULL,
	"modified_date" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "PK_ProductSubcategory_ProductSubcategoryID" PRIMARY KEY ("product_sub_category_id")
);

COMMENT ON TABLE "ecomm_product"."product_sub_category" IS 'Product subcategories. See ProductCategory table.';

COMMENT ON COLUMN "ecomm_product"."product_sub_category"."product_sub_category_id" IS 'Primary key for ProductSubcategory records.';

COMMENT ON COLUMN "ecomm_product"."product_sub_category"."product_category_id" IS 'Product category identification number. Foreign key to ProductCategory.ProductCategoryID.';

COMMENT ON COLUMN "ecomm_product"."product_sub_category"."name" IS 'Subcategory description.';

DROP TABLE IF EXISTS "ecomm_product"."unit_measure";
CREATE TABLE "ecomm_product"."unit_measure" (
    "unit_measure_code" character(3) NOT NULL,
    "name" character varying(50) NOT NULL,
    "modified_date" timestamp DEFAULT now() NOT NULL,
    CONSTRAINT "PK_UnitMeasure_UnitMeasureCode" PRIMARY KEY ("unit_measure_code")
);

COMMENT ON TABLE "ecomm_product"."unit_measure" IS 'Unit of measure lookup table.';

COMMENT ON COLUMN "ecomm_product"."unit_measure"."unit_measure_code" IS 'Primary key.';

COMMENT ON COLUMN "ecomm_product"."unit_measure"."name" IS 'Unit of measure description.';



DROP TABLE IF EXISTS "ecomm_product"."bill_of_materials";
DROP SEQUENCE IF EXISTS "ecomm_product".billofmaterials_billofmaterialsid_seq;
CREATE SEQUENCE "ecomm_product".billofmaterials_billofmaterialsid_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "ecomm_product"."bill_of_materials" (
    "bill_of_materials_id" integer DEFAULT nextval('"ecomm_product".billofmaterials_billofmaterialsid_seq'::regclass) NOT NULL,
    "product_assembly_id" integer,
    "component_id" integer NOT NULL,
    "start_date" timestamp DEFAULT now() NOT NULL,
    "end_date" timestamp,
    "unit_measure_code" character(3) NOT NULL,
    "bom_level" smallint NOT NULL,
    "per_assembly_qty" numeric(8,2) DEFAULT '1.00' NOT NULL,
    "modified_date" timestamp DEFAULT now() NOT NULL,
    CONSTRAINT "PK_BillOfMaterials_BillOfMaterialsID" PRIMARY KEY ("bill_of_materials_id")
) WITH (oids = false);

COMMENT ON TABLE "ecomm_product"."bill_of_materials" IS 'Items required to make bicycles and bicycle subassemblies. It identifies the heirarchical relationship between a parent product and its components.';

COMMENT ON COLUMN "ecomm_product"."bill_of_materials"."bill_of_materials_id" IS 'Primary key for BillOfMaterials records.';

COMMENT ON COLUMN "ecomm_product"."bill_of_materials"."product_assembly_id" IS 'Parent product identification number. Foreign key to Product.ProductID.';

COMMENT ON COLUMN "ecomm_product"."bill_of_materials"."component_id" IS 'Component identification number. Foreign key to Product.ProductID.';

COMMENT ON COLUMN "ecomm_product"."bill_of_materials"."start_date" IS 'Date the component started being used in the assembly item.';

COMMENT ON COLUMN "ecomm_product"."bill_of_materials"."end_date" IS 'Date the component stopped being used in the assembly item.';

COMMENT ON COLUMN "ecomm_product"."bill_of_materials"."unit_measure_code" IS 'Standard code identifying the unit of measure for the quantity.';

COMMENT ON COLUMN "ecomm_product"."bill_of_materials"."bom_level" IS 'Indicates the depth the component is from its parent (AssemblyID).';

COMMENT ON COLUMN "ecomm_product"."bill_of_materials"."per_assembly_qty" IS 'Quantity of the component needed to create the assembly.';


ALTER TABLE ONLY "ecomm_product"."product" ADD CONSTRAINT "FK_Product_ProductModel_ProductModelID" FOREIGN KEY (product_model_id) REFERENCES "ecomm_product".product_model(product_model_id) NOT DEFERRABLE;
ALTER TABLE ONLY "ecomm_product"."product" ADD CONSTRAINT "FK_Product_ProductSubcategory_ProductSubcategoryID" FOREIGN KEY (product_sub_category_id) REFERENCES "ecomm_product".product_sub_category(product_sub_category_id) NOT DEFERRABLE;
ALTER TABLE ONLY "ecomm_product"."product" ADD CONSTRAINT "FK_Product_UnitMeasure_SizeUnitMeasureCode" FOREIGN KEY (size_unit_measure_code) REFERENCES "ecomm_product".unit_measure(unit_measure_code) NOT DEFERRABLE;
ALTER TABLE ONLY "ecomm_product"."product" ADD CONSTRAINT "FK_Product_UnitMeasure_WeightUnitMeasureCode" FOREIGN KEY (weight_unit_measure_code) REFERENCES "ecomm_product".unit_measure(unit_measure_code) NOT DEFERRABLE;

ALTER TABLE ONLY "ecomm_product"."product_cost_history" ADD CONSTRAINT "FK_ProductCostHistory_Product_product_id" FOREIGN KEY (product_id) REFERENCES "ecomm_product".product(product_id) NOT DEFERRABLE;

ALTER TABLE ONLY "ecomm_product"."product_document" ADD CONSTRAINT "FK_ProductDocument_Product_product_id" FOREIGN KEY (product_id) REFERENCES "ecomm_product".product(product_id) NOT DEFERRABLE;

/*
ALTER TABLE ONLY "ecomm_product"."product_document" ADD CONSTRAINT "FK_ProductDocument_Document_DocumentNode" FOREIGN KEY (document_node) REFERENCES "ecomm_product".document(document_node) NOT DEFERRABLE;
ALTER TABLE ONLY "ecomm_product"."product_document" ADD CONSTRAINT "FK_ProductDocument_Product_product_id" FOREIGN KEY (product_id) REFERENCES "ecomm_product".product(product_id) NOT DEFERRABLE;

ALTER TABLE ONLY "ecomm_product"."product_model_illustration" ADD CONSTRAINT "FK_ProductModelIllustration_Illustration_IllustrationID" FOREIGN KEY (illustration_id) REFERENCES "ecomm_product".illustration(illustration_id) NOT DEFERRABLE;
*/
ALTER TABLE ONLY "ecomm_product"."product_model_illustration" ADD CONSTRAINT "FK_ProductModelIllustration_ProductModel_ProductModelID" FOREIGN KEY (product_model_id) REFERENCES "ecomm_product".product_model(product_model_id) NOT DEFERRABLE;

/*
ALTER TABLE ONLY "ecomm_product"."product_model_product_description_culture" ADD CONSTRAINT "FK_ProductModelProductDescriptionCulture_Culture_CultureID" FOREIGN KEY (culture_id) REFERENCES "ecomm_product".culture(culture_id) NOT DEFERRABLE;
*/
ALTER TABLE ONLY "ecomm_product"."product_model_product_description_culture" ADD CONSTRAINT "FK_ProductModelProductDescriptionCulture_ProductDescription_Pro" FOREIGN KEY (product_description_id) REFERENCES "ecomm_product".product_description(product_description_id) NOT DEFERRABLE;
ALTER TABLE ONLY "ecomm_product"."product_model_product_description_culture" ADD CONSTRAINT "FK_ProductModelProductDescriptionCulture_ProductModel_ProductMo" FOREIGN KEY (product_model_id) REFERENCES "ecomm_product".product_model(product_model_id) NOT DEFERRABLE;


ALTER TABLE ONLY "ecomm_product"."product_photo" ADD CONSTRAINT "FK_ProductPhoto_Product_ProductID" FOREIGN KEY (product_id) REFERENCES "ecomm_product".product(product_id) NOT DEFERRABLE;

/*
ALTER TABLE ONLY "ecomm_product"."product_product_photo" ADD CONSTRAINT "FK_ProductProductPhoto_ProductPhoto_ProductPhotoID" FOREIGN KEY (product_photo_id) REFERENCES "ecomm_product".product_photo(product_photo_id) NOT DEFERRABLE;
ALTER TABLE ONLY "ecomm_product"."product_product_photo" ADD CONSTRAINT "FK_ProductProductPhoto_Product_product_id" FOREIGN KEY (product_id) REFERENCES "ecomm_product".product(product_id) NOT DEFERRABLE;
*/

ALTER TABLE ONLY "ecomm_product"."product_review" ADD CONSTRAINT "FK_ProductReview_Product_product_id" FOREIGN KEY (product_id) REFERENCES "ecomm_product".product(product_id) NOT DEFERRABLE;

ALTER TABLE ONLY "ecomm_product"."product_sub_category" ADD CONSTRAINT "FK_ProductSubcategory_ProductCategory_ProductCategoryID" FOREIGN KEY (product_category_id) REFERENCES "ecomm_product".product_category(product_category_id) NOT DEFERRABLE;

ALTER TABLE ONLY "ecomm_product"."bill_of_materials" ADD CONSTRAINT "FK_BillOfMaterials_Product_ComponentID" FOREIGN KEY (component_id) REFERENCES "ecomm_product".product(product_id) NOT DEFERRABLE;
ALTER TABLE ONLY "ecomm_product"."bill_of_materials" ADD CONSTRAINT "FK_BillOfMaterials_Product_ProductAssemblyID" FOREIGN KEY (product_assembly_id) REFERENCES "ecomm_product".product(product_id) NOT DEFERRABLE;
ALTER TABLE ONLY "ecomm_product"."bill_of_materials" ADD CONSTRAINT "FK_BillOfMaterials_UnitMeasure_UnitMeasureCode" FOREIGN KEY (unit_measure_code) REFERENCES "ecomm_product".unit_measure(unit_measure_code) NOT DEFERRABLE;


