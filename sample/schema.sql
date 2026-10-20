-- Example schema for `dcloneb make`: a small online shop.
-- Run from this folder:  dcloneb make schema.sql
-- Output appears in ./generated (one CSV per table).

CREATE TABLE customers (
    id          SERIAL PRIMARY KEY,
    email       VARCHAR(100) NOT NULL UNIQUE,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    city        VARCHAR(50),
    signed_up   DATE NOT NULL
);

CREATE TABLE categories (
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE products (
    id           SERIAL PRIMARY KEY,
    sku          CHAR(8) NOT NULL UNIQUE,
    name         VARCHAR(80) NOT NULL,
    category_id  INT NOT NULL REFERENCES categories (id),
    price        NUMERIC(10, 2) NOT NULL,
    in_stock     BOOLEAN NOT NULL
);

CREATE TABLE employees (
    id          SERIAL PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    manager_id  INT REFERENCES employees (id)      -- self-reference: filled in after all rows exist
);

CREATE TABLE orders (
    id           SERIAL PRIMARY KEY,
    customer_id  INT NOT NULL REFERENCES customers (id),
    handled_by   INT REFERENCES employees (id),
    placed_at    TIMESTAMP NOT NULL,
    tracking_id  UUID UNIQUE
);

-- Junction table: each (order, product) pair at most once.
CREATE TABLE order_items (
    order_id    INT NOT NULL REFERENCES orders (id),
    product_id  INT NOT NULL REFERENCES products (id),
    quantity    SMALLINT NOT NULL,
    unit_price  NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY (order_id, product_id)
);
