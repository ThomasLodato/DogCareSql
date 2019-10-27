--------------------------------DROPS--------------------------------------
drop table if exists Formacion;
drop table if exists Cui_ext_ser;
drop table if exists Ser_ext;
drop table if exists Cui_ext;
drop table if exists Ser_est;
drop table if exists Hist_pago;
drop table if exists Tdc;
drop table if exists Intercambio;
drop table if exists Estatus;
drop table if exists Calificacion;
drop table if exists Servicio;
drop table if exists Usu_acc;
drop table if exists Extra;
drop table if exists Horario;
drop table if exists Perro;
drop table if exists Call_center;
drop table if exists Owner;
drop table if exists Cuidador;
drop table if exists Usuario;
drop table if exists Accion;
drop table if exists Uso;
drop table if exists Tarea;
drop table if exists Lugar;
drop table if exists Raza;

-------------------------------CREATES-------------------------------------

Create table Raza(
raz_id serial not null unique,
raz_nombre varchar(50) not null,
Constraint pk_id_raza primary key (raz_id)
);

Create table Lugar(
lug_id serial unique,
lug_nombre varchar(50) not null,
lug_tipo varchar(20) not null,
lug_fk_lugar integer,
Constraint pk_id_lugar primary key (lug_id),
Constraint fk_lugar_lugar foreign key (lug_fk_lugar) references Lugar(lug_id),
Constraint check_tipo_lugar check (lug_tipo IN('estado','municipio','parroquia'))
);

Create table Tarea(
tar_id serial unique,
tar_nombre varchar(200) not null,
Constraint pk_id_tarea primary key (tar_id)
);

Create table Accion(
acc_id serial not null unique,
acc_nombre varchar(50) not null,
Constraint pk_id_accion primary key (acc_id)
);

Create table Usuario(
usu_id serial not null unique,
usu_nombre1 varchar(50) not null,
usu_nombre2 varchar(50) not null,
usu_apellido1 varchar(50) not null,
usu_apellido2 varchar(50) not null,
usu_fecha_nacimiento date not null,
usu_correo varchar(50) not null unique,
usu_foto_perfil varchar(100),
usu_telefono varchar(50) not null,
usu_fk_lugar integer not null,
usu_api_key varchar(200),
usu_tipo varchar(10) not null,
Constraint pk_id_usuario primary key (usu_id),
Constraint fk_lugar_usuario foreign key (usu_fk_lugar) references Lugar(lug_id),
Constraint check_tipo_usuario check(usu_tipo IN ('cuidador','owner'))
);

Create table Cuidador(
cui_id serial not null unique,
cui_capacidad_maxima integer not null,
cui_tarifa_diaria real not null,
cui_biografia varchar(150) not null,
cui_fk_usuario integer not null unique,
Constraint pk_id_cuidador primary key (cui_id),
Constraint fk_usuario_cuidador foreign key (cui_fk_usuario) references Usuario(usu_id)
);

Create table Owner(
own_id serial not null unique,
own_fk_usuario integer not null unique,
Constraint pk_id_owner primary key (own_id),
Constraint fk_usuario_owner foreign key (own_fk_usuario) references Usuario(usu_id)
);

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

Create table Perro(
per_id serial not null unique,
per_nombre varchar(50) not null,
per_microchip varchar(2) not null,
per_color varchar(50) not null,
per_peso real not null,
per_fecha_nacimiento date not null,
per_altura real not null,
per_referencia varchar(200),
per_fk_raza integer not null,
per_fk_tarea integer,
per_fk_owner integer not null,
Constraint pk_id_perro primary key (per_id),
Constraint fk_raza_perro foreign key (per_fk_raza) references Raza(raz_id),
Constraint fk_owner_perro foreign key (per_fk_owner) references Owner(own_id),
Constraint fk_tarea_perro foreign key (per_fk_tarea) references Tarea(tar_id),
Constraint check_microchip_perro check(per_microchip IN('si','no'))
);

Create table Horario(
hor_id serial not null unique,
hor_fecha_inicio date not null,
hor_fecha_fin date not null,
hor_fk_cuidador integer not null,
Constraint pk_id_horario primary key (hor_id),
Constraint fk_cuidador_horario foreign key (hor_fk_cuidador) references Cuidador(cui_id)
);

Create table Extra(
ext_id serial not null unique,
ext_nombre varchar(100) not null,
Constraint pk_id_extra primary key (ext_id)
);

Create table Cui_ext(
cxt_id serial not null unique,
cxt_fk_extra integer not null,
cxt_fk_cuidador integer not null,
cxt_precio real not null,
Constraint pk_id_cui_ext primary key (cxt_id),
Constraint fk_extra_cui_ext foreign key (cxt_fk_extra) references Extra(ext_id),
Constraint fk_cuidador_cui_ext foreign key (cxt_fk_cuidador) references Cuidador(cui_id)
);
									   							   
Create table Usu_acc(
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

Create table Servicio(
ser_id serial not null unique,
ser_fecha_inicio date not null,
ser_fecha_fin date not null,
ser_fk_owner integer not null,
ser_fk_cuidador integer not null,
Constraint pk_id_servicio primary key (ser_id),
Constraint fk_owner_servicio foreign key (ser_fk_owner) references Owner(own_id),
Constraint fk_cuidador_servicio foreign key (ser_fk_cuidador) references Cuidador(cui_id)
);

Create table Calificacion(
clf_id serial not null unique,
clf_puntuacion integer not null,
clf_comentario varchar(200) not null,
clf_fk_servicio integer not null,
Constraint pk_id_calificacion primary key (clf_id),
Constraint fk_servicio_calificacion foreign key (clf_fk_servicio) references Servicio(ser_id)
);

Create table Cui_ext_ser(
cxs_id serial not null unique,
csx_fk_cui_ext integer not null,
csx_fk_servicio integer not null,
Constraint pk_id_cui_ext_ser primary key (cxs_id),
Constraint fk_cui_ext_csx foreign key (csx_fk_cui_ext) references Cui_ext(cxt_id),
Constraint fk_servicio_csx foreign key (csx_fk_servicio) references Servicio(ser_id)
);
		
Create table Estatus(
est_id serial not null unique,
est_nombre varchar(50) not null,
Constraint pk_id_estatus primary key (est_id)
);

Create table Intercambio(
int_id serial not null unique,
int_descripcion varchar(200) not null,
Constraint pk_intercambio primary key (int_id)
);

Create table Tdc(
tdc_id serial not null unique,
tdc_codigo_seguridad varchar(50) not null unique,
tdc_banco varchar(30) not null,
tdc_tipo varchar(20) not null,
tdc_fecha_vencimiento date not null,
tdc_fk_owner integer not null,
Constraint fk_tdc_owner foreign key (tdc_fk_owner) references Owner(own_id)
);

Create table Hist_pago(
his_fecha_pago date not null,
his_monto_total real not null,
his_fk_servicio integer not null,
Constraint fk_servicio_hist_pago foreign key (his_fk_servicio) references Servicio(ser_id)
); 

Create table Ser_est(
set_id serial not null unique,
set_fecha_cambio date not null,
set_fk_servicio integer not null,
set_fk_estatus integer not null,
Constraint pk_ser_est primary key (set_id),
Constraint fk_servicio_ser_est foreign key (set_fk_servicio) references Servicio(ser_id),
Constraint fk_estatus_ser_est foreign key (set_fk_estatus) references Estatus(est_id)
);

Create table Formacion(
for_id serial not null unique,
for_fk_tarea integer not null,
for_fk_perro integer not null,
Constraint pk_formacion primary key (for_id),
Constraint fk_tarea_formacion foreign key (for_fk_tarea) references Tarea(tar_id),
Constraint fk_perro_formacion foreign key (for_fk_perro) references Perro(per_id)
);
