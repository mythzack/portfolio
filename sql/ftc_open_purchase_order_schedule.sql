-- Model: fct_open_purchase_order_schedule
-- Grain: purchase_order_id + po_item_id + scheduled_delivery_date
--
-- Purpose:
--   Exposes open purchase order schedule lines for inbound planning
--   and procurement visibility.
--
-- Notes:
--   Includes only active purchase orders and excludes fully delivered
--   schedule lines. Open quantities are derived from scheduled minus
--   delivered quantities. Intended for current-state reporting and
--   downstream snapshotting.

WITH
    base_purchase_orders AS (
        SELECT
            CAST(s.purchase_order_number AS BIGINT)             AS purchase_order,
            CAST(s.po_item_number AS INT)                       AS po_item,
            i.material_id,
            i.plant_id                                          AS plant,
            i.storage_location_id                               AS storage_location,
            CAST(s.delivery_date AS DATE)                       AS scheduled_delivery_date,
            CAST(s.scheduled_qty AS INT)                        AS scheduled_qty,
            CAST(s.delivered_qty AS INT)                        AS delivered_qty,
            CAST(s.posted_qty AS INT)                           AS posted_qty
        
        FROM
            stgpo_schedule s
        
        JOIN
            stgpo_item i
            ON i.purchase_order_number = s.purchase_order_number
            AND i.po_item_number = s.po_item_number

        JOIN
            stgpo_header h
            ON h.purchase_order_number = s.purchase_order_number
        
        WHERE
            s.delivery_date BETWEEN CURRENT_DATE - INTERVAL 90 DAY
                                AND CURRENT_DATE + INTERVAL 14 DAY
            AND i.is_deleted IS NULL
            AND i.deliver_completed IS NULL
            AND h.is_deleted IS NULL
    ),

final AS (
    SELECT
        purchase_order,
        po_item,
        material_id,
        plant,
        storage_location,
        scheduled_delivery_date,
        scheduled_qty,
        delivered_qty,
        posted_qty,
        CASE
            WHEN scheduled_qty - posted_qty < 0 THEN 0
            ELSE scheduled_qty - posted_qty
        END AS open_qty
    
    FROM
        base_purchase_orders
)

SELECT
    *

FROM
    final

WHERE
    open_qty > 0
