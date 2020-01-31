USE sakila;

-- display first and last name of all actors
select first_name, last_name from actor;

-- display fist/last name and capitalized in asingle column
select CONCAT(first_name, ' ', last_name)
AS 'Actor Name' from actor;

-- find ID #, first, last name of 'Joe'
select actor_id, first_name, last_name from actor a
where a.first_name = 'Joe';

-- all actors whose last name contain sunstring 'GEN'
select actor_id, first_name, last_name from actor a
where a.last_name like '%gen%';

-- all actors whose last name contain sunstring 'LI'
-- ordered by last name and then first name
select actor_id, first_name, last_name from actor a
where a.last_name like '%li%'
order by last_name, first_name;

-- display country id and country for chosen countries
-- use 'in' function
select country_id, country from country 
where country in ('Afghanistan', 'Bangladesh', 'China');

-- create description columns into actor 
ALTER TABLE actor ADD description BLOB;

-- delete description columns
ALTER TABLE actor DROP description;

-- list of last names and how many pactors have that last name
select last_name, count(last_name) as 'ocurrences' from actor a
group by last_name;

-- list of last names shared by at least 2 actors
select last_name, count(last_name) as 'ocurrences' from actor
group by last_name
having count(last_name) > 1;

-- change grouchos name must include last name
-- because groucho inf first name is not unique
update actor set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'Williams';

-- change it back to groucho
update actor set first_name = 'GROUCHO'
where first_name = 'HARPO' and last_name = 'Williams';

-- use query to recreate address schema
-- i think this is wrong
SHOW CREATE TABLE address;

-- join staff and address to display people
select  first_name, last_name, a.address
from staff s
JOIN  address a
on s.address_id = a.address_id; 


-- dsiplay total amount rung up by each staff member
select first_name, last_name, count(p.amount)
as 'Transaction volume'
from staff s
join payment p 
on s.staff_id = p.staff_id
group by s.staff_id;
 
-- lists of film and number of actors in film
select title, COUNT(a.film_id) as 'number of actors'
 from film f
 inner join film_actor a
 on f.film_id = a.film_id
 group by title;
 
 -- copies of hunchback impossible
 select title, count(i.film_id) as 'number of copies'
 from film f 
 inner join inventory i
 where f.film_id = i.film_id 
 and title = 'Hunchback Impossible';
 
 -- total amount paid by each customer
 select CONCAT(first_name, ' ', last_name) as 'name',
 count(p.amount) as 'total paid by customer'
from customer c
join payment p 
on c.customer_id = p.customer_id
group by name
order by last_name, first_name;

-- movies starting with K or Q
select title from film
where (title like 'K%' 
or title like 'Q%');

-- actors that appear in Alone Trip
select CONCAT(first_name, ' ', last_name)
	as 'Actors in \n Alone Trip'
from actor where actor_id in
(select  actor_id from film_actor fa
where film_id in (select film_id from film f
where title = 'Alone Trip'));


-- Canadian customers
select CONCAT(first_name, ' ', last_name) as 'name', email
from customer c
join address a 
where a.district = 'Alberta'
group by name; -- to remove duplicates

-- family films 
select title as 'Family Films' from film f
join film_category fc
where f.film_id = fc.film_id
and fc.category_id = (select category_id from category where name = 'Family');

-- most frequently rented movies in descending order
(select film_id, count(i.film_id) as 'Amnt of times Rented'
from rental r join inventory i
where r.inventory_id = i.inventory_id
group by film_id)
order by count(i.film_id) DESC;

-- total business by store
select s.store_id, count(p.amount) as 'total by store' 
from payment p 
join staff s on p.staff_id = s.staff_id
group by s.staff_id;

-- display store ID , city, country  ** bonus address :D
select s.store_id, a.address ,c.city, cu.country
from store s
join address a on s.address_id = a.address_id
join city c on a.city_id = c.city_id
join country cu on c.country_id = cu.country_id ; 

-- top five genres in gross revenue
select 
	ca.name, 
    count(p.amount) as 'total by genre ($)'
from 
	category ca
join 
	film_category fc on ca.category_id = fc.category_id
join
	inventory i on fc.film_id = i.film_id
join 
	rental r on  i.inventory_id = r.inventory_id
join 
	payment p on r.rental_id = p.rental_id
group by ca.name
order by count(p.amount) DESC
limit 5; 

-- create a view of top 5 genres
CREATE VIEW sakila.top_5
AS
select 
	ca.name, 
    count(p.amount) as 'total_by_genre_($)'
from category ca
join 
	film_category fc on ca.category_id = fc.category_id
join 
	inventory i on fc.film_id = i.film_id
join 
	rental r on  i.inventory_id = r.inventory_id
join 
	payment p on r.rental_id = p.rental_id
group by ca.name
order by count(p.amount) DESC
limit 5; 

-- display the view
select *
from sakila.top_5;

-- delete the view
DROP VIEW IF EXISTS
    sakila.top_5;


