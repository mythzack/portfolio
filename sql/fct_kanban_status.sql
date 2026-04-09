--Model: fct_kanban_status
--Grain: kanban_controller + kanban_number + controller_item
-- Purpose:
--   Provides current operational visibility into kanban-controlled
--   materials, including quantities, status, and aging indicators.
--
-- Notes:
--   This model is often used as a source for operational dashboards
--   and downstream snapshot processes

WITH
    base_kanbans AS (
        SELECT
            CAST(h.kanban_controller AS INT)                                                AS kanban_controller,
            h.material_id,
            d.description_label                                                             AS material_description,
            h.production_line                                                               AS storage_location,
            CAST(h.total_kanbans AS INT)                                                    AS number_of_kanbans,
            CAST(h.kanban_quantity AS INT)                                                  AS kanban_quantity,
            CAST(i.kanban_number AS INT)                                                    AS kanban_number,
            CAST(i.controller_item AS INT)                                                  AS controller_item,
            CAST(i.filled_qty AS INT)                                                       AS filled_qty,
            CAST(CONCAT(i.filled_date, ' ', i.filled_time) AS DATETIME2)                    AS last_filled,
            i.current_status                                                                AS status_code

        FROM
            kanban_header h

        JOIN
            kanban_item i
            ON i.kanban_controller = h.kanban_controller

        JOIN
            material_descriptions d
            ON d.material_id = h.material_id

        WHERE
            h.production_line IS NOT NULL
    ),

final AS (
    SELECT
        kanban_controller,
        material_id,
        material_description,
        storage_location,
        number_of_kanbans,
        kanban_quantity,
        kanban_number,
        controller_item,
        filled_qty,
        last_filled,
        CASE
            WHEN status_code = 'A' THEN 'no_stock'
            WHEN status_code = 'B' THEN 'being_filled'
            WHEN status_code = 'C' THEN 'filled'
            WHEN status_code = 'D' THEN 'kanban_error'
            ELSE 'status_not_maintained'
        END                                                                             AS status_text,
        CASE
            WHEN last_filled < CURRENT_DATE - INTERVAL 5 DAY THEN 'no_recent_fill'
            ELSE NULL
        END                                                                             AS aged_kanban

    FROM
        base_kanbans
)

SELECT *

FROM
    final

WHERE
    last_filled IS NOT NULL
