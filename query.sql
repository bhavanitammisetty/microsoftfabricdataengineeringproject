CREATE PROCEDURE InsertTransactionTable
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Check if all required tables exist
        IF OBJECT_ID('customerTable') IS NOT NULL
           AND OBJECT_ID('ProductTable') IS NOT NULL
           AND OBJECT_ID('StoreTable') IS NOT NULL
        BEGIN
            -- Create transactionstable if not exists
            IF OBJECT_ID('transactionTable') IS NULL
            BEGIN
                CREATE TABLE transactionTable (
                    transaction_id INT PRIMARY KEY,
                    customer_id INT,
                    product_id INT,
                    store_id INT,
                    quantity INT,
                    transaction_date DATE,
                    FOREIGN KEY (customer_id) REFERENCES customerTable(customer_id),
                    FOREIGN KEY (product_id) REFERENCES ProductTable(product_id),
                    FOREIGN KEY (store_id) REFERENCES StoreTable(store_id)
                );
            END

            -- Insert only valid records where all FK keys exist
            INSERT INTO transactionTable (transaction_id, customer_id, product_id, store_id, quantity, transaction_date)
            SELECT *
            FROM (
                VALUES 
                    (1, 127, 8, 4, 4, '2025-03-31'),
                    (2, 105, 3, 4, 5, '2024-11-12'),
                    (3, 116, 2, 2, 3, '2025-05-01'),
                    (4, 120, 8, 1, 1, '2024-11-02'),
                    (5, 105, 5, 2, 1, '2025-03-17'),
                    (6, 110, 7, 3, 5, '2025-01-04'),
                    (7, 110, 7, 2, 5, '2025-01-01'),
                    (8, 126, 7, 5, 2, '2025-06-08'),
                    (9, 123, 1, 3, 2, '2024-10-08'),
                    (10, 124, 2, 2, 5, '2024-08-27'),
                    (11, 102, 1, 3, 2, '2024-08-11'),
                    (12, 108, 5, 1, 4, '2025-05-26'),
                    (13, 104, 3, 3, 4, '2025-05-04'),
                    (14, 120, 1, 4, 5, '2024-07-17'),
                    (15, 121, 6, 5, 5, '2025-05-19'),
                    (16, 118, 6, 2, 4, '2024-11-29'),
                    (17, 109, 8, 5, 5, '2024-07-10'),
                    (18, 103, 1, 4, 3, '2024-09-05'),
                    (19, 116, 8, 4, 4, '2024-07-14'),
                    (20, 130, 5, 1, 2, '2024-07-30'),
                    (21, 105, 1, 3, 5, '2024-10-02'),
                    (22, 107, 9, 3, 4, '2024-11-16'),
                    (23, 122, 9, 4, 2, '2025-04-30'),
                    (24, 125, 1, 5, 1, '2024-07-14'),
                    (25, 116, 8, 4, 5, '2024-12-13'),
                    (26, 126, 6, 2, 2, '2024-09-21'),
                    (27, 127, 8, 1, 1, '2024-10-10'),
                    (28, 101, 7, 5, 3, '2024-11-15'),
                    (29, 119, 9, 4, 2, '2025-06-03'),
                    (30, 116, 8, 4, 5, '2025-03-16')
            ) AS t(transaction_id, customer_id, product_id, store_id, quantity, transaction_date)
            WHERE
                EXISTS (SELECT 1 FROM customerTable c WHERE c.customer_id = t.customer_id)
                AND EXISTS (SELECT 1 FROM ProductTable p WHERE p.product_id = t.product_id)
                AND EXISTS (SELECT 1 FROM StoreTable s WHERE s.store_id = t.store_id);
        END
        ELSE
        BEGIN
            PRINT 'One or more required tables do not exist.';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
    END CATCH
END