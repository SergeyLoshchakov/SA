Задачи с SQL-EX.ru

1) Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd

Select model, speed, hd from pc
where price < 500
-------------------------------------------------

2) Найдите производителей принтеров. Вывести: maker

Select distinct maker from product
where type = 'Printer'
-------------------------------------------------

3) Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.

Select model, ram, screen from laptop
where price > 1000
-------------------------------------------------

4) Найдите все записи таблицы Printer для цветных принтеров.

Select * from printer
where color = 'y'
-------------------------------------------------

5) Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.

Select model, speed, hd from pc
where price < 600 and (cd = '12x' or cd = '24x')
-------------------------------------------------

6) Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.

Select distinct maker, speed from laptop
join product
on laptop.model = product.model
where hd >= 10
-------------------------------------------------

7) Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).

Select l.model, price from product as p
join laptop as l
on p.model = l.model
where maker = 'B'

Union
Select pc.model, price from product as p
join pc
on p.model = pc.model
where maker = 'B'

Union
Select pr.model, price from product as p
join printer as pr
on p.model = pr.model
where maker = 'B'
-------------------------------------------------

8) Найдите производителя, выпускающего ПК, но не ПК-блокноты.

select maker from product
where type = 'PC'

except
select maker from product
where type = 'laptop'
-------------------------------------------------

9) Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker

Select distinct maker from product
join pc
on product.model = pc.model
where speed >= 450
-------------------------------------------------

10) Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price

Select model, price from printer
where price = (select max(price) from printer)
-------------------------------------------------

11) Найдите среднюю скорость ПК.

Select avg(speed) from pc
-------------------------------------------------

12) Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.

Select avg(speed) from laptop
where price > 1000
-------------------------------------------------

13) Найдите среднюю скорость ПК, выпущенных производителем A.

Select avg(speed) from pc
join product
on product.model = pc.model
where maker = 'A'
-------------------------------------------------

14) Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.

Select ships.class, name, country from ships
join classes
on ships.class = classes.class
where numGuns >= 10
-------------------------------------------------

15) Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD

Select hd from pc
group by hd
having count(hd) >= 2
-------------------------------------------------


17) Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
Вывести: type, model, speed

SELECT DISTINCT type, laptop.model, speed FROM laptop
JOIN product
ON product.model = laptop.model
WHERE speed < (SELECT MIN(speed) FROM pc)
-------------------------------------------------

18) Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price

SELECT DISTINCT maker, price FROM printer
JOIN product
ON printer.model = product.model
where printer.color = 'y' AND price = (SELECT MIN(price) FROM printer WHERE color = 'y')
-------------------------------------------------

19) Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
Вывести: maker, средний размер экрана.

SELECT maker, AVG(screen) from laptop
JOIN product
ON product.model = laptop.model
GROUP BY maker
-------------------------------------------------

20) Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.

SELECT maker, COUNT(maker) from product
WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(maker) > 2
-------------------------------------------------

21) Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.
Вывести: maker, максимальная цена.

Select maker, max(price) from pc
join product
on pc.model = product.model
group by maker
-------------------------------------------------

22) Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена.

Select speed, avg(price) as price_avg from pc
where speed > 600
group by speed
-------------------------------------------------

23) Найдите производителей, которые производили бы как ПК
со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
Вывести: Maker

SELECT maker FROM product
JOIN laptop
ON product.model = laptop.model
WHERE speed >= 750
INTERSECT
SELECT maker from product
JOIN pc
ON product.model = pc.model
WHERE speed >= 750
-------------------------------------------------

24) Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.

WITH X AS (
   SELECT product.model, price FROM product
   join pc
   ON product.model = pc.model
   UNION
   SELECT product.model, price FROM product
   JOIN laptop
   ON product.model = laptop.model
   UNION
   SELECT product.model, price FROM product
   JOIN printer
   ON product.model = printer.model) 
SELECT x.model FROM X
WHERE x.price = (SELECT max(x.price) FROM X)
-------------------------------------------------

25) Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

WITH X AS (
   SELECT DISTINCT maker, speed, ram FROM product
   JOIN pc
   ON product.model = pc.model
   WHERE ram = (SELECT MIN(ram) FROM pc) )

SELECT maker FROM X
WHERE x.speed = (SELECT MAX(x.speed) FROM X) AND maker IN
   (SELECT DISTINCT maker FROM product
    WHERE type = 'Printer')
-------------------------------------------------

26) Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена.

WITH X AS
(
SELECT pc.price FROM product
JOIN pc
ON product.model = pc.model
WHERE maker = 'A'
UNION ALL
SELECT laptop.price FROM product
JOIN laptop
ON product.model = laptop.model
WHERE maker = 'A'
)

SELECT AVG(price) FROM X
-------------------------------------------------

27) Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.

SELECT maker, AVG(hd) FROM product
JOIN pc
ON product.model = pc.model
GROUP BY maker
HAVING maker IN
(
  SELECT maker FROM product
  WHERE type = 'PC'
  INTERSECT
  SELECT maker FROM product
  WHERE type = 'Printer'
)
-------------------------------------------------

28) Используя таблицу Product, определить количество производителей, выпускающих по одной модели.

SELECT COUNT(maker) FROM
(
  SELECT maker FROM product
  GROUP BY maker
  HAVING COUNT(model) = 1
) X
-------------------------------------------------

29) В предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день [т.е. первичный ключ (пункт, дата)], написать запрос с выходными данными (пункт, дата, приход, расход). Использовать таблицы Income_o и Outcome_o.

SELECT t1.point, t1.date, inc, out from Income_o t1
LEFT JOIN Outcome_o t2
ON t1.point = t2.point AND t1.date = t2.date
UNION
SELECT t1.point, t1.date, inc, out from Outcome_o t1
LEFT JOIN Income_o t2
ON t1.point = t2.point AND t1.date = t2.date
-------------------------------------------------

30) В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз (первичным ключом в таблицах является столбец code), требуется получить таблицу, в которой каждому пункту за каждую дату выполнения операций будет соответствовать одна строка.
Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc). Отсутствующие значения считать неопределенными (NULL).

WITH
t1 AS (
   SELECT point, date, SUM(inc) as income from income
   group by point, date
   ),
t2 AS (
   SELECT point, date, SUM(out) as outcome from outcome
   group by point, date
   )
SELECT t1.point, t1.date, outcome, income FROM t1
LEFT JOIN t2
ON t1.point = t2.point AND t1.date = t2.date
UNION
SELECT t2.point, t2.date, outcome, income FROM t2
LEFT JOIN t1
ON t1.point = t2.point AND t1.date = t2.date
-------------------------------------------------

31) Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну.

SELECT class, country FROM Classes
WHERE Bore >= 16
-------------------------------------------------

32) Одной из характеристик корабля является половина куба калибра его главных орудий (mw). С точностью до 2 десятичных знаков определите среднее значение mw для кораблей каждой страны, у которой есть корабли в базе данных.

Select Country, ROUND(AVG(POWER(bore,3)/2), 2) as mw from classes
join ships
ON Classes.class = Ships.class
GROUP BY Country
-------------------------------------------------

33) Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.

SELECT ship FROM Outcomes
WHERE battle = 'North Atlantic' AND result = 'sunk'
-------------------------------------------------

34) По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей.

SELECT name FROM ships
JOIN classes ON classes.class = ships.class
WHERE type = 'bb' AND launched >= 1922 AND displacement > 35000
-------------------------------------------------

35) В таблице Product найти модели, которые состоят только из цифр или только из латинских букв (A-Z, без учета регистра).
Вывод: номер модели, тип модели.

SELECT model, type FROM product
WHERE model NOT LIKE '%[^0-9]%' or model NOT LIKE '%[^A-Z]%'
-------------------------------------------------

36) Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).

SELECT name FROM ships
JOIN classes on classes.class = ships.class
WHERE ships.name = classes.class
UNION
SELECT ship FROM outcomes
JOIN classes on classes.class = outcomes.ship

