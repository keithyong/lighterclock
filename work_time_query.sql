select s.time_sheet_id, sum(work_time) from (
    select *, time - lag(time)
    over (partition by username order by time) as work_time
    from punch
    join time_sheet on punch.time_sheet_id=time_sheet.id
) as s
where type='out'
group by s.time_sheet_id;
