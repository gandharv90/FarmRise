-----------------------------------------------------------------------------------
--1) Average time between first visit and first purchase across users
-----------------------------------------------------------------------------------

Select avg(first_txn - first_visit) as average
from
    (Select user_id, min(time) as first_txn
    from txn 
    group by 1) as t
left join
    (Select user_id, min(time) as first_visit
    from evnt 
    where event_name ='visit'
    group by 1) as e
on e.user_id = t.user_id
where first_visit is not null;

-----------------------------------------------------------------------------------
--2) Median and 80 percentile time between first visit and first purchase across users.
-----------------------------------------------------------------------------------

Select 
percentile_disc(0.5) within group (order by first_txn - first_visit) as median,
percentile_disc(0.8) within group (order by first_txn - first_visit desc) as top_percentile_80
from
    (Select user_id, min(time) as first_txn
    from txn 
    group by 1) as t
left join
    (Select user_id, min(time) as first_visit
    from evnt 
    where event_name ='visit'
    group by 1) as e
on e.user_id = t.user_id
where first_visit is not null;


-----------------------------------------------------------------------------------
--3) Average time between first visit and purchase per item_id.
-----------------------------------------------------------------------------------
Select item_id, avg(first_txn - first_visit) as average
from
    (Select user_id,item_id, min(time) as first_txn
    from txn 
    group by 1,2) as t
left join
    (Select user_id, min(time) as first_visit
    from evnt 
    where event_name ='visit'
    group by 1) as e
on e.user_id = t.user_id
where first_visit is not null
group by 1;



-----------------------------------------------------------------------------------
--4) Median and 80 percentile time between first visit and purchase item per item_id.
-----------------------------------------------------------------------------------

Select item_id,
percentile_disc(0.5) within group (order by first_txn - first_visit) as median,
percentile_disc(0.8) within group (order by first_txn - first_visit desc) as top_percentile_80
from
    (Select user_id,item_id, min(time) as first_txn
    from txn 
    group by 1,2) as t
left join
    (Select user_id, min(time) as first_visit
    from evnt 
    where event_name ='visit'
    group by 1) as e
on e.user_id = t.user_id
where first_visit is not null
group by 1;




----------------------------------------------------------------------------------
-- 5) Given an item_id [consider item_id ‘shoe_01’], retrieve an ordered list of
--    items that are most likely to be purchased by a user who purchased the item
-----------------------------------------------------------------------------------


select t1.item_id as item , t2.item_id as item_most_common , count(*) as counts
from txn as t1 left join txn as t2 on t1.user_id = t2.user_id
where t1.item_id != t2.item_id  

---------------------------
------enter item id here---

and t1.item_id = 'A'

---------------------------
group by 1,2
order by 1,3 desc
