select e.nombre, p.fecha
from empleado e inner join pedido p on
e.idEmpleado = p.idEmpleado
order by p.fecha asc
limit 1;

select  g.idGimnasio ,count(*) as cuotasAnuales
from gimnasio g inner join socio s on
g.idGimnasio =s.idGimnasio
inner join pagos p on
p.idSocio = s.idSocio
where p.cantidadPago =335
group by g.idGimnasio ;

select p.descripcion
from producto p
inner join detalle_venta dv on
p.idproducto = dv.idproducto
inner join ventas v on 
dv.idventas = v.idventas
inner join socio s on 
v.idsocio = s.idsocio
where s.cuota = 'mensual'
group by p.idproducto
having count(*) > 50;

select e.nombre, e.tipoEmpleado, e.idGimnasio, g.direccion
from empleado e inner join gimnasio g on
g.idGimnasio = e.idGimnasio
where e.idJefe in(
select e2.idEmpleado
from empleado e2
where e2.nombre like 'pepe';

select concat(round(sum(p.precio),0), ' €') as "Total de ventas"
from producto p inner join detalle_venta dv on
p.idProducto =dv.idProducto inner join ventas v on
dv.idVentas =v.idVentas inner join socio s on
s.idSocio =v.idSocio
where  month (v.fecha) = 3 and year(v.fecha)=2023 and s.idGimnasio =2;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `mcfit`.`vista_empleados_jefe_pepe` AS
select
    `e`.`nombre` AS `nombre`,
    `e`.`tipoEmpleado` AS `tipoempleado`,
    `e`.`idGimnasio` AS `idgimnasio`,
    `g`.`direccion` AS `direccion`
from
    (`mcfit`.`empleado` `e`
join `mcfit`.`gimnasio` `g` on
    ((`g`.`idGimnasio` = `e`.`idGimnasio`)))
where
    `e`.`idJefe` in (
    select
        `e2`.`idEmpleado`
    from
        `mcfit`.`empleado` `e2`
    where
        (`e2`.`nombre` like 'pepe'));

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `mcfit`.`vista_total_ventas_2023_marzo` AS
select
    concat(round(sum(`p`.`precio`), 0), ' €') AS `Total de ventas`
from
    (((`mcfit`.`producto` `p`
join `mcfit`.`detalle_venta` `dv` on
    ((`p`.`idProducto` = `dv`.`idProducto`)))
join `mcfit`.`ventas` `v` on
    ((`dv`.`idVentas` = `v`.`idVentas`)))
join `mcfit`.`socio` `s` on
    ((`s`.`idSocio` = `v`.`idSocio`)))
where
    ((month(`v`.`fecha`) = 3)
        and (year(`v`.`fecha`) = 2023)
            and (`s`.`idGimnasio` = 2));

drop function if exists total_consumido;
delimiter $$
create function total_consumido(codCliente int)
returns varchar(100)
deterministic
begin
	declare total int default 0;
	declare resultado varchar(100);
set total =(
	select sum(p.precio)
	from producto p inner join detalle_venta dv on
	p.idProducto = dv.idProducto inner join ventas v on
	dv.idVentas = v.idVentas inner join socio s on
	v.idSocio = s.idSocio
	where s.idSocio = codCliente);
if (total is null) then
set resultado= concat('El socio ',codCliente, ' no ha realizado ninguna compra');
else
	set resultado= concat('El cliente ', codCliente, ' ha consumido ',total ,' €');
	end if;
return resultado;
end; $$
delimiter ;
select total_consumido(23);

delimiter $$
create function MediaPrecioPorVentaMensual(mes int, anio int) RETURNS decimal(10,2)
   DETERMINISTIC
begin
  declare precio decimal(10, 2);
  declare numVentas int ;
 declare total decimal(10,2);
   select sum(p.precio)into precio
   from ventas v inner join detalle_venta dv on
   v.idVentas = dv.idVentas inner join producto p on
   p.idProducto = dv.idProducto
   where month(v.fecha) = mes
   and year(v.fecha) = anio;
 
  select count(*) into numVentas
  from ventas v
  where month(v.fecha) = mes
  and year(v.fecha) = anio;
 set total= precio/numVentas;
   return total;
end
 $$
delimiter ;
select MediaPrecioPorVentaMensual (12,2023);

drop procedure if exists det_pedido;
delimiter $$
create procedure det_pedido(in codPedido int)
begin
	select p.descripcion , concat(p.precio, '€') , dp.cantProducto , concat((p.precio * dp.cantProducto ), ' €')as Subtotal
	from detalle_pedido dp inner join producto p on
	dp.idProducto =p.idProducto
	where dp.idPedido= codPedido;
end; $$
delimiter ;
call det_pedido (89);

drop procedure if exists total_consumido_cliente;
delimiter $$
create procedure total_consumido_cliente(in codcliente int)
begin
   declare nombre_cliente varchar(100);
   declare total_consumido_result varchar(100);
   select concat(nombre, ' ', apellido) into nombre_cliente
   from socio s
   where s.idsocio = codcliente;
   set total_consumido_result = total_consumido(codcliente);
   select concat('Datos del cliente : ', nombre_Cliente) as DatosCliente,
          total_consumido_result as TotalConsumido;
end $$
delimiter ;
call total_consumido_cliente (9);

drop procedure if exists mostrar_estadisticas_meses;
delimiter $$
create procedure mostrar_estadisticas_meses()
begin
	declare salida varchar(2000) default '';
	declare tot decimal (15,2);
	declare anio int;
declare mes varchar(100);
declare done bool default false;
declare c1 cursor for select  year(v.fecha),monthname(v.fecha) , sum(p.precio)
from detalle_venta dv inner join ventas v on
dv.idVentas = v.idVentas inner join producto p on
p.idProducto = dv.idProducto
group by year(v.fecha),monthname(v.fecha) ;
declare continue handler for not found set done = true;
set salida = concat(salida, '====ESTADISTICAS====\n');
set salida = concat(salida, '----Totales----\n');
set salida = concat(salida, 'Ventas totales:');
select sum(p.precio) into tot
from detalle_venta dv inner join producto p
on dv.idProducto = p .idProducto;
set salida=concat(salida,tot,'\n');
open c1;
while (not done) do
	fetch c1 into anio,mes,tot;
	if(not done) then
		set salida= concat(salida,'Año', anio,' Mes ',mes,': ',tot,'€\n');
	end if;
end while;
close c1;
select salida;
end $$
delimiter ;

create table HistorialEliminacion(
idCodigo int primary key auto_increment,
fecha date,
accion varchar (100),
idCliente int);
drop trigger if exists tr_del_cliente;
delimiter $$
create trigger tr_del_cliente
after delete on socio for each row
begin
	insert into historialeliminacion (fecha, accion, idCliente)
	values(now(), ' se ha eliminado', old.idSocio);
end $$
delimiter ;

drop trigger if exists regular_stock;
delimiter $$
create trigger regular_stock
 after insert on detalle_venta for each row
 BEGIN
 DECLARE idP int default 0;
 DECLARE cantidad int default 0;
 SET idp=new.idProducto;
 SET cantidad=new.cantProducto;
 UPDATE producto set stock=stock-cantidad  where idProducto =idP;
 end $$
delimiter ;
