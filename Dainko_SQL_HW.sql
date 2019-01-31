use sakila;
 
select * 
from actor; 
 
-- 1a.
select first_name, last_name 
from actor;

-- 1b.  
select concat(first_name, ' ', last_name) as 'Actor Name'
from actor
;

-- 2a. 
select *
from actor
where first_name like 'Joe%'
;

-- 2b.
select *
from actor
where last_name like '%g%' 
or '%e%' 
or '%n%';

-- 2c.
select *
from actor
where last_name like '%l%'
or '%i%'
order by last_name, first_name asc
;

-- 2d.
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China')
;

-- 3a.
alter table actor
	add description blob
;

-- 3b.
alter table actor
	drop description
;
-- 4a.
select last_name, count(first_name) as Total
from actor
group by last_name
;

-- 4b. 
select last_name, count(first_name) as Total
from actor
group by last_name
having count(first_name) > 1
;

-- 4c.
update actor
set first_name = 'HARPO', last_name = 'WILLIAMS'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS'
;

-- 4d.
update actor
set first_name = 'GROUCHO'
where first_name = 'HARPO' and last_name = 'WILLIAMS'
;

-- 5a.
create table address(
	address_id int auto_increment,
    address varchar(100) not null,
    address2 varchar(100),
    district varchar(100) not null,
    city_id int,
    postal_code int,
    phone int,
    location blob,
    last_update int,
    primary key(address_id)
)
;

-- 6a.
select staff.first_name,
	staff.last_name,
	address.address 
from address
	inner join staff on
    staff.address_id=address.address_id;

-- 6b.
select staff.first_name,
	staff.last_name,
    sum(payment.amount)
from payment
	inner join staff on
    staff.staff_id=payment.staff_id
where payment_date 
	between '2005-08-01 00:00:00' and '2005-08-31 23:59:59'
group by first_name, last_name
;

-- 6c.
select film.title,
	count(film_actor.actor_id) as Actor_count
from film_actor
	inner join film on
    film.film_id=film_actor.actor_id
group by title
;

-- 6d.
select count(title) as Hunchback_Impossible
from film
	inner join inventory on
    film.film_id=inventory.film_id
where title='Hunchback Impossible'
;

-- 6e.
select customer.first_name,
	customer.last_name,
    sum(payment.amount) as Total_Amount_Paid
from payment
	inner join customer on
    customer.customer_id=payment.customer_id
group by first_name, last_name
order by last_name asc
;

-- 7 a.
select title
from film
where title like 'Q%' or 'K%' and 
language_id in (
	select language_id
    from `language`
    where name in (
		select `name`
		from `language`
        where `name` = 'English' 
)
)
;

-- 7 b.
select first_name, last_name
from actor
where actor_id in (
	select actor_id
    from film_actor
    where film_id in (
		select film_id
        from film
        where title = 'Alone Trip'
  )  
)
;

-- 7 c.
select cu.first_name, cu.last_name, cu.email
from customer cu
join address a
	on (cu.address_id=a.address_id)
join city ci
	on (a.city_id=ci.city_id)
join country co
	on (ci.country_id=co.country_id)
where co.country='Canada'
;

-- 7 d.
select title
from film
where film_id in (
	select film_id
    from film_category
    where category_id in (
		select category_id
        from category
        where `name` = 'Family'
    )
)
;

-- 7 e.
select title, count(r.inventory_id) as Number_of_Rents
from film f, inventory i, rental r
where f.film_id=i.film_id and i.inventory_id=r.inventory_id
group by title
order by Number_of_Rents desc
;

-- 7 f.
select a.address, sum(p.amount) as `Total_Busine$$` 
from address a, 
	store s, 
    customer c, 
    payment p
where a.address_id=s.address_id and 
	s.store_id=c.store_id and 
    c.customer_id=p.customer_id
group by a.address
;

-- 7 g.
select s.store_id, ci.city, co.country
from store s, address a, city ci, country co
where s.address_id=a.address_id and a.city_id=ci.city_id and ci.country_id=co.country_id
;

-- 7 h.
select c.name, sum(p.amount) as Total_Grossing
from category c, 
	film_category fc, 
	inventory i, 
    rental r, 
	payment p
where c.category_id=fc.category_id and
	fc.film_id=i.film_id and
    i.inventory_id=r.inventory_id and
    r.rental_id=p.rental_id
group by c.name
order by Total_Grossing desc 
limit 5
;    

-- 8 a.
create view Top_5_Grossing_Genres as 
select c.name, sum(p.amount) as Total_Grossing
from category c, 
	film_category fc, 
	inventory i, 
    rental r, 
	payment p
where c.category_id=fc.category_id and
	fc.film_id=i.film_id and
    i.inventory_id=r.inventory_id and
    r.rental_id=p.rental_id
group by c.name
order by Total_Grossing desc 
limit 5
;
 
-- 8 b.
select * 
from Top_5_Grossing_Genres
;

-- 8 c.
drop view Top_5_Grossing_Genres
;
