create table usuario(
usu_id serial unique not null,
usu_nombre1 varchar(50) not null,
usu_nombre2 varchar(50),
usu_apellido1 varchar(50) not null,
usu_apellido2 varchar(50),
usu_fecha_nacimiento date not null,
usu_correo varchar(50) not null unique,
usu_foto_perfil bytea,
usu_telefono varchar(50) not null,
usu_api_key varchar(200),
usu_fk_cuidador integer,
usu_fk_owner integer,
Constraint pk_id_usu primary key (usu_id),
Constraint fk_cuidador_usuario foreign key (usu_fk_cuidador) references Cuidador(cui_id),
Constraint fk_owner_usuario foreign key (usu_fk_owner) references Owner(own_id)
);

alter table owner 
drop column own_nombre1,
drop column own_nombre2,
drop column own_apellido1,
drop column own_apellido2,
drop column own_fecha_nacimiento,
drop column own_correo,
drop column own_foto_perfil,
drop column own_telefono,
drop column own_api_key;

alter table cuidador
drop column cui_nombre1,
drop column cui_nombre2,
drop column cui_apellido1,
drop column cui_apellido2,
drop column cui_fecha_nacimiento,
drop column cui_correo,
drop column cui_foto_perfil,
drop column cui_telefono,
drop column cui_api_key;

drop table usu_acc;
drop table call_center;

create table call_center(
cal_id serial not null unique,
cal_nombre varchar(50) not null,
cal_apellido varchar(50) not null,
cal_fecha_nacimiento date not null,
cal_correo varchar(50) not null unique,
cal_telefono varchar(15) not null,
cal_password varchar(50) not null,
cal_tipo_usuario varchar(10) not null,
Constraint pk_id_call_center primary key (cal_id),
Constraint check_tipo_usuario check(cal_tipo_usuario IN ('supervisor','operador'))
);

create table usu_acc(
usc_id serial not null unique,
usc_fk_accion serial not null,
usc_fk_cuidador integer,
usc_fk_owner integer,
usc_fk_call_center integer,
usc_fecha_ejecucion date not null,
Constraint pk_id_usu_acc primary key (usc_id),
Constraint fk_accion_usu_acc foreign key (usc_fk_accion) references Accion(acc_id),
Constraint fk_cuidador_usu_acc foreign key (usc_fk_cuidador) references Cuidador(cui_id),
Constraint fk_owner_usu_acc foreign key (usc_fk_owner) references Owner(own_id),
Constraint fk_call_center_usu_acc foreign key (usc_fk_call_center) references Call_center(cal_id)
);
