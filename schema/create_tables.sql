--Creating a Product description table
CREATE TABLE Product
(
  product_id            VARCHAR(50)   NOT NULL,
  product_category_name VARCHAR(255)  NULL,
  product_weight        INT           NULL,
  product_height        INT           NULL,
  product_width         INT           NULL,
  product_length        INT           NULL,
  PRIMARY KEY (product_id)
);
--Creating a Seller Info table
CREATE TABLE Seller
(
  seller_id              VARCHAR(50)   NOT NULL,
  seller_zip_code_prefix VARCHAR(10)   NOT NULL,
  seller_city            VARCHAR(50)   NOT NULL,
  seller_state           CHAR(2)       NOT NULL,
  PRIMARY KEY (seller_id)
);
--Creating a Customer table that stores demographic info
CREATE TABLE Customer
(
  customer_id          VARCHAR(255)  NOT NULL,
  customer_unique_id   VARCHAR(255)  NOT NULL,
  customer_zip_code_id VARCHAR(10)   NOT NULL,
  customer_city        VARCHAR(200)  NOT NULL,
  customer_state       CHAR(2)       NOT NULL,
  PRIMARY KEY (customer_id)
);
--Creating a Orders Status table
CREATE TABLE Orders
(
  order_id                  VARCHAR(200) NOT NULL,
  order_status              VARCHAR(25)  NOT NULL,
  order_delivered_cust_date DATE         NULL,
  order_purchase_timestamp  DATE         NOT NULL,
  order_delivered_carrier_date DATE      NULL,
  order_est_delivery_date   DATE         NOT NULL,
  customer_id               VARCHAR(255) NOT NULL,
  PRIMARY KEY (order_id),
  FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
--Creating a Service Ticket table
CREATE TABLE cust_service_ticket
(
  ticket_id              INT           NOT NULL IDENTITY(1,1),
  issue_type             VARCHAR(50)   NOT NULL,
  issue_description      VARCHAR(MAX)  NOT NULL,
  reported_date          DATE          NOT NULL,
  channel                VARCHAR(25)   NOT NULL,
  severity               VARCHAR(20)   NOT NULL,
  status                 VARCHAR(50)   NOT NULL,
  resolution_description VARCHAR(MAX)  NULL,
  resolution_date        DATE          NULL,
  comp_amt               DECIMAL(10,2) NULL,
  agent_name             VARCHAR(100)  NOT NULL,
  order_id               VARCHAR(200)  NOT NULL,
  customer_id            VARCHAR(255)  NOT NULL,
  PRIMARY KEY (ticket_id),
  FOREIGN KEY (order_id)   REFERENCES Orders(order_id),
  FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
--Creating a Ordered Item line table
CREATE TABLE OrderItem
(
  order_item_id INT           NOT NULL,
  price         DECIMAL(10,2) NOT NULL,
  freight_value DECIMAL(10,2) NOT NULL,
  product_id    VARCHAR(50)   NOT NULL,
  seller_id     VARCHAR(50)   NOT NULL,
  order_id      VARCHAR(200)  NOT NULL,
  PRIMARY KEY (order_item_id),
  FOREIGN KEY (product_id) REFERENCES Product(product_id),
  FOREIGN KEY (seller_id)  REFERENCES Seller(seller_id),
  FOREIGN KEY (order_id)   REFERENCES Orders(order_id)
);
--Creating a Reviews description table
CREATE TABLE OrderReview
(
  review_id               VARCHAR(255) NOT NULL,
  review_comment_title    VARCHAR(255) NULL,
  review_score            INT          NOT NULL,
  review_comment_message  VARCHAR(MAX) NULL,
  review_creation_date    DATE         NOT NULL,
  review_answer_timestamp DATE         NULL,
  order_id                VARCHAR(200) NOT NULL,
  PRIMARY KEY (review_id),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
