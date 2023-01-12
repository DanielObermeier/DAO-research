


################
# Daily dApp txn
################
/* This query creates a table that stores the daily transaction history of a dApp
*/
WITH 
     dapp_txn as (
         SELECT
                t.hash as txn_hash,
                t.block_number as block_number,
                dapp_link.dapp_name as dapp_name,
                DAO_space_id as DAO_space_id,
                t.to_address as to_address,
                t.from_address as from_address,
                CAST(t.value as float64)*POWER(10,-9) as txn_value_GWEI,
                t.block_timestamp as block_timestamp

            FROM `bigquery-public-data.crypto_ethereum.transactions` t 
            INNER JOIN `eth-transactions.dao_research.dapp_dao_contract_link` dapp_link
            ON lower(t.to_address) = lower(dapp_link.contract_address)
     )


SELECT 
    DATE(block_timestamp) as date_key,
    dapp_name as dapp_name,
    DAO_space_id as DAO_space_id,
    COUNT(from_address) as transactions,
    COUNT(DISTINCT from_address) as eoa,
    SUM(txn_value_GWEI) as SUM_txn_value_GWEI,
    AVG(txn_value_GWEI) as AVG_txn_value_GWEI,
FROM dapp_txn 
GROUP BY 1,2, 3



