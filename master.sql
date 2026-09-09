WITH report_ts AS (SELECT CURRENT_DATETIME('Asia/Kolkata') AS ts_at),
fc_master AS (
SELECT * FROM UNNEST([
    STRUCT('2'  AS fc_id, 'MUMBAI'     AS fc_name, 'Mumbai'    AS fc_city),
    STRUCT('4'  AS fc_id, 'GURGAON'    AS fc_name, 'Gurugram'  AS fc_city),
    STRUCT('10' AS fc_id, 'BANGALORE'  AS fc_name, 'Bangalore' AS fc_city),
    STRUCT('12' AS fc_id, 'KOLKATA'    AS fc_name, 'Kolkata'   AS fc_city),
    STRUCT('16' AS fc_id, 'GUWAHATI'   AS fc_name, 'Guwahati'  AS fc_city),
    STRUCT('21' AS fc_id, 'LUCKNOW'    AS fc_name, 'Lucknow'   AS fc_city),
    STRUCT('25' AS fc_id, 'CHENNAI'    AS fc_name, 'Chennai'   AS fc_city),
    STRUCT('28' AS fc_id, 'HYDERABAD'  AS fc_name, 'Hyderabad' AS fc_city),
    STRUCT('29' AS fc_id, 'KOCHI'      AS fc_name, 'Kochi'     AS fc_city),
    STRUCT('40' AS fc_id, 'VIJAYAWADA' AS fc_name, 'Vijayawada' AS fc_city),
    STRUCT('42' AS fc_id, 'COIMBATORE' AS fc_name, 'Coimbatore' AS fc_city),
    STRUCT('45' AS fc_id, 'PATNA'      AS fc_name, 'Patna'     AS fc_city),
    STRUCT('47' AS fc_id, 'BHUBANESWAR'AS fc_name, 'Bhubaneswar' AS fc_city)
  ])

),
ds_master AS (
SELECT * FROM UNNEST([
    STRUCT('51'  AS ds_id, 'Karnataka'          AS cluster, 'Vijayawada' AS ds_city, 'Vijayawada'                 AS ds_name),
    STRUCT('52'  AS ds_id, 'Karnataka'          AS cluster, 'Bangalore'  AS ds_city, 'Vijaynagar'                 AS ds_name),
    STRUCT('53'  AS ds_id, 'Karnataka'          AS cluster, 'Bangalore'  AS ds_city, 'Bel Road'                   AS ds_name),
    STRUCT('54'  AS ds_id, 'Karnataka'          AS cluster, 'Bangalore'  AS ds_city, 'Marthalli'                  AS ds_name),
    STRUCT('56'  AS ds_id, 'Chennai'            AS cluster, 'Bangalore'  AS ds_city, 'Begur'                      AS ds_name),
    STRUCT('58'  AS ds_id, 'Chennai'            AS cluster, 'Chennai'    AS ds_city, 'Kodungaiyur'                AS ds_name),
    STRUCT('59'  AS ds_id, 'Chennai'            AS cluster, 'Chennai'    AS ds_city, 'Saidapet'                   AS ds_name),
    STRUCT('61'  AS ds_id, 'Telangana'          AS cluster, 'Chennai'    AS ds_city, 'Venkateshpuram'             AS ds_name),
    STRUCT('62'  AS ds_id, 'Telangana'          AS cluster, 'Hyderabad'  AS ds_city, 'Balanagar'                  AS ds_name),
    STRUCT('63'  AS ds_id, 'Telangana'          AS cluster, 'Hyderabad'  AS ds_city, 'Defence'                    AS ds_name),
    STRUCT('64'  AS ds_id, 'Telangana'          AS cluster, 'Hyderabad'  AS ds_city, 'Manikonda'                  AS ds_name),
    STRUCT('80'  AS ds_id, 'Central Kerala'     AS cluster, 'Kerala'     AS ds_city, 'Aluva'                      AS ds_name),
    STRUCT('81'  AS ds_id, 'Chennai'            AS cluster, 'Chennai'    AS ds_city, 'Adoor'                      AS ds_name),
    STRUCT('82'  AS ds_id, 'Telangana'          AS cluster, 'Chennai'    AS ds_city, 'Porur'                      AS ds_name),
    STRUCT('84'  AS ds_id, 'South Kerala'       AS cluster, 'Kolkata'    AS ds_city, 'Shibachal'                  AS ds_name),
    STRUCT('85'  AS ds_id, 'Karnataka'          AS cluster, 'Kolkata'    AS ds_city, 'Jadhavpur'                  AS ds_name),
    STRUCT('86'  AS ds_id, 'Delhi NCR'          AS cluster, 'Delhi'      AS ds_city, 'Palam'                      AS ds_name),
    STRUCT('87'  AS ds_id, 'Central Kerala'     AS cluster, 'Kerala'     AS ds_city, 'Lucknow'                    AS ds_name),
    STRUCT('88'  AS ds_id, 'Odisha'             AS cluster, 'Hyderabad'  AS ds_city, 'Kharmanghat'                AS ds_name),
    STRUCT('89'  AS ds_id, 'Rest of Tamil Nadu' AS cluster, 'Kolkata'    AS ds_city, 'Behala'                     AS ds_name),
    STRUCT('90'  AS ds_id, 'Central Kerala'     AS cluster, 'Kerala'     AS ds_city, 'Chrompet'                   AS ds_name),
    STRUCT('1056' AS ds_id, 'North Kerala'      AS cluster, 'Uttar Pradesh' AS ds_city, 'Noida'                    AS ds_name),
    STRUCT('1063' AS ds_id, 'North Kerala'      AS cluster, 'Kerala'     AS ds_city, 'Kollam'                     AS ds_name),
    STRUCT('1079' AS ds_id, NULL                AS cluster, NULL         AS ds_city, NULL                         AS ds_name),  -- unmapped
    STRUCT('1096' AS ds_id, 'North Kerala'      AS cluster, NULL         AS ds_city, 'Miyapur'                    AS ds_name),
    STRUCT('6000' AS ds_id, 'West Bengal'       AS cluster, NULL         AS ds_city, 'Bhubneshwar'                AS ds_name),
    STRUCT('6001' AS ds_id, 'West Bengal'       AS cluster, NULL         AS ds_city, 'Coimbatore_1'               AS ds_name),
    STRUCT('6002' AS ds_id, 'West Bengal'       AS cluster, NULL         AS ds_city, 'Chalakudy'                  AS ds_name),
    STRUCT('6003' AS ds_id, 'West Bengal'       AS cluster, NULL         AS ds_city, 'Chengannur'                 AS ds_name),
    STRUCT('6004' AS ds_id, 'Andhra Pradesh'    AS cluster, NULL         AS ds_city, 'Kannur DS'                  AS ds_name),
    STRUCT('6005' AS ds_id, 'Andhra Pradesh'    AS cluster, NULL         AS ds_city, 'KARUNAGAPALLI'              AS ds_name),
    STRUCT('6006' AS ds_id, 'North Kerala'      AS cluster, NULL         AS ds_city, 'Yelhanka'                   AS ds_name),
    STRUCT('6007' AS ds_id, 'Rest of Tamil Nadu' AS cluster, NULL        AS ds_city, 'Cuttack'                    AS ds_name),
    STRUCT('6008' AS ds_id, 'South Kerala'      AS cluster, NULL         AS ds_city, 'Ghaziabad'                  AS ds_name),
    STRUCT('6009' AS ds_id, 'Rest of Tamil Nadu' AS cluster, NULL        AS ds_city, 'Sonagachi - Vivekananda Road' AS ds_name),
    STRUCT('6010' AS ds_id, 'Maharashtra'       AS cluster, NULL         AS ds_city, 'Tangra'                     AS ds_name),
    STRUCT('6011' AS ds_id, 'South Kerala'      AS cluster, NULL         AS ds_city, 'Siliguri'                   AS ds_name),
    STRUCT('6012' AS ds_id, 'Karnataka'         AS cluster, NULL         AS ds_city, 'VISAKHAPATNAM_2 (shift 1)'  AS ds_name),
    STRUCT('6013' AS ds_id, 'Central Kerala'    AS cluster, NULL         AS ds_city, 'Kochi 2'                    AS ds_name),
    STRUCT('6016' AS ds_id, 'South Kerala'      AS cluster, 'Rest of Tamil Nadu' AS ds_city, 'RR Nagar'            AS ds_name),
    STRUCT('6017' AS ds_id, 'Karnataka'         AS cluster, NULL         AS ds_city, 'Madurai'                    AS ds_name),
    STRUCT('6021' AS ds_id, 'Maharashtra'       AS cluster, NULL         AS ds_city, 'TIRUCHIRAPALLY'             AS ds_name),
    STRUCT('6023' AS ds_id, 'Rest of Tamil Nadu' AS cluster, NULL        AS ds_city, 'Andheri'                    AS ds_name),
    STRUCT('6024' AS ds_id, 'Andhra Pradesh'    AS cluster, NULL         AS ds_city, 'Kottayam'                   AS ds_name),
    STRUCT('6025' AS ds_id, 'South Kerala'      AS cluster, NULL         AS ds_city, 'New Jadhavpur'              AS ds_name),
    STRUCT('6026' AS ds_id, 'South Kerala'      AS cluster, NULL         AS ds_city, 'New Rohtash'                AS ds_name),
    STRUCT('6027' AS ds_id, 'Delhi NCR'         AS cluster, NULL         AS ds_city, 'Kozhikode'                  AS ds_name),
    STRUCT('6028' AS ds_id, 'Maharashtra'       AS cluster, NULL         AS ds_city, 'Kunamkulam'                 AS ds_name),
    STRUCT('6029' AS ds_id, 'Delhi NCR'         AS cluster, NULL         AS ds_city, 'Mangalore'                  AS ds_name),
    STRUCT('6031' AS ds_id, 'Telangana'         AS cluster, 'Kerala'     AS ds_city, 'Manjeri'                    AS ds_name),
    STRUCT('6033' AS ds_id, 'Delhi NCR'         AS cluster, NULL         AS ds_city, 'Kanpur'                     AS ds_name),
    STRUCT('6034' AS ds_id, 'Delhi NCR'         AS cluster, NULL         AS ds_city, 'Sewri'                      AS ds_name),
    STRUCT('6035' AS ds_id, 'Chennai'           AS cluster, NULL         AS ds_city, 'Coimbatore 2'               AS ds_name),
    STRUCT('6036' AS ds_id, 'West Bengal'       AS cluster, NULL         AS ds_city, 'Guntur'                     AS ds_name),
    STRUCT('6037' AS ds_id, 'Karnataka'         AS cluster, NULL         AS ds_city, 'Mavelikara'                 AS ds_name),
    STRUCT('6038' AS ds_id, 'West Bengal'       AS cluster, NULL         AS ds_city, 'Neyyattinkara'              AS ds_name),
    STRUCT('6039' AS ds_id, 'Chennai'           AS cluster, 'Delhi'      AS ds_city, 'Okhla'                      AS ds_name),
    STRUCT('6040' AS ds_id, 'Delhi NCR'         AS cluster, NULL         AS ds_city, 'Thane'                      AS ds_name),
    STRUCT('6041' AS ds_id, 'Central Kerala'    AS cluster, 'Kochi'      AS ds_city, 'Kochi'                      AS ds_name),
    STRUCT('6042' AS ds_id, 'North Kerala'      AS cluster, NULL         AS ds_city, 'VISAKHAPATNAM_1 (shift 2)'  AS ds_name),
    STRUCT('6044' AS ds_id, 'Odisha'            AS cluster, NULL         AS ds_city, 'North Parvoor'              AS ds_name),
    STRUCT('6045' AS ds_id, 'Karnataka'         AS cluster, NULL         AS ds_city, NULL                         AS ds_name),
    STRUCT('6047' AS ds_id, 'Rest of Tamil Nadu' AS cluster, NULL        AS ds_city, NULL                         AS ds_name),
    STRUCT('6048' AS ds_id, 'Andhra Pradesh'    AS cluster, NULL         AS ds_city, 'wadakkanchery'              AS ds_name),
    STRUCT('6049' AS ds_id, 'South Kerala'      AS cluster, NULL         AS ds_city, 'Ponnani'                    AS ds_name),
    STRUCT('6050' AS ds_id, 'Central Kerala'    AS cluster, NULL         AS ds_city, NULL                         AS ds_name),
    STRUCT('6051' AS ds_id, 'South Kerala'      AS cluster, 'Delhi'      AS ds_city, 'Rohtash'                    AS ds_name),
    STRUCT('6052' AS ds_id, 'North Kerala'      AS cluster, NULL         AS ds_city, 'BBI2'                       AS ds_name),
    STRUCT('6053' AS ds_id, 'North Kerala'      AS cluster, NULL         AS ds_city, 'Thiruvalla'                 AS ds_name),
    STRUCT('6054' AS ds_id, 'South Kerala'      AS cluster, 'Hyderabad'  AS ds_city, 'Abids'                      AS ds_name),
    STRUCT('6055' AS ds_id, 'South Kerala'      AS cluster, NULL         AS ds_city, 'Chembur'                    AS ds_name),
    STRUCT('6056' AS ds_id, 'North Kerala'      AS cluster, NULL         AS ds_city, 'Thriprayar'                 AS ds_name),
    STRUCT('6057' AS ds_id, 'Central Kerala'    AS cluster, NULL         AS ds_city, 'Alappuzha'                  AS ds_name),
    STRUCT('6059' AS ds_id, 'Maharashtra'       AS cluster, NULL         AS ds_city, 'New Behala'                 AS ds_name),
    STRUCT('6060' AS ds_id, 'South Kerala'      AS cluster, NULL         AS ds_city, 'Tirur'                      AS ds_name),
    STRUCT('6061' AS ds_id, 'South Kerala'      AS cluster, NULL         AS ds_city, 'New Palam'                  AS ds_name),
    STRUCT('6062' AS ds_id, 'South Kerala'      AS cluster, NULL         AS ds_city, NULL                         AS ds_name),
    STRUCT('6063' AS ds_id, 'North Kerala'      AS cluster, NULL         AS ds_city, 'Thiruvalla'                 AS ds_name),
    STRUCT('6064' AS ds_id, 'South Kerala'      AS cluster, 'Bangalore'  AS ds_city, 'Kalyan Nagar'               AS ds_name),
    STRUCT('6065' AS ds_id, 'South Kerala'      AS cluster, NULL         AS ds_city, 'Trivendrum 2'               AS ds_name),
    STRUCT('6066' AS ds_id, 'South Kerala'      AS cluster, NULL         AS ds_city, 'Pattambi'                   AS ds_name),
    STRUCT('6067' AS ds_id, 'North Kerala'      AS cluster, NULL         AS ds_city, 'Alathur'                    AS ds_name),
    STRUCT('6068' AS ds_id, 'Central Kerala'    AS cluster, NULL         AS ds_city, 'South Chennai'              AS ds_name),
    STRUCT('6069' AS ds_id, 'Rest of Tamil Nadu' AS cluster, NULL        AS ds_city, NULL                         AS ds_name),
    STRUCT('6070' AS ds_id, 'Odisha'            AS cluster, NULL         AS ds_city, 'Rohini'                     AS ds_name),
    STRUCT('6071' AS ds_id, 'West Bengal'       AS cluster, 'Kerala'     AS ds_city, 'Palakkad'                   AS ds_name),
    STRUCT('6072' AS ds_id, 'Odisha'            AS cluster, NULL         AS ds_city, 'Puri'                       AS ds_name),
    STRUCT('6073' AS ds_id, 'Central Kerala'    AS cluster, NULL         AS ds_city, 'Chandanagar'                AS ds_name),
    STRUCT('6074' AS ds_id, NULL                AS cluster, NULL         AS ds_city, NULL                         AS ds_name),  -- unmapped
    STRUCT('6078' AS ds_id, 'Rest of Tamil Nadu' AS cluster, 'Kerala'    AS ds_city, 'Perinthalmanna'             AS ds_name),
    STRUCT('6083' AS ds_id, 'West Bengal'       AS cluster, NULL         AS ds_city, NULL                         AS ds_name),
    STRUCT('6084' AS ds_id, 'South Kerala'      AS cluster, NULL         AS ds_city, 'Erode'                      AS ds_name),
    STRUCT('6085' AS ds_id, 'Central Kerala'    AS cluster, NULL         AS ds_city, NULL                         AS ds_name),
    STRUCT('6087' AS ds_id, 'Central Kerala'    AS cluster, NULL         AS ds_city, NULL                         AS ds_name)
  ])

),
-- ------------------------------------------------------------------ CTE block: replication of the source export query structure
po_base AS (
  SELECT
    p.id AS po_id,
    p.warehouse_id,
    p.status,
    DATETIME(TIMESTAMP_SECONDS(p.time_stamp), 'Asia/Kolkata') AS po_datetime,
    DATE(TIMESTAMP_SECONDS(p.time_stamp), 'Asia/Kolkata') AS po_date
  FROM `datos_deposito_banco.purplle_purplle2_procurement_po` p
  WHERE 1 = 1
    AND DATE(TIMESTAMP_SECONDS(p.time_stamp), 'Asia/Kolkata') >= '2026-03-01'
    AND p.status IN (
      'Completed','Inwarding','Received','Intransit',
      'Partially Intransit','Partially Received',
      'Dispatched','Pending','Picking','Prepared','Preparing'
    )
),
dispatch_cte AS (
  SELECT
    pp.id AS po_id,
    ANY_VALUE(pl.module) AS flow,
    MAX(DATETIME(TIMESTAMP_SECONDS(pl.time_stamp), 'Asia/Kolkata')) AS dispatch_time
  FROM `datos_deposito_banco.purplle_purplle2_purchase_logchange` pl
  LEFT JOIN `datos_deposito_banco.purplle_purplle2_procurement_po` pp ON pp.id = pl.module_id
  WHERE pl.module = 'STO' AND pl.status = 'Dispatched'
  GROUP BY pp.id
),
po_qty_cte AS (
  SELECT po_id, SUM(quantity) AS po_qty
  FROM `datos_deposito_banco.purplle_purplle2_procurement_poitem`
  GROUP BY po_id
),
box_detail_cte AS (
  SELECT
    CAST(bbd.po_id AS STRING) AS po_id,
    CAST(bbd.consignment_id AS STRING) AS consignment_id,
    bbd.box_code, bbd.box_status,
    SAFE_CAST(bbd.length_cm AS FLOAT64) AS length_cm,
    SAFE_CAST(bbd.breadth_cm AS FLOAT64) AS breadth_cm,
    SAFE_CAST(bbd.height_cm AS FLOAT64) AS height_cm,
    SAFE_CAST(bbd.weight_kg AS FLOAT64) AS weight_kg,
    DATETIME(TIMESTAMP_SECONDS(SAFE_CAST(bbd.handover_timestamp AS INT64)), 'Asia/Kolkata') AS handover_datetime,
    DATETIME(TIMESTAMP_SECONDS(SAFE_CAST(bbd.receive_timestamp AS INT64)), 'Asia/Kolkata') AS receive_time
  FROM `datos_deposito_banco.logistics_b2b_box_details` bbd
),
scbm_cte AS (
  SELECT
    CAST(po_id AS STRING) AS po_id,
    CAST(consignment_id AS STRING) AS consignment_id,
    box_code,
    SAFE_CAST(box_length AS FLOAT64) AS length_cm,
    SAFE_CAST(box_breadth AS FLOAT64) AS breadth_cm,
    SAFE_CAST(box_height AS FLOAT64) AS height_cm,
    SAFE_CAST(box_physical_weight AS FLOAT64) AS weight_kg,
    ishandover, isreceive,
    DATETIME(TIMESTAMP_SECONDS(SAFE_CAST(created_on AS INT64)), 'Asia/Kolkata') AS scbm_created_time,
    DATETIME(TIMESTAMP_SECONDS(SAFE_CAST(start_time AS INT64)), 'Asia/Kolkata') AS scbm_start_time
  FROM `datos_deposito_banco.purplle_purplle2_sto_consignment_box_mapping`
),
box_final_cte AS (
  SELECT
    CAST(pb.po_id AS STRING) AS po_id,
    COALESCE(bd.box_code, sc.box_code) AS box_code,
    COALESCE(bd.consignment_id, sc.consignment_id) AS consignment_id,
    bd.box_status,
    COALESCE(bd.length_cm, sc.length_cm) AS length_cm,
    COALESCE(bd.breadth_cm, sc.breadth_cm) AS breadth_cm,
    COALESCE(bd.height_cm, sc.height_cm) AS height_cm,
    COALESCE(bd.weight_kg, sc.weight_kg) AS weight_kg,
    bd.handover_datetime,
    COALESCE(bd.receive_time, CASE WHEN sc.isreceive = 1 THEN sc.scbm_created_time END) AS receive_time
  FROM po_base pb
  LEFT JOIN box_detail_cte bd    ON CAST(pb.po_id AS STRING) = bd.po_id
  LEFT JOIN scbm_cte sc          ON CAST(pb.po_id AS STRING) = sc.po_id
                                AND COALESCE(bd.box_code, sc.box_code) = sc.box_code
),
po_box_agg_cte AS (
  SELECT
    po_id,
    STRING_AGG(DISTINCT consignment_id, ', ' ORDER BY consignment_id) AS consignment_id,
    COUNT(DISTINCT box_code) AS total_box_count,
    MAX(handover_datetime) AS handover_datetime,
    MAX(receive_time) AS receive_time
  FROM box_final_cte
  GROUP BY po_id
),
consignment_cte AS (
  SELECT
    CAST(bcd.consignment_id AS STRING) AS consignment_id,
    bcd.flow_type, bcd.consignment_status,
    CAST(bcd.source_location_id AS STRING) AS source_location_id,
    CAST(bcd.destination_location_id AS STRING) AS destination_location_id,
    bcd.total_boxes_expected, bcd.total_boxes_packed, bcd.total_boxes_handed_over, bcd.total_boxes_received,
    bcd.total_consignment_value, bcd.account_code,
    bcd.mwb AS lr_number
  FROM `datos_deposito_banco.logistics_b2b_consignment_details` bcd
),
po_consignment_agg_cte AS (
  SELECT
    bfa.po_id,
    STRING_AGG(DISTINCT c.flow_type, ', ' ORDER BY c.flow_type) AS flow_type,
    STRING_AGG(DISTINCT c.consignment_status, ', ' ORDER BY c.consignment_status) AS consignment_status,
    STRING_AGG(DISTINCT c.source_location_id, ', ' ORDER BY c.source_location_id) AS source_location_id,
    STRING_AGG(DISTINCT c.destination_location_id, ', ' ORDER BY c.destination_location_id) AS destination_location_id,
    MAX(c.total_boxes_expected) AS total_boxes_expected,
    MAX(c.total_boxes_packed) AS total_boxes_packed,
    MAX(c.total_boxes_handed_over) AS total_boxes_handed_over,
    MAX(c.total_boxes_received) AS total_boxes_received,
    MAX(c.total_consignment_value) AS total_consignment_value,
    STRING_AGG(DISTINCT c.account_code, ', ' ORDER BY c.account_code) AS account_code,
    STRING_AGG(DISTINCT c.lr_number, ', ' ORDER BY c.lr_number) AS lr_number
  FROM box_final_cte bfa
  LEFT JOIN consignment_cte c ON bfa.consignment_id = c.consignment_id
  GROUP BY bfa.po_id
),
courier_cte AS (
  SELECT CAST(reference_number AS STRING) AS consignment_id, ANY_VALUE(courier_name) AS courier_name
  FROM `datos_deposito_banco.logistics_lms_clickpost_b2b_order_polling_details`
  GROUP BY 1
),
po_courier_agg_cte AS (
  SELECT bfa.po_id,
         STRING_AGG(DISTINCT cr.courier_name, ', ' ORDER BY cr.courier_name) AS courier_name
  FROM box_final_cte bfa
  LEFT JOIN courier_cte cr ON bfa.consignment_id = cr.consignment_id
  GROUP BY bfa.po_id
),
latest_tracking_cte AS (
  SELECT
    CAST(reference_number AS STRING) AS consignment_id,
    status AS latest_tracking_status,
    DATETIME(SAFE_CAST(timestamp AS TIMESTAMP), 'Asia/Kolkata') AS latest_tracking_timestamp,
    SAFE_CAST(NULLIF(courier_partner_edd, '') AS DATE) AS courier_partner_edd,
    ROW_NUMBER() OVER (PARTITION BY CAST(reference_number AS STRING)
                       ORDER BY SAFE_CAST(timestamp AS TIMESTAMP) DESC, SAFE_CAST(created_on AS INT64) DESC) AS rn
  FROM `datos_deposito_banco.logistics_lms_clickpost_b2b_tracking_status_details`
),
po_tracking_agg_cte AS (
  SELECT
    bfa.po_id,
    STRING_AGG(DISTINCT lt.latest_tracking_status, ', ' ORDER BY lt.latest_tracking_status) AS latest_tracking_status,
    MAX(lt.latest_tracking_timestamp) AS latest_tracking_timestamp,
    MAX(lt.courier_partner_edd) AS courier_partner_edd
  FROM box_final_cte bfa
  LEFT JOIN latest_tracking_cte lt ON bfa.consignment_id = lt.consignment_id AND lt.rn = 1
  GROUP BY bfa.po_id
),
-- NOTE: dispatched_qty / inward_qty = DISTINCT item_code (SKU-line) counts, NOT units.
dispatch_qty_cte AS (
  SELECT po_id, COUNT(DISTINCT item_code) AS dispatched_qty
  FROM `datos_deposito_banco.purplle_purplle2_box_item_mapping_iwt`
  GROUP BY po_id
),
inward_qty_cte AS (
  SELECT
    pp.po_id,
    COUNT(DISTINCT ppi.item_code) AS inward_qty,
    MAX(DATETIME(TIMESTAMP_SECONDS(SAFE_CAST(iil.time_stamp AS INT64)), 'Asia/Kolkata')) AS inward_time
  FROM `datos_deposito_banco.purplle_purplle2_procurement_purchase` pp
  LEFT JOIN `datos_deposito_banco.purplle_purplle2_inventory_inout_log` iil
    ON iil.action_id = pp.id AND iil.action = 'in' AND iil.type = 'STO_Purchase'
  LEFT JOIN `datos_deposito_banco.purplle_purplle2_procurement_inventoryitem` ppi ON ppi.id = iil.inventoryitem_id
  GROUP BY pp.po_id
),
sap_dispatch AS (
  SELECT CAST(reference_id AS STRING) AS reference_id, CAST(sap_invoice_no AS STRING) AS sap_invoice_number
  FROM `datos_deposito_banco.logistics_b2b_sto_dispatch_sap_webhook_info`
  GROUP BY 1, 2
),
sap_movement_cte AS (
  SELECT
    CAST(bim.po_id AS INT64) AS po_id,
    STRING_AGG(DISTINCT CAST(bim.sap_movement_id AS STRING), ', ' ORDER BY CAST(bim.sap_movement_id AS STRING)) AS sap_movement_id,
    STRING_AGG(DISTINCT CAST(bim.sap_status AS STRING), ', ' ORDER BY CAST(bim.sap_status AS STRING)) AS sap_status,
    STRING_AGG(DISTINCT sd.sap_invoice_number, ', ' ORDER BY sd.sap_invoice_number) AS invoice_id
  FROM `datos_deposito_banco.purplle_purplle2_box_item_mapping_iwt` bim
  LEFT JOIN sap_dispatch sd ON CAST(bim.sap_movement_id AS STRING) = sd.reference_id
  WHERE bim.sap_movement_id IS NOT NULL
  GROUP BY 1
),
sto_meta_cte AS (
  SELECT SAFE_CAST(sto_id AS INT64) AS po_id, ANY_VALUE(po_type) AS po_type, ANY_VALUE(store_type) AS store_type
  FROM `datos_studios.sto_po_tracking_2026`
  WHERE sto_id IS NOT NULL
  GROUP BY 1
),
carrier_assignment_cte AS (
  SELECT SAFE_CAST(reference_id AS INT64) AS po_id, ANY_VALUE(transport_mode) AS transport_mode
  FROM `datos_deposito_banco.logistics_b2b_carrier_assignments`
  WHERE reference_id IS NOT NULL
  GROUP BY 1
),
base_raw AS (
  SELECT
    pb.po_id, pb.po_date, pb.po_datetime, pb.warehouse_id,
    d.flow, pca.flow_type, pb.status AS sto_po_status,
    smeta.po_type, smeta.store_type, ca.transport_mode,
    CASE
      WHEN pca.source_location_id IN ('2','4','10','12','16','21','25','28','29','40','42','45','47')
       AND pca.destination_location_id IN (
         '26','27','44','49','50','51','52','53','54','55','56','57','58','59','60',
         '61','62','63','64','65','80','81','82','84','85','86','87','88','89','90','101',
         '6000','6001','6002','6003','6004','6005','6006','6007','6008','6009',
         '6010','6011','6012','6013','6014','6015','6016','6017','6019',
         '6020','6021','6022','6023','6024','6025','6026','6027','6028','6029',
         '6030','6031','6033','6034','6035','6036','6037','6038','6039',
         '6040','6041','6042','6043','6044','6045','6046','6047','6048','6049',
         '6050','6051','6052','6053','6054','6055','6056','6057','6058',
         '1063','1096','1056','1079',
         '6059','6060','6061','6062','6063','6064','6065','6066','6067','6068',
         '6069','6070','6071','6072','6073','6074','6075','6076','6077','6078',
         '6079','6080','6081','6082','6083','6084','6085','6086','6087','6088','6089','6090'
       )
      THEN 'FC to DS'
      ELSE 'Other'
    END AS lane,
    pca.source_location_id, pca.destination_location_id,
    pq.po_qty, pba.total_box_count,
    pca.total_boxes_expected, pca.total_boxes_packed, pca.total_boxes_handed_over, pca.total_boxes_received,
    d.dispatch_time, pba.handover_datetime, pba.receive_time,
    COALESCE(dq.dispatched_qty, 0) AS dispatched_qty,
    COALESCE(iq.inward_qty, 0) AS inward_qty,
    iq.inward_time,
    COALESCE(dq.dispatched_qty, 0) - COALESCE(iq.inward_qty, 0) AS pending_qty,
    pba.consignment_id, pca.consignment_status, pca.lr_number,
    pcr.courier_name, pta.latest_tracking_status, pta.latest_tracking_timestamp, pta.courier_partner_edd,
    sm.sap_movement_id, sm.sap_status, sm.invoice_id,
    pca.total_consignment_value, pca.account_code
  FROM po_base pb
  LEFT JOIN dispatch_cte d             ON pb.po_id = d.po_id
  LEFT JOIN po_qty_cte pq             ON pb.po_id = pq.po_id
  LEFT JOIN po_box_agg_cte pba        ON CAST(pb.po_id AS STRING) = pba.po_id
  LEFT JOIN po_consignment_agg_cte pca ON CAST(pb.po_id AS STRING) = pca.po_id
  LEFT JOIN po_courier_agg_cte pcr    ON CAST(pb.po_id AS STRING) = pcr.po_id
  LEFT JOIN po_tracking_agg_cte pta   ON CAST(pb.po_id AS STRING) = pta.po_id
  LEFT JOIN sap_movement_cte sm       ON pb.po_id = sm.po_id
  LEFT JOIN dispatch_qty_cte dq       ON pb.po_id = dq.po_id
  LEFT JOIN inward_qty_cte iq         ON pb.po_id = iq.po_id
  LEFT JOIN sto_meta_cte smeta        ON pb.po_id = smeta.po_id
  LEFT JOIN carrier_assignment_cte ca ON pb.po_id = ca.po_id
  WHERE d.flow = 'STO'
),
final_raw AS (
  SELECT * FROM base_raw WHERE lane = 'FC to DS'
),
-- ------------------------------------------------------------------ NTRBD scheduling model (unchanged from source)
fc_ds_ds_shift_ntrbd_raw AS (
  SELECT
    SAFE_CAST(receiving_warehouse AS INT64) AS warehouse_id,
    COALESCE(SAFE.PARSE_TIME('%I:%M %p', CAST(start_time AS STRING)),
             SAFE.PARSE_TIME('%H:%M:%S', CAST(start_time AS STRING)),
             SAFE.PARSE_TIME('%H:%M', CAST(start_time AS STRING))) AS shift_start_time,
    COALESCE(SAFE.PARSE_TIME('%I:%M %p', CAST(end_time AS STRING)),
             SAFE.PARSE_TIME('%H:%M:%S', CAST(end_time AS STRING)),
             SAFE.PARSE_TIME('%H:%M', CAST(end_time AS STRING))) AS shift_end_time,
    LOWER(TRIM(CAST(unnamed_3 AS STRING))) AS shift_note
  FROM `datos_studios.sto_b2b_ds_shift_time`
),
fc_ds_ds_shift_ntrbd AS (
  SELECT
    warehouse_id,
    shift_start_time AS first_shift_start_time,
    shift_end_time AS last_shift_end_time,
    CASE WHEN shift_note LIKE '%24 hours%' THEN 1 ELSE 0 END AS is_24_hours
  FROM fc_ds_ds_shift_ntrbd_raw
),
ntrbd_base AS (
  SELECT
    br.*,
    sh.first_shift_start_time, sh.last_shift_end_time, sh.is_24_hours,
    0.73 AS wip_mins_per_qty,
    20 AS same_day_receive_buffer_mins,
    30 AS next_day_start_buffer_mins,
    ROUND(COALESCE(br.po_qty, 0) * 0.73, 2) AS total_ntrbd_mins,
    DATETIME_ADD(br.receive_time, INTERVAL 20 MINUTE) AS same_day_processing_start_dt,
    CASE
      WHEN sh.is_24_hours = 1 OR br.receive_time IS NULL OR sh.last_shift_end_time IS NULL
      THEN NULL
      ELSE DATETIME(DATE(br.receive_time), sh.last_shift_end_time)
    END AS same_day_shift_end_dt,
    CASE
      WHEN sh.is_24_hours = 1 OR br.receive_time IS NULL OR sh.first_shift_start_time IS NULL
      THEN NULL
      ELSE DATETIME_ADD(DATETIME(DATE_ADD(DATE(br.receive_time), INTERVAL 1 DAY), sh.first_shift_start_time),
                        INTERVAL 30 MINUTE)
    END AS next_day_processing_start_dt
  FROM final_raw br
  LEFT JOIN fc_ds_ds_shift_ntrbd sh
    ON SAFE_CAST(br.destination_location_id AS INT64) = sh.warehouse_id
  WHERE br.receive_time IS NOT NULL
),
ntrbd_cutoff_calc AS (
  SELECT
    nb.*,
    GREATEST(DATETIME_DIFF(nb.same_day_shift_end_dt, nb.same_day_processing_start_dt, MINUTE), 0) AS available_same_day_mins,
    CASE
      WHEN nb.receive_time IS NULL THEN NULL
      WHEN nb.is_24_hours = 1 THEN DATETIME_ADD(DATETIME_ADD(nb.receive_time, INTERVAL 20 MINUTE),
                                                INTERVAL CAST(ROUND(nb.total_ntrbd_mins, 0) AS INT64) MINUTE)
      WHEN nb.last_shift_end_time IS NULL THEN DATETIME_ADD(DATETIME_ADD(nb.receive_time, INTERVAL 20 MINUTE),
                                                            INTERVAL CAST(ROUND(nb.total_ntrbd_mins, 0) AS INT64) MINUTE)
      WHEN GREATEST(DATETIME_DIFF(nb.same_day_shift_end_dt, nb.same_day_processing_start_dt, MINUTE), 0)
           >= CAST(ROUND(nb.total_ntrbd_mins, 0) AS INT64)
        THEN DATETIME_ADD(nb.same_day_processing_start_dt, INTERVAL CAST(ROUND(nb.total_ntrbd_mins, 0) AS INT64) MINUTE)
      ELSE DATETIME_ADD(nb.next_day_processing_start_dt,
                        INTERVAL GREATEST(CAST(ROUND(nb.total_ntrbd_mins, 0) AS INT64)
                                          - GREATEST(DATETIME_DIFF(nb.same_day_shift_end_dt, nb.same_day_processing_start_dt, MINUTE), 0), 0) MINUTE)
    END AS ntrbd_cutoff
  FROM ntrbd_base nb
),
ntrbd_fc_ds AS (
  SELECT
    nc.*,
    CASE
      WHEN nc.receive_time IS NULL THEN 'No Receive Time'
      WHEN nc.inward_time IS NOT NULL AND nc.inward_time <= nc.ntrbd_cutoff THEN 'Within NTRBD'
      WHEN nc.inward_time IS NOT NULL AND nc.inward_time >  nc.ntrbd_cutoff THEN 'Breach'
      WHEN nc.inward_time IS NULL AND (SELECT ts_at FROM report_ts) <= nc.ntrbd_cutoff       THEN 'Pending Within NTRBD'
      WHEN nc.inward_time IS NULL AND (SELECT ts_at FROM report_ts) >  nc.ntrbd_cutoff       THEN 'Pending Breach'
      ELSE 'Check'
    END AS ntrbd_status,
    CASE
      WHEN nc.receive_time IS NULL THEN 0
      WHEN nc.inward_time IS NOT NULL AND nc.inward_time <= nc.ntrbd_cutoff THEN 0
      WHEN nc.inward_time IS NOT NULL AND nc.inward_time >  nc.ntrbd_cutoff THEN 1
      WHEN nc.inward_time IS NULL AND (SELECT ts_at FROM report_ts) > nc.ntrbd_cutoff THEN 1
      ELSE 0
    END AS ntrbd_breach_flag,
    CASE
      WHEN nc.receive_time IS NULL THEN NULL
      WHEN nc.inward_time IS NOT NULL THEN ROUND(DATETIME_DIFF(nc.inward_time, nc.receive_time, MINUTE) / 60.0, 2)
      ELSE ROUND(DATETIME_DIFF((SELECT ts_at FROM report_ts), nc.receive_time, MINUTE) / 60.0, 2)
    END AS actual_receive_to_inward_hrs,
    CASE
      WHEN nc.receive_time IS NULL THEN NULL
      WHEN nc.inward_time IS NOT NULL THEN ROUND(DATETIME_DIFF(nc.inward_time, nc.ntrbd_cutoff, MINUTE) / 60.0, 2)
      ELSE ROUND(DATETIME_DIFF((SELECT ts_at FROM report_ts), nc.ntrbd_cutoff, MINUTE) / 60.0, 2)
    END AS breach_hrs
  FROM ntrbd_cutoff_calc nc
)
SELECT * FROM (
SELECT
 'kpi' AS k1, '' AS k2, '' AS k3,
 COUNT(*) AS po_cnt,
 SUM(COALESCE(m.inward_qty,0)) AS inward_qty,
 SUM(COALESCE(m.dispatched_qty,0)) AS dispatched_qty,
 SUM(COALESCE(m.pending_qty,0)) AS pending_qty,
 SUM(CASE WHEN m.ntrbd_breach_flag=1 THEN 1 ELSE 0 END) AS breach_cnt,
 SUM(COALESCE(m.total_consignment_value,0)) AS val FROM ntrbd_fc_ds m WHERE m.po_date >= DATE '2026-07-06' AND m.source_location_id IN ('2','4','10','12','29')
UNION ALL
SELECT
 'daily' AS k1, CAST(m.po_date AS STRING) AS k2, COALESCE(fc.fc_name, m.source_location_id) AS k3,
 COUNT(*) AS po_cnt,
 SUM(COALESCE(m.inward_qty,0)) AS inward_qty,
 SUM(COALESCE(m.dispatched_qty,0)) AS dispatched_qty,
 SUM(COALESCE(m.pending_qty,0)) AS pending_qty,
 SUM(CASE WHEN m.ntrbd_breach_flag=1 THEN 1 ELSE 0 END) AS breach_cnt,
 SUM(COALESCE(m.total_consignment_value,0)) AS val
FROM ntrbd_fc_ds m LEFT JOIN fc_master fc ON m.source_location_id = fc.fc_id WHERE m.po_date >= DATE '2026-07-06' AND m.source_location_id IN ('2','4','10','12','29')
GROUP BY 1,2,3
UNION ALL
SELECT
 'by_fc' AS k1, COALESCE(fc.fc_name, m.source_location_id) AS k2, fc.fc_id AS k3,
 COUNT(*) AS po_cnt,
 SUM(COALESCE(m.inward_qty,0)) AS inward_qty,
 SUM(COALESCE(m.dispatched_qty,0)) AS dispatched_qty,
 SUM(COALESCE(m.pending_qty,0)) AS pending_qty,
 SUM(CASE WHEN m.ntrbd_breach_flag=1 THEN 1 ELSE 0 END) AS breach_cnt,
 SUM(COALESCE(m.total_consignment_value,0)) AS val
FROM ntrbd_fc_ds m LEFT JOIN fc_master fc ON m.source_location_id = fc.fc_id WHERE m.po_date >= DATE '2026-07-06' AND m.source_location_id IN ('2','4','10','12','29')
GROUP BY 1,2,3
UNION ALL
SELECT
 'by_dest' AS k1, COALESCE(ds.cluster,'UNMAPPED') AS k2, COALESCE(ds.ds_name, m.destination_location_id) AS k3,
 COUNT(*) AS po_cnt,
 SUM(COALESCE(m.inward_qty,0)) AS inward_qty,
 SUM(COALESCE(m.dispatched_qty,0)) AS dispatched_qty,
 SUM(COALESCE(m.pending_qty,0)) AS pending_qty,
 SUM(CASE WHEN m.ntrbd_breach_flag=1 THEN 1 ELSE 0 END) AS breach_cnt,
 SUM(COALESCE(m.total_consignment_value,0)) AS val
FROM ntrbd_fc_ds m LEFT JOIN ds_master ds ON m.destination_location_id = ds.ds_id WHERE m.po_date >= DATE '2026-07-06' AND m.source_location_id IN ('2','4','10','12','29')
GROUP BY 1,2,3
UNION ALL
SELECT
 'by_status' AS k1, COALESCE(m.ntrbd_status,'NULL') AS k2, '' AS k3,
 COUNT(*) AS po_cnt,
 SUM(COALESCE(m.inward_qty,0)) AS inward_qty,
 SUM(COALESCE(m.dispatched_qty,0)) AS dispatched_qty,
 SUM(COALESCE(m.pending_qty,0)) AS pending_qty,
 SUM(CASE WHEN m.ntrbd_breach_flag=1 THEN 1 ELSE 0 END) AS breach_cnt,
 SUM(COALESCE(m.total_consignment_value,0)) AS val
FROM ntrbd_fc_ds m WHERE m.po_date >= DATE '2026-07-06' AND m.source_location_id IN ('2','4','10','12','29')
GROUP BY 1,2,3
UNION ALL
SELECT
 'period' AS k1,
 CASE
   WHEN m.po_date BETWEEN DATE '2026-07-06' AND DATE '2026-07-20' THEN 'B1: Jul 06-20'
   WHEN m.po_date BETWEEN DATE '2026-07-21' AND DATE '2026-08-04' THEN 'B2: Jul 21-Aug 04'
   WHEN m.po_date BETWEEN DATE '2026-08-05' AND DATE '2026-08-19' THEN 'B3: Aug 05-19'
   WHEN m.po_date BETWEEN DATE '2026-08-20' AND DATE '2026-09-03' THEN 'B4: Aug 20-Sep 03'
   ELSE 'B5: Sep 04-08'
 END AS k2, COALESCE(fc.fc_name, m.source_location_id) AS k3,
 COUNT(*) AS po_cnt,
 SUM(COALESCE(m.inward_qty,0)) AS inward_qty,
 SUM(COALESCE(m.dispatched_qty,0)) AS dispatched_qty,
 SUM(COALESCE(m.pending_qty,0)) AS pending_qty,
 SUM(CASE WHEN m.ntrbd_breach_flag=1 THEN 1 ELSE 0 END) AS breach_cnt,
 SUM(COALESCE(m.total_consignment_value,0)) AS val
FROM ntrbd_fc_ds m LEFT JOIN fc_master fc ON m.source_location_id = fc.fc_id WHERE m.po_date >= DATE '2026-07-06' AND m.source_location_id IN ('2','4','10','12','29')
GROUP BY 1,2,3
)
ORDER BY k1, k2, k3