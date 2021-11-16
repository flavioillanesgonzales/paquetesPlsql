--Demo- Instalar paquetes utl-mail,smtp-prvt (Para poder envar correos mediante PL-SQL).
--connect as sysdba
-- @?/rdbms/admin/utlmail.sql
--@?/rdbms/admin/utlsmtp.sql
--@?/rdbms/admin/prvtmail.plb

alter system set smtp_out_server='localhost';

--Crear rol 
Create ROLE ACL_ADMIN;
grant Create session to ACL_ADMIN;
grant execute on utl_mail to ACL_ADMIN;
grant execute on utl_smtp to ACL_ADMIN;

--alterar la zona horariaa America
alter session set NLS_TERRITORY='AMERICA';

--Comprobamos
SELECT SYSTIMESTAMP FROM DUAL;

--Creamos el ACL
BEGIN
DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
acl => 'acl_mail.xml',
description => 'Permisos para el mail',
principal => 'ACL_ADMIN',
is_grant => TRUE,
privilege => 'connect',
start_date => SYSTIMESTAMP,
end_date => NULL);
COMMIT;
END;
/

begin
DBMS_NETWORK_acl_ADMIN.ADD_PRIVILEGE(
acl => 'acl_mail.xml',
principal => 'ACL_ADMIN',
is_grant => true,
privilege => 'resolve'
);
COMMIT;
END;
/

BEGIN
DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
acl => 'acl_mail.xml',
host => '*');
COMMIT;
END;
/

--Comprobamos
select acl , host , lower_port , upper_port from DBA_NETWORK_ACLS;
select acl , principal , privilege , is_grant from DBA_NETWORK_ACL_PRIVILEGES;

--Condemos el permiso
grant ACL_ADMIN to SYS;
grant ACL_ADMIN to PUBLIC;

--////////////////



set serveroutput on size 10000;

BEGIN
UTL_MAIL.SEND(sender => 'alonso1557@hotmail.com',
recipients => 'faigalonso@gmail.com',
subject => 'Hola a todos!!',
message => 'Espero que les haya gustado mi Demo, me costó mucho hacerlo uu:,,,,)');
EXCEPTION
WHEN OTHERS THEN
RAISE_APPLICATION_ERROR(-20001,'The following error has occured:' ||sqlerrm);
END;

--//////////////////////////////

