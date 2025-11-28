create database aql_practice_1;

select * from ds_salaries;

# 1. Cek data yang NULL
select *
from ds_salaries
where work_year is null
or experience_level is null
or employment_type is null
or job_title is null
or salary is null
or salary_currency is null
or salary_in_usd is null
or employee_residence is null
or remote_ratio is null
or company_location is null
or company_size is null;

# 2. Cek job title nya apa saja
select distinct job_title
from ds_salaries
order by job_title;

# 3. Job Title yang berkaitan dengan data analyst
select distinct job_title
from ds_salaries
where job_title like "%data analyst%"
order by job_title;

# 4. Rata-rata gaji data analyst
select (avg(salary_in_usd) * 16000) /12
as average_salary_rupiah from ds_salaries;

# 5. Berapa rata-rata gaji data analyst berdasarkan experience level

select experience_level, employment_type,
(avg(salary_in_usd) * 16000) /12 as average_salary_rupiah_monthly
from ds_salaries
group by experience_level, employment_type
order by experience_level, employment_type;

# 6. Negara dengan gaji yang menarik untuk posisi data analyst, full time.
select company_location,
	avg(salary_in_usd) as avg_sal_in_usd
from ds_salaries
where job_title like "%data analyst%"
	and employment_type = "FT"
    and experience_level in ("MI","EN")
group by company_location;

# 7. Di tahun keberapa kenaikan gaji dari mid ke senior itu memiliki kenaikan yang tertinggi
# untuk pekerjaan yang berkaitan dengan data analyst dan employment type full time. 
with ds_1 as (
	select work_year,
		avg(salary_in_usd) as sal_in_usd_ex
	from ds_salaries
    where
		employment_type = "FT"
        and experience_level = "EX"
        and job_title like "%data analyst%"
	group by work_year
),ds_2 as (
	select work_year,
	avg(salary_in_usd) as sal_in_usd_mi
	from ds_salaries
    where
		employment_type = "FT"
        and experience_level = "MI"
        and job_title like "%data analyst%"
	group by work_year
) select ds_1.work_year,
	ds_1.sal_in_usd_ex,
    ds_2.sal_in_usd_mi,
    ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mi as increase
from ds_1
left join ds_2
	on ds_2.work_year = ds_2.work_year;