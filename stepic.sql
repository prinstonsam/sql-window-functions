


-- Кумулятивное распределение
-- Возьмем зарплату каждого сотрудника и определим, какой процент людей получает столько же или меньше:
select
  name, salary,
  cume_dist() over w as perc
from employees
window w as (order by salary)
order by salary, id;

-- Относительный ранг
-- Зададимся похожим вопросом: какой процент людей получает строго меньше, чем конкретный сотрудник?
--
-- Ответить поможет функция percent_rank():

select name, salary,
       round((percent_rank() over w)::numeric, 2) as perc
from employees
window w as (order by salary);

-- Жаркий март
-- Есть таблица weather — это среднедневная температура в Лондоне за 6 месяцев 2020 года
-- Напишите запрос, который рассчитает cume_dist (cd) и percent_rank (pr) по температуре для всех дней марта, и вернет пять дней с самой высокой температурой:

use window_functions;
select wdate,
       wtemp,
       round(cume_dist() over w, 2) as cd,
       round(percent_rank() over w, 2) as pr
from weather
where month(wdate) = 3
window w as (order by wtemp)
limit 5;

-- Начало весны
-- Продолжаем работать с таблицей температур weather(wdate, wtemp) . Хотим для каждого из дней с 1 по 5 марта определить, какой процент дней в марте имеют такую же или меньшую температуру:
select
	wdate,
	wtemp,
	round(cume_dist() over w, 2) as perc,
	dense_rank() over w1 as n
from weather
where
month(wdate) = 3
window
    w as (order by wtemp),
    w1 as (order by wtemp)
order by wdate
limit 5;


