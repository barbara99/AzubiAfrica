--#1
SELECT 
COUNT(u_id)
FROM users;

--#2
SELECT * FROM transfers;
SELECT COUNT(u_id) FROM transfers
WHERE send_amount_currency='CFA';

--#3
SELECT COUNT(DISTINCT u_id)
FROM transfers 
WHERE send_amount_currency='CFA';

--#4
SELECT COUNT(*) FROM agent_transaction 
WHERE when_created IN 2018; 

--#6 
SELECT City, Volume 
INTO atx_volume_city_summary
FROM ( Select agents.city AS City,
count(agent_transactions.atx_id) 
AS Volume FROM agents INNER JOIN agent_transactions ON agents.agent_id = agent_transactions.agent_id 
where (agent_transactions.when_created > (NOW() - INTERVAL '1 week')) 
GROUP BY agents.city) as atx_volume_summary; 

--#7 
SELECT City, Volume, Country
INTO atx_volume_city_summary_with_Country
FROM ( Select agents.city AS City, agents.country AS Country, count(agent_transactions.atx_id) 
AS Volume FROM agents INNER JOIN agent_transactions ON agents.agent_id = agent_transactions.agent_id 
where (agent_transactions.when_created > (NOW() - INTERVAL '1 week')) GROUP BY agents.country,agents.city) as atx_volume_summary_with_Country;

--#8 
SELECT transfers.kind AS Kind, wallets.ledger_location 
AS Country, sum(transfers.send_amount_scalar) 
AS Volume FROM transfers INNER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id 
where (transfers.when_created > (NOW() - INTERVAL '1 week')) GROUP BY wallets.ledger_location, transfers.kind;

--#9 
SELECT count(transfers.source_wallet_id) 
AS Unique_Senders, count(transfer_id) AS Transaction_count, transfers.kind AS Transfer_Kind, wallets.ledger_location AS Country, 
sum(transfers.send_amount_scalar) AS Volume FROM transfers INNER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id 
where (transfers.when_created > (NOW() - INTERVAL '1 week')) 
GROUP BY wallets.ledger_location, transfers.kind; 

--#10 
SELECT source_wallet_id, send_amount_scalar FROM transfers 
WHERE send_amount_currency = 'CFA' AND (send_amount_scalar>10000000) AND (transfers.when_created > (NOW() - INTERVAL '1 month'));