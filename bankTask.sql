# 1 Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів
select * from client where length(FirstName) <6;

# 2 Вибрати львівські відділення банку
select * from department where DepartmentCity = 'Lviv';

# 3 Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
select * from client where Education ='high' order by LastName ASC;

# 4. +Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
select * from application order by idApplication DESC limit 5;

# 5. +Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
select * from client where LastName like '%ov' or LastName like '%ova';

# 6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.
select
    d.DepartmentCity,
    c.idClient,
    c.FirstName,
    c.Education,
    c.Passport,
    c.Age,
    c.City
from client c
join department d on d.idDepartment = c.Department_idDepartment
where d.DepartmentCity='Kyiv';

# 7. +Вивести імена клієнтів та їхні номера телефону (паспорт), погрупувавши їх за іменами.
select c.FirstName,
       c.Passport
from client c
group by c.FirstName;

# 8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
select *
from client
join application a on client.idClient = a.Client_idClient
where a.Sum >5000 and  a.CreditState='Not Returned';

# 9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
select count(idClient)
from client;

select count(idClient), d.DepartmentCity
from client c
join department d on d.idDepartment = c.Department_idDepartment
where idDepartment=2;

# 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
select
       MAX(Sum),
       c.FirstName,
       c.LastName
from application a
join client c on c.idClient = a.Client_idClient
group by Client_idClient;

# 11. Визначити кількість заявок на крдеит для кожного клієнта.
select
       COUNT(idApplication),
       c.FirstName,
       c.LastName
from application
join client c on c.idClient = application.Client_idClient
group by Client_idClient;

# 12. Визначити найбільший та найменший кредити.
select MAX(Sum), MIN(Sum) from application;

# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
select
       COUNT(idApplication),
       c.FirstName,
       c.LastName
from application
join client c on c.idClient = application.Client_idClient
where c.Education = 'high'
group by Client_idClient;

# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
select
    AVG(a.Sum) averageSum,
    c.idClient,
    c.FirstName,
    c.Education,
    c.Passport,
    c.Age,
    c.City
from client c
join application a on c.idClient = a.Client_idClient
group by a.Client_idClient
order by averageSum DESC limit 1;

# 15. Вивести відділення, яке видало в кредити найбільше грошей
select
       d.idDepartment,
       d.DepartmentCity,
       SUM(a.Sum) suma
from department d
join client c on d.idDepartment = c.Department_idDepartment
join application a on c.idClient = a.Client_idClient
group by idDepartment
order by suma DESC limit 1;

# 16. Вивести відділення, яке видало найбільший кредит.
select
       d.idDepartment,
       d.DepartmentCity,
       MAX(a.Sum)
from department d
join client c on d.idDepartment = c.Department_idDepartment
join application a on c.idClient = a.Client_idClient
group by idDepartment limit 1;

# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
update application
    set Sum = 6000
    where Client_idClient in(
        select idClient from  client where Education='high'
        );


# 18. Усіх клієнтів київських відділень пересилити до Києва.
update client
    set City = 'Kyiv'
    where Department_idDepartment=2 or Department_idDepartment=4;

# 19. Видалити усі кредити, які є повернені.
delete from application
where CreditState='Returned';


# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
delete
    from application
        where Client_idClient in
              (select idClient from client
              where
                    client.LastName like '_o%'
                 or client.LastName like '_a%'
                 or client.LastName like '_i%'
                 or client.LastName like' _y%'
                 or client.LastName like '_e%');

# Або
delete
    from application
        where Client_idClient in
              (select idClient from client
              where
                    client.LastName REGEXP '^[yeuoai]');

# 21 Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
select
       d.idDepartment,
       d.DepartmentCity,
       SUM(a.Sum) suma
from department d
join client c on d.idDepartment = c.Department_idDepartment
join application a on c.idClient = a.Client_idClient
where Department_idDepartment in (2,5)
group by idDepartment;


# Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
select *
from client c
join application a on c.idClient = a.Client_idClient
where a.Sum >= 5000 and a.CreditState = 'Returned';

/* Знайти максимальний неповернений кредит.*/
select MAX(a.Sum)
from application a
where a.CreditState ='Not returned';

/*Знайти клієнта, сума кредиту якого найменша*/
select
    c.FirstName,
    c.LastName,
    MIN(a.Sum)
from client c
join application a on c.idClient = a.Client_idClient
group by Client_idClient
order by MIN(a.Sum) limit 1;

/*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/
SELECT * FROM application
WHERE Sum > (SELECT avg(Sum) FROM application);

/*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/
SELECT  FirstName, LastName, City
FROM client c
    where c.City = (select City from client c
JOIN application a ON c.idClient = a.Client_idClient
GROUP BY Client_idClient
ORDER BY count(a.Client_idClient) desc
LIMIT 1);

#місто чувака який набрав найбільше кредитів
SELECT count(a.Client_idClient), FirstName, LastName, City
FROM client c
JOIN application a ON c.idClient = a.Client_idClient
GROUP BY Client_idClient
ORDER BY count(a.Client_idClient) desc
LIMIT 1;