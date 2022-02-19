--4
create table PROGRAM (
cod_program number(2),
ora_deschidere varchar2(6),
ora_inchidere varchar2(6),
constraint program_cod_pk primary key (cod_program),
constraint program_in_des_ck check(ora_inchidere>ora_deschidere)
);

create table ADRESA (
cod_adresa number(4),
strada varchar2(30) constraint null_strada not null,
numar number(3) constraint null_numar not null,
oras varchar2(30) constraint null_oras not null,
judet varchar2(30),
constraint adresa_cod_pk primary key (cod_adresa)
);

create table RESTAURANT (
cod_restaurant number(4),
nume_restaurant varchar2(30) constraint null_nume_res not null,
capacitate number(4),
cod_adresa number(4),
cod_program number(2),
constraint restaurant_cod_pk primary key (cod_restaurant),
constraint fk_res_adresa foreign key (cod_adresa) references ADRESA(cod_adresa),
constraint fk_res_program foreign key (cod_program) references PROGRAM(cod_program)
);

create table TIP_EVENIMENT (
cod_tip number(2),
descriere varchar2(30) constraint null_descriere not null,
constraint tip_pk primary key (cod_tip)
);

create table EVENIMENT (
cod_eveniment number(4),
data_eveniment date,
nr_maxim_persoane number(4),
cod_tip number(2),
constraint eveniment_cod_pk primary key (cod_eveniment),
constraint fk_ev_tip foreign key (cod_tip) references TIP_EVENIMENT(cod_tip)
);

create table REALIZEAZA (
cod_restaurant number(4),
cod_eveniment number(4),
constraint real_pk primary key (cod_restaurant, cod_eveniment),
constraint fk_real_res foreign key (cod_restaurant) references RESTAURANT(cod_restaurant),
constraint fk_real_ev foreign key (cod_eveniment) references EVENIMENT(cod_eveniment)
);

create table FACILITATE (
cod_tip number(2),
cod_facilitate number(2),
denumire varchar2(50),
constraint facilitati_pk primary key (cod_tip, cod_facilitate),
constraint fk_fac_tip foreign key (cod_tip) references TIP_EVENIMENT(cod_tip)
);

create table JOB (
cod_job number(4),
nume_job varchar2(35) constraint null_nume_job not null,
salariu_minim number(6),
salariu_maxim number(6),
constraint job_pk primary key (cod_job)
);

create table ANGAJAT (
cod_angajat number(4),
nume_angajat varchar2(25) constraint null_nume_ang not null,
prenume_angajat varchar2(25),
email varchar2(25) constraint null_email not null,
nr_telefon varchar2(15) constraint null_nr_tel not null,
salariu number(8,2),
data_angajare date default sysdate,
comision number(2,2),
cod_sef number(4),
cod_restaurant number(4),
cod_job number(4) constraint null_fk_job not null,
constraint ang_pk primary key (cod_angajat),
constraint fk_ang_ang foreign key (cod_sef) references ANGAJAT(cod_angajat),
constraint fk_ang_res foreign key (cod_restaurant) references RESTAURANT(cod_restaurant),
constraint fk_ang_job foreign key (cod_job) references JOB(cod_job),
constraint unq_nume_prenume unique (nume_angajat,prenume_angajat),
constraint unq_email unique (email),
constraint unq_nr_tel unique (nr_telefon),
constraint ck_sal check (salariu>0)
);

create table ISTORIC_JOB (
cod_angajat number(4),
data_start date default sysdate,
data_final date,
cod_job number(4) constraint null_job_istoric not null,
constraint istoric_job_pk primary key (cod_angajat, data_start),
constraint fk_istoric_job foreign key (cod_job) references JOB(cod_job),
constraint fk_istoric_ang foreign key (cod_angajat) references ANGAJAT(cod_angajat)
);

create table REZERVARE (
cod_rezervare number(6),
data_rezervare date default sysdate,
nr_persoane number(3),
constraint rez_pk primary key (cod_rezervare)
);

create table COMANDA (
cod_comanda number(4),
tip_plata varchar2(20),
valoare number(8,2),
data_comanda date,
cod_restaurant number(4),
cod_angajat number(4),
constraint pk_comanda primary key (cod_comanda),
constraint fk_comanda_res foreign key (cod_restaurant) references RESTAURANT(cod_restaurant),
constraint fk_comanda_ang foreign key (cod_angajat) references ANGAJAT(cod_angajat)
);

create table CLIENT (
cod_client number(4),
nume_client varchar2(25) constraint null_nume_client not null,
prenume_client varchar2(25),
telefon varchar2(15) constraint null_telefon_client not null,
cod_adresa number(4),
cod_comanda number(4),
constraint client_pk primary key (cod_client),
constraint unq_nume_prenume_cl unique (nume_client,prenume_client),
constraint fk_cl_adresa foreign key (cod_adresa) references ADRESA(cod_adresa),
constraint fk_cl_comanda foreign key (cod_comanda) references COMANDA(cod_comanda),
constraint unq_tel unique (telefon)
);

create table FACE (
cod_client number(4),
cod_rezervare number(6),
cod_eveniment number(4),
cod_restaurant number(4),
constraint face_pk primary key (cod_client, cod_rezervare, cod_eveniment, cod_restaurant),
constraint fk_face_client foreign key (cod_client) references CLIENT(cod_client),
constraint fk_face_rez foreign key (cod_rezervare) references REZERVARE(cod_rezervare),
constraint fk_face_ev foreign key (cod_eveniment) references EVENIMENT(cod_eveniment),
constraint fk_face_res foreign key (cod_restaurant) references RESTAURANT(cod_restaurant)
);

create table ISTORIC_COMANDA (
cod_client number(4),
data_plasare date default sysdate,
nota_oferita number(2),
cod_comanda number(4) constraint null_comanda_istoric not null,
constraint istoric_comanda_pk primary key (cod_client, data_plasare),
constraint fk_istoric_comanda foreign key (cod_comanda) references COMANDA(cod_comanda),
constraint fk_istoric_cl foreign key (cod_client) references CLIENT(cod_client)
);


create table PREPARAT (
cod_preparat number(4),
nume_preparat varchar2(25) constraint null_preparat not null,
pret number(8,2) constraint null_pret not null,
constraint pk_preparat primary key (cod_preparat)
);

create table CUPRINDE (
cod_preparat number(4),
cod_comanda number(4),
cantitate number(2) constraint null_cantitate not null,
constraint pk_cuprinde primary key (cod_preparat, cod_comanda),
constraint fk_cup_prep foreign key (cod_preparat) references PREPARAT(cod_preparat),
constraint fk_cup_com foreign key (cod_comanda) references COMANDA(cod_comanda)
);

commit;

--5
insert into PROGRAM
values (1,'08:00','22:00');

insert into PROGRAM
values (2,'08:30','21:30');

insert into PROGRAM
values (3,'07:00','20:00');

insert into PROGRAM
values (4,'07:30','22:30');

insert into PROGRAM
values (5,'08:00','23:00');

commit;

insert into ADRESA
values (8,'Str. Mihai Eminescu',23,'Ploiesti','Prahova');

insert into ADRESA
values (9,'Str. Cuza Voda',5,'Campina',null);

insert into ADRESA
values (10,'Str. Nicolae Balcescu',250,'Sinaia','Prahova');

insert into ADRESA
values (11,'Str. 1 Decembrie',109,'Ploiesti','Prahova');

insert into ADRESA
values (12,'Str. Ion Creanga',7,'Busteni',null);

insert into ADRESA
values (13,'Str. Ion Luca Caragiale',108,'Ploiesti','Prahova');

insert into ADRESA
values (14,'Str. 25 Decembrie',148,'Ploiesti','Prahova');

insert into ADRESA
values (15,'Str. Mihai Bravu',89,'Ploiesti','Prahova');

insert into ADRESA
values (16,'Str. Matei Basarab',657,'Ploiesti',null);

insert into ADRESA
values (17,'Str. Nicolae Balcescu',128,'Ploiesti','Prahova');

insert into ADRESA
values (18,'Str. Carol I',12,'Ploiesti',null);

insert into ADRESA
values (19,'Str. Unirii',349,'Ploiesti','Prahova');

commit;

insert into RESTAURANT
values (101,'Da Vinci',400,12,1);

insert into RESTAURANT
values (102,'Best',500,8,5);

insert into RESTAURANT
values (103,'Mamaliguta',350,9,3);

insert into RESTAURANT
values (104,'Lazarini',600,11,1);

insert into RESTAURANT
values (105,'Trattoria',600,10,null);

insert into RESTAURANT
values (106,'Toscana',450,null,2);

commit;

insert into TIP_EVENIMENT
values (1,'Nunta');

insert into TIP_EVENIMENT
values (2,'Botez');

insert into TIP_EVENIMENT
values (3,'Majorat');

insert into TIP_EVENIMENT
values (4,'Petreceri 8 Martie');

insert into TIP_EVENIMENT
values (5,'Petreceri Weekend');

commit;

insert into EVENIMENT
values (300,to_date('02-10-2021','dd-mm-yyyy'),100,1);

insert into EVENIMENT
values (301,to_date('12-05-2022','dd-mm-yyyy'),200,1);

insert into EVENIMENT
values (302,to_date('17-07-2021','dd-mm-yyyy'),70,5);

insert into EVENIMENT
values (303,to_date('08-03-2022','dd-mm-yyyy'),200,4);

insert into EVENIMENT
values (304,to_date('23-02-2022','dd-mm-yyyy'),null,3);

insert into EVENIMENT
values (305,to_date('30-04-2022','dd-mm-yyyy'),300,2);

insert into EVENIMENT
values (306,to_date('08-06-2022','dd-mm-yyyy'),200,2);

insert into EVENIMENT
values (307,to_date('24-07-2021','dd-mm-yyyy'),70,5);

insert into EVENIMENT
values (308,to_date('01-08-2021','dd-mm-yyyy'),70,5);

commit;

insert into REALIZEAZA
values (101,307);

insert into REALIZEAZA
values (102,307);

insert into REALIZEAZA
values (104,303);

insert into REALIZEAZA
values (106,303);

insert into REALIZEAZA
values (102,303);

insert into REALIZEAZA
values (102,300);

insert into REALIZEAZA
values (103,301);

insert into REALIZEAZA
values (103,306);

insert into REALIZEAZA
values (101,305);

insert into REALIZEAZA
values (106,302);

insert into REALIZEAZA
values (105,302);

insert into REALIZEAZA
values (104,304);

insert into REALIZEAZA
values (101,308);

commit;

insert into FACILITATE
values (1,1,'aranjament floral');

insert into FACILITATE
values (4,2,'candy bar');

insert into FACILITATE
values (5,3,'o cafea gratis/invitat');

insert into FACILITATE
values (3,4,'baloane cu heliu');

insert into FACILITATE
values (3,5,'o sticla de apa/masa');

insert into FACILITATE
values (3,6,null);

commit;

insert into JOB
values (1000,'manager',10000,30000);

insert into JOB
values (1001,'bucatar',2500,15000);

insert into JOB
values (1002,'casier',1500,4000);

insert into JOB
values (1003,'personal curatenie',1000,2000);

insert into JOB
values (1004,'ospatar',1500,4000);

insert into JOB
values (1005,'sef de sala',null,10400);

insert into JOB
values (1006,'ajutor bucatar',2000,9000);

commit;

insert into ANGAJAT
values (10,'Popescu','Ion','email1@yahoo.com','0728647839',25000,to_date('02-10-2020','dd-mm-yyyy'),null,null,101,1000);

insert into ANGAJAT
values (11,'Gheorghe','Mihai','email2@yahoo.com','0728622839',10400,to_date('10-12-2020','dd-mm-yyyy'),0.1,10,101,1005);

insert into ANGAJAT
values (12,'Ionescu','Ana','email3@yahoo.com','0738689839',3000,to_date('02-01-2021','dd-mm-yyyy'),null,11,101,1002);

insert into ANGAJAT
values (13,'Neagu','Marian','email4@yahoo.com','0728647009',2500,to_date('12-03-2021','dd-mm-yyyy'),0.1,11,101,1004);

insert into ANGAJAT
values (14,'Toma','Daniela','email5@yahoo.com','0728678901',1900,to_date('02-09-2020','dd-mm-yyyy'),null,11,101,1003);

insert into ANGAJAT
values (15,'Petrescu','Marius','email6@yahoo.com','0712345678',9000,to_date('12-01-2021','dd-mm-yyyy'),0.35,11,101,1001);

insert into ANGAJAT
values (16,'Lazar','Nicoleta','email7@yahoo.com','0711223344',9000,to_date('01-02-2021','dd-mm-yyyy'),0.2,11,101,1001);

insert into ANGAJAT
values (17,'Ion','Dan','email8@yahoo.com','0701234985',5000,to_date('18-04-2021','dd-mm-yyyy'),null,15,101,1006);

insert into ANGAJAT
values (18,'Pop','Vlad','email9@yahoo.com','0789634185',20000,to_date('29-10-2020','dd-mm-yyyy'),null,null,104,1000);

insert into ANGAJAT
values (19,'Trandafir','Corina','email10@yahoo.com','0798765432',10300,to_date('02-01-2021','dd-mm-yyyy'),0.12,18,104,1005);

insert into ANGAJAT
values (20,'Dragos','Cristina','email11@yahoo.com','0798765431',14800,to_date('09-01-2021','dd-mm-yyyy'),null,19,104,1001);

insert into ANGAJAT
values (21,'Sorescu','Flavius','email12@yahoo.com','0798765435',4600,to_date('22-01-2021','dd-mm-yyyy'),null,20,104,1006);

insert into ANGAJAT
values (22,'Popescu','Ioana','email13@yahoo.com','0798765439',3300,to_date('10-06-2020','dd-mm-yyyy'),0.11,19,104,1002);

insert into ANGAJAT
values (23,'Ifrim','George','email14@yahoo.com','0789634188',20300,to_date('29-11-2020','dd-mm-yyyy'),0.3,null,102,1000);

insert into ANGAJAT
values (24,'Vasile','Tudor','email15@yahoo.com','0798765430',9080,to_date('02-03-2021','dd-mm-yyyy'),null,23,102,1005);

insert into ANGAJAT
values (25,'Dragos','Gheorghe','email16@yahoo.com','0798765400',8000,to_date('24-01-2021','dd-mm-yyyy'),null,24,102,1001);

insert into ANGAJAT
values (26,'Sora','George','email17@yahoo.com','0789634100',20900,to_date('02-11-2020','dd-mm-yyyy'),0.1,null,106,1000);

insert into ANGAJAT
values (27,'Podariu','Ionel','email18@yahoo.com','0798765411',9100,to_date('24-02-2021','dd-mm-yyyy'),null,26,106,1001);

insert into ANGAJAT
values (28,'Sandu','Tiberiu','email20@yahoo.com','0789000000',7900,to_date('06-09-2020','dd-mm-yyyy'),null,26,106,1001);

insert into ANGAJAT
values (29,'Dragomirescu','Laur','email21@yahoo.com','0781111111',21900,to_date('03-10-2020','dd-mm-yyyy'),0.1,null,105,1000);

insert into ANGAJAT
values (30,'Ion','Mihail','email22@yahoo.com','0781111112',9900,to_date('23-02-2021','dd-mm-yyyy'),null,29,105,1001);

insert into ANGAJAT
values (31,'Petrescu','Laurentiu','email23@yahoo.com','0781111113',18000,to_date('13-12-2020','dd-mm-yyyy'),0.12,null,103,1000);

insert into ANGAJAT (cod_angajat,nume_angajat,prenume_angajat,email,nr_telefon,salariu,comision,cod_sef,cod_restaurant,cod_job)
values (32,'Branescu','Ionut','email24@yahoo.com','0781111117',8700,null,31,103,1001);
--data_angajare este by default data curenta

insert into ANGAJAT
values (33,'Bojici','Matei','email25@yahoo.com','0781111129',18000,to_date('13-10-2020','dd-mm-yyyy'),null,null,null,1000);

commit;

insert into ISTORIC_JOB
values (23,to_date('29-11-2020','dd-mm-yyyy'),to_date('10-02-2021','dd-mm-yyyy'),1005);

insert into ISTORIC_JOB
values (23,to_date('11-02-2021','dd-mm-yyyy'),null,1000);

insert into ISTORIC_JOB
values (16,to_date('01-02-2021','dd-mm-yyyy'),to_date('29-03-2021','dd-mm-yyyy'),1006);

insert into ISTORIC_JOB
values (16,to_date('30-03-2021','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (26,to_date('02-11-2020','dd-mm-yyyy'),to_date('10-02-2021','dd-mm-yyyy'),1005);

insert into ISTORIC_JOB
values (26,to_date('11-02-2021','dd-mm-yyyy'),null,1000);

insert into ISTORIC_JOB
values (10,to_date('02-10-2020','dd-mm-yyyy'),null,1000);

insert into ISTORIC_JOB
values (11,to_date('10-12-2020','dd-mm-yyyy'),null,1005);

insert into ISTORIC_JOB
values (12,to_date('02-01-2021','dd-mm-yyyy'),null,1002);

insert into ISTORIC_JOB
values (13,to_date('12-03-2021','dd-mm-yyyy'),null,1004);

insert into ISTORIC_JOB
values (14,to_date('02-09-2020','dd-mm-yyyy'),null,1003);

insert into ISTORIC_JOB
values (15,to_date('12-01-2021','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (17,to_date('18-04-2021','dd-mm-yyyy'),null,1006);

insert into ISTORIC_JOB
values (18,to_date('29-10-2020','dd-mm-yyyy'),null,1000);

insert into ISTORIC_JOB
values (19,to_date('02-01-2021','dd-mm-yyyy'),null,1005);

insert into ISTORIC_JOB
values (20,to_date('09-01-2021','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (21,to_date('22-01-2021','dd-mm-yyyy'),null,1006);

insert into ISTORIC_JOB
values (22,to_date('10-06-2020','dd-mm-yyyy'),null,1002);

insert into ISTORIC_JOB
values (24,to_date('02-03-2021','dd-mm-yyyy'),null,1005);

insert into ISTORIC_JOB
values (25,to_date('24-01-2021','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (27,to_date('24-02-2021','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (28,to_date('06-09-2020','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (29,to_date('03-10-2020','dd-mm-yyyy'),null,1000);

insert into ISTORIC_JOB
values (30,to_date('23-02-2021','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (31,to_date('13-12-2020','dd-mm-yyyy'),null,1000);

insert into ISTORIC_JOB
values (32,to_date('18-05-2021','dd-mm-yyyy'),null,1001);

commit;

insert into REZERVARE
values (700,to_date('02-04-2021','dd-mm-yyyy'),2);

insert into REZERVARE
values (701,to_date('02-05-2021','dd-mm-yyyy'),1);

insert into REZERVARE
values (702,to_date('05-01-2021','dd-mm-yyyy'),2);

insert into REZERVARE
values (703,to_date('23-02-2021','dd-mm-yyyy'),4);

insert into REZERVARE (cod_rezervare,nr_persoane)
values (704,2);
--data_rezervare este by default data curenta

insert into REZERVARE
values (705,to_date('14-03-2021','dd-mm-yyyy'),2);

insert into REZERVARE
values (706,to_date('25-01-2021','dd-mm-yyyy'),3);

insert into REZERVARE
values (707,to_date('13-01-2021','dd-mm-yyyy'),150);

insert into REZERVARE
values (708,to_date('21-01-2021','dd-mm-yyyy'),200);

insert into REZERVARE
values (709,to_date('10-02-2021','dd-mm-yyyy'),90);

insert into REZERVARE
values (710,to_date('16-01-2021','dd-mm-yyyy'),90);

insert into REZERVARE
values (711,to_date('28-01-2021','dd-mm-yyyy'),95);

insert into REZERVARE
values (712,to_date('28-04-2021','dd-mm-yyyy'),5);

insert into REZERVARE
values (713,to_date('01-04-2021','dd-mm-yyyy'),2);

commit;

create sequence secventa_comanda_id
start with 500
increment by 1
maxvalue 9999
nocycle
nocache; 

insert into COMANDA
values (secventa_comanda_id.nextval,'card',null,to_date('23-04-2021','dd-mm-yyyy'),101,15);

insert into COMANDA
values (secventa_comanda_id.nextval,'cash',null,to_date('10-04-2021','dd-mm-yyyy'),101,15);

insert into COMANDA
values (secventa_comanda_id.nextval,'card',null,to_date('13-05-2021','dd-mm-yyyy'),106,28);

insert into COMANDA
values (secventa_comanda_id.nextval,'card',null,to_date('09-01-2021','dd-mm-yyyy'),102,25);

insert into COMANDA
values (secventa_comanda_id.nextval,'cash',null,to_date('01-02-2021','dd-mm-yyyy'),103,32);

insert into COMANDA
values (secventa_comanda_id.nextval,'card',null,to_date('19-04-2021','dd-mm-yyyy'),105,30);

insert into COMANDA
values (secventa_comanda_id.nextval,'cash',null,to_date('03-04-2021','dd-mm-yyyy'),104,20);

commit;

insert into CLIENT
values (40,'Rapeanu','Adrian','0722334455',16,500);

insert into CLIENT
values (41,'Dragomir','Elena','0722334467',17,503);

insert into CLIENT
values (42,'Frusinoiu','Andrei','0700334467',19,501);

insert into CLIENT
values (43,'Mares','Catalin','0722330101',18,505);

insert into CLIENT
values (44,'Petre','Mihaela','0722339898',null,null);

insert into CLIENT
values (45,'Sorescu','Ana','0766339898',null,null);

insert into CLIENT
values (46,'Soare','Mihaela','0755539898',null,null);

insert into CLIENT
values (47,'Ristoiu','Rares','0766777898',null,null);

insert into CLIENT
values (48,'Ciurea','Claudia','0722355558',null,null);

insert into CLIENT
values (49,'Vulpe','Alin','07653980786',null,null);

insert into CLIENT
values (50,'Negoita','Eduard','07653980090',null,null);

insert into CLIENT
values (51,'Neagu','David','07653980091',null,null);

commit;

insert into FACE
values (44,709,300,102);

insert into FACE
values (44,705,303,104);

insert into FACE
values (45,702,303,102);

insert into FACE
values (46,708,305,101);

insert into FACE
values (47,707,306,103);

insert into FACE
values (48,700,303,106);

insert into FACE
values (49,711,301,103);

insert into FACE
values (50,701,302,105);

insert into FACE
values (48,710,304,104);

insert into FACE
values (47,703,302,106);

insert into FACE
values (45,704,302,106);

insert into FACE
values (44,706,302,105);

insert into FACE
values (41,712,303,104);

insert into FACE
values (50,713,302,106);

commit;

insert into ISTORIC_COMANDA
values (40,to_date('23-04-2021','dd-mm-yyyy'),10,500);

insert into ISTORIC_COMANDA
values (40,to_date('13-05-2021','dd-mm-yyyy'),9,502);

insert into ISTORIC_COMANDA
values (41,to_date('09-01-2021','dd-mm-yyyy'),10,503);

insert into ISTORIC_COMANDA
values (41,to_date('01-02-2021','dd-mm-yyyy'),10,504);

insert into ISTORIC_COMANDA
values (41,to_date('03-04-2021','dd-mm-yyyy'),10,506);

insert into ISTORIC_COMANDA
values (42,to_date('10-04-2021','dd-mm-yyyy'),8,501);

insert into ISTORIC_COMANDA
values (43,to_date('19-04-2021','dd-mm-yyyy'),10,505);

commit;

insert into PREPARAT
values (70,'ciorba de legume',10);

insert into PREPARAT
values (71,'ciorba de burta',15);

insert into PREPARAT
values (72,'pui la cuptor cu cartofi',23.5);

insert into PREPARAT
values (73,'paste cu ton',25);

insert into PREPARAT
values (74,'paste carbonara',26);

insert into PREPARAT
values (75,'pizza capriciosa',28);

insert into PREPARAT
values (76,'pizza casei',29);

insert into PREPARAT
values (77,'mix fructe de mare',35);

insert into PREPARAT
values (78,'somon file',37);

insert into PREPARAT
values (79,'papanasi',12);

insert into PREPARAT
values (80,'tort cu ciocolata',20);

commit;

insert into CUPRINDE
values (70,500,1);

insert into CUPRINDE
values (73,500,2);

insert into CUPRINDE
values (72,501,2);

insert into CUPRINDE
values (76,502,2);

insert into CUPRINDE
values (79,502,1);

insert into CUPRINDE
values (77,503,1);

insert into CUPRINDE
values (78,504,2);

insert into CUPRINDE
values (71,505,3);

insert into CUPRINDE
values (80,505,1);

insert into CUPRINDE
values (74,506,4);

insert into CUPRINDE
values (80,506,1);

commit;

--6. Definiti o procedura stocata care seteaza corespunzator valoarea fiecarei comenzi si afiseaza pe ecran codul comenzii, respectiv noua valoare setata.
--Se vor folosi colectii pentru a retine datele necesare rezolvarii exercitiului. Apelati procedura.
CREATE OR REPLACE PROCEDURE ex6
IS  
    TYPE tab_imb IS TABLE OF NUMBER;
    TYPE comanda_tab IS TABLE OF comanda.cod_comanda%TYPE INDEX BY BINARY_INTEGER;
    v_coduri_preparate tab_imb := tab_imb();
    tabel_comenzi comanda_tab;
    v_valoare comanda.valoare%type;
    nr NUMBER;
    valoare_curenta comanda.valoare%type;
BEGIN
    select cod_comanda
    bulk collect into tabel_comenzi
    from comanda;

    FOR i IN tabel_comenzi.FIRST..tabel_comenzi.LAST LOOP
         v_valoare := 0;

         select count(cod_preparat)
         into nr
         from cuprinde c
         where c.cod_comanda = tabel_comenzi(i);

         FOR j IN 1..nr LOOP
            v_coduri_preparate.EXTEND;
         END LOOP;

         select cod_preparat
         bulk collect into v_coduri_preparate
         from cuprinde c
         where c.cod_comanda= tabel_comenzi(i);

         FOR k IN v_coduri_preparate.FIRST..v_coduri_preparate.LAST LOOP
            select p.pret*c.cantitate
            into valoare_curenta
            from preparat p, cuprinde c
            where p.cod_preparat = v_coduri_preparate(k) and c.cod_preparat = v_coduri_preparate(k) and c.cod_comanda = tabel_comenzi(i);

            v_valoare := v_valoare + valoare_curenta;
         END LOOP;

         update comanda
         set valoare = v_valoare
         where cod_comanda = tabel_comenzi(i);

         v_coduri_preparate.DELETE;
         dbms_output.put_line('Comanda ' || tabel_comenzi(i) || ' are valoarea de ' || v_valoare || ' lei.');
         dbms_output.put_line('Update realizat cu succes!');
         dbms_output.new_line();
    END LOOP;
END ex6;

BEGIN
  ex6();
END;

--7. Definiti o procedura stocata care pentru fiecare preparat afiseaza o lista cu detaliile comenzilor care cuprind preparatul respectiv. (codul comenzii,
--data la care a fost plasata comanda si tipul platii (cash/card)). Daca preparatul nu este cuprins in nicio comanda, se va afisa un mesaj corespunzator.
--Apelati procedura.
CREATE OR REPLACE PROCEDURE ex7
IS
    TYPE comanda_record IS RECORD 
      (cod comanda.cod_comanda%TYPE, 
       data_plasare comanda.data_comanda%TYPE,
       plata comanda.tip_plata%TYPE);
    TYPE tablou_comanda IS TABLE OF comanda_record INDEX BY BINARY_INTEGER;
    TYPE refcursor IS REF CURSOR;
    CURSOR c IS 
       select nume_preparat, CURSOR (select c.cod_comanda, c.data_comanda, c.tip_plata
                                     from comanda c, cuprinde cu
                                     where c.cod_comanda = cu.cod_comanda and cu.cod_preparat = p.cod_preparat)
       from preparat p;
    v_cursor refcursor;
    v_comanda tablou_comanda;
    v_preparat preparat.nume_preparat%TYPE;
    nr NUMBER;
    zi NUMBER;
    an NUMBER;
    luna_cu_spatii VARCHAR2(15);
    luna_fara_spatii VARCHAR2(15);
BEGIN
    OPEN c;
    LOOP
      FETCH c INTO v_preparat, v_cursor;
      EXIT WHEN c%NOTFOUND;
      dbms_output.put_line('Preparatul: ' || v_preparat);
      nr := 0;
      LOOP
          FETCH v_cursor BULK COLLECT INTO v_comanda;
          nr := v_comanda.COUNT;
          IF nr = 0 THEN
              dbms_output.put_line('Nu exista comenzi care sa cuprinda preparatul respectiv!');
          ELSE
              dbms_output.put_line('Comenzile care curpind preparatul ' || v_preparat || ':');
              FOR i IN v_comanda.FIRST..v_comanda.LAST LOOP
                  zi := extract (day from v_comanda(i).data_plasare);
                  
                  select to_char(v_comanda(i).data_plasare, 'Month', 'NLS_DATE_LANGUAGE = Romanian')
                  into luna_cu_spatii
                  from dual;
                  
                  luna_fara_spatii := RTRIM(luna_cu_spatii, ' ');
                  an := extract(year from v_comanda(i).data_plasare);
                  dbms_output.put_line('Comanda cu codul ' || v_comanda(i).cod || ', plasata in data de ' || zi || ' ' || luna_fara_spatii || ' ' || an 
                     || ' si care are tipul platii ' || v_comanda(i).plata || '.');
              END LOOP;
          END IF;
          EXIT WHEN v_cursor%NOTFOUND;
      END LOOP;
      dbms_output.new_line;
    END LOOP;
    CLOSE c;
END;


BEGIN
 ex7();
END;

--8. Definiti o functie stocata care sa returneze un mesaj corespunzator cu un top 3. Functia primeste trei nume ale unor clienti, un nume de restaurant si o data
--si face clasamentul clientilor dupa numarul de comenzi plasate in restaurantul cu numele transmis, dupa data indicata.
--Tratati exceptiile care pot aparea. Apelati functia astfel incat sa evidentiati aceste exceptii.
CREATE OR REPLACE FUNCTION ex8(
      nume1 client.nume_client%TYPE, nume2 client.nume_client%TYPE, nume3 client.nume_client%TYPE, nume_res restaurant.nume_restaurant%TYPE, 
      data_com comanda.data_comanda%TYPE)
      RETURN VARCHAR2
IS  
    v_cod_res NUMBER;
    v_cod_cl1 client.cod_client%TYPE;
    v_cod_cl2 client.cod_client%TYPE;
    v_cod_cl3 client.cod_client%TYPE;
    nr_cl1 NUMBER;
    nr_cl2 NUMBER;
    nr_cl3 NUMBER;
    aux NUMBER;
    aux_nume client.nume_client%TYPE;
    nume1_copie client.nume_client%TYPE;
    nume2_copie client.nume_client%TYPE;
    nume3_copie client.nume_client%TYPE;
    mesaj VARCHAR2(200);
BEGIN
    select cod_client
    into v_cod_cl1
    from client
    where upper(nume_client) = upper(nume1);
    
    select cod_client
    into v_cod_cl2
    from client
    where upper(nume_client) = upper(nume2);
    
    select cod_client
    into v_cod_cl3
    from client
    where upper(nume_client) = upper(nume3);
    
    select cod_restaurant
    into v_cod_res
    from restaurant
    where upper(nume_restaurant) = upper(nume_res);
    
    select count(*)
    into nr_cl1
    from istoric_comanda i, client c, comanda co, restaurant r
    where upper(c.nume_client) = upper(nume1) and c.cod_client = i.cod_client and i.cod_comanda = co.cod_comanda and co.cod_restaurant = r.cod_restaurant
    and upper(r.nume_restaurant) = upper(nume_res) and co.data_comanda > data_com;
    
    select count(*)
    into nr_cl2
    from istoric_comanda i, client c, comanda co, restaurant r
    where upper(c.nume_client) = upper(nume2) and c.cod_client = i.cod_client and i.cod_comanda = co.cod_comanda and co.cod_restaurant = r.cod_restaurant
    and upper(r.nume_restaurant) = upper(nume_res) and co.data_comanda > data_com;
    
    select count(*)
    into nr_cl3
    from istoric_comanda i, client c, comanda co, restaurant r
    where upper(c.nume_client) = upper(nume3) and c.cod_client = i.cod_client and i.cod_comanda = co.cod_comanda and co.cod_restaurant = r.cod_restaurant
    and upper(r.nume_restaurant) = upper(nume_res) and co.data_comanda > data_com;
    
    nume1_copie := nume1;
    nume2_copie := nume2;
    nume3_copie := nume3;
    
    IF (nr_cl1 < nr_cl2) THEN
       aux := nr_cl1;
       nr_cl1 := nr_cl2;
       nr_cl2 := aux;
       aux_nume := nume1_copie;
       nume1_copie := nume2_copie;
       nume2_copie := aux_nume;
    END IF;
    
    IF (nr_cl1 < nr_cl3) THEN
       aux := nr_cl1;
       nr_cl1 := nr_cl3;
       nr_cl3 := aux;
       aux_nume := nume1_copie;
       nume1_copie := nume3_copie;
       nume3_copie := aux_nume;
    END IF;
    
    IF (nr_cl2 < nr_cl3) THEN
       aux := nr_cl2;
       nr_cl2 := nr_cl3;
       nr_cl3 := aux;
       aux_nume := nume2_copie;
       nume2_copie := nume3_copie;
       nume3_copie := aux_nume;
    END IF;
    
    mesaj := 'Top 3 dupa numarul de comenzi plasate in restaurantul ' || initcap(nume_res) || ' dupa data de ' || data_com || ': ' || nr_cl1 
    || ' - ' || initcap(nume1_copie) || '; ' || nr_cl2 || ' - ' || initcap(nume2_copie) || '; ' || nr_cl3 || ' - ' || initcap(nume3_copie);
    RETURN mesaj;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        IF v_cod_cl1 IS NULL THEN
           mesaj := 'Nu exista client cu numele ' || initcap(nume1) || '!';
        ELSIF v_cod_cl2 IS NULL THEN
           mesaj := 'Nu exista client cu numele ' || initcap(nume2) || '!';
        ELSIF v_cod_cl3 IS NULL THEN
           mesaj := 'Nu exista client cu numele ' || initcap(nume3) || '!';
        ELSE 
           mesaj := 'Nu exista restaurant cu numele ' || initcap(nume_res) || '!';
        END IF;
        RETURN mesaj;
    WHEN TOO_MANY_ROWS THEN
       IF v_cod_cl1 IS NULL THEN
           mesaj := 'Exista mai multi clienti cu numele ' || initcap(nume1) || '!';
        ELSIF v_cod_cl2 IS NULL THEN
           mesaj := 'Exista mai multi clienti cu numele ' || initcap(nume2) || '!';
        ELSIF v_cod_cl3 IS NULL THEN
           mesaj := 'Exista mai multi clienti cu numele ' || initcap(nume3) || '!';
        ELSE 
           mesaj := 'Exista mai multe restaurante cu numele ' || initcap(nume_res) || '!';
        END IF;
        RETURN mesaj;
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END ex8;

BEGIN
dbms_output.put_line(ex8('rapeanu', 'dragomir', 'Frusinoiu', 'lazarini', to_date('02-02-2020', 'dd-mm-yyyy')));
END;

BEGIN
dbms_output.put_line(ex8('rapeanu', 'dragomir', 'Frusinoiu', 'da vinci', to_date('02-02-2020', 'dd-mm-yyyy')));
END;

BEGIN
dbms_output.put_line(ex8('negoit', 'dragomir', 'Frusinoiu', 'da vinci', to_date('02-02-2020', 'dd-mm-yyyy')));
END;

BEGIN
dbms_output.put_line(ex8('negoita', 'dragomir', 'Frusinoiu', 'da vincii', to_date('02-02-2020', 'dd-mm-yyyy')));
END;

BEGIN
dbms_output.put_line(ex8('negoita', 'neagu', 'Frusinoiu', 'da vinci', to_date('02-02-2020', 'dd-mm-yyyy')));
END;

--9. Definiti o procedura stocata care, pentru un nume al unui client transmis ca parametru si o optiune, realizeaza urmatoarele:
-- - Optiunea 1: Afiseaza o lista cu detaliile rezervarilor facute de clientul respectiv (numar de persoane, data rezervarii, data evenimentului, restaurantul
--in care are loc evenimentul si tipul evenimentului);
-- - Optiunea 2: Afiseaza o lista cu detaliile comenzilor facute de clientul respectiv (cod comanda, valoarea comenzii si tipul platii);
-- - Optiunea 3: Raspunde la intrebarea: 'Exista comenzi care au valoarea un numar divizibil cu 10 pe care clientul transmis ca parametru sa nu le fi facut?'.
-- Se vor trata exceptiile care pot aparea.
-- Apelati procedura astfel incat sa se evidentieze exceptiile tratate.
CREATE OR REPLACE PROCEDURE ex9
   (nume client.nume_client%TYPE, optiune NUMBER)
IS  
    TYPE informatii IS RECORD
     (nr_persoane rezervare.nr_persoane%TYPE,
      data_r rezervare.data_rezervare%TYPE,
      data_e eveniment.data_eveniment%TYPE,
      nume_res restaurant.nume_restaurant%TYPE,
      tip_e tip_eveniment.descriere%TYPE);
    v_inf informatii;
    
    CURSOR c(parametru client.nume_client%type) IS
       select  r.nr_persoane, r.data_rezervare , e.data_eveniment, res.nume_restaurant, t.descriere
       from client c,REZERVARE r, EVENIMENT e, RESTAURANT res, FACE f, tip_eveniment t
       where f.cod_rezervare=r.cod_rezervare and f.cod_restaurant=res.cod_restaurant 
        and f.cod_eveniment=e.cod_eveniment and e.cod_tip = t.cod_tip and f.cod_client = c.cod_client and upper(c.nume_client) = upper(parametru);
        
    TYPE comanda_tip IS REF CURSOR RETURN comanda%ROWTYPE;
    v_comanda comanda_tip;
    v_com comanda%ROWTYPE;
    contor NUMBER :=1;
    ok NUMBER := 0;
    TYPE clienti_tab IS TABLE OF istoric_comanda.cod_client%TYPE INDEX BY BINARY_INTEGER;
    coduri_clienti clienti_tab;
    v_cod_client client.cod_client%TYPE;
BEGIN
    select cod_client
    into v_cod_client
    from client
    where upper(nume_client) = upper(nume);
    
    IF optiune = 1 THEN
        dbms_output.put_line('Rezervari pentru clientul ' || initcap(nume) || ':');
        OPEN c(nume);
        LOOP
           FETCH c INTO v_inf;
           EXIT WHEN c%NOTFOUND;
           dbms_output.put_line(contor || '. Numar persoane: ' ||  v_inf.nr_persoane || ', Data rezervare: ' || v_inf.data_r || ', Data eveniment: ' || v_inf.data_e 
           || ', Nume restaurant: ' || v_inf.nume_res || ', Tip eveniment: ' || v_inf.tip_e);
           contor := contor + 1;
         END LOOP;
         CLOSE c;
    ELSIF optiune = 2 THEN
         dbms_output.put_line('Comenzi pentru clientul ' || initcap(nume) || ':');
         OPEN v_comanda FOR select co.*
                            from comanda co, client c, istoric_comanda i
                            where upper(c.nume_client) = upper(nume) and c.cod_client = i.cod_client and i.cod_comanda = co.cod_comanda;
         LOOP
            FETCH v_comanda INTO v_com;
            EXIT WHEN v_comanda%NOTFOUND;
            dbms_output.put_line(contor || '. Comanda ' || v_com.cod_comanda || ' cu valoarea de ' || v_com.valoare || ' lei, cu tipul platii ' || v_com.tip_plata);
            contor := contor + 1;
         END LOOP;
         CLOSE v_comanda;
     ELSIF optiune = 3 THEN
         select distinct(a.cod_client)
         bulk collect into coduri_clienti
         from istoric_comanda a
         where not exists (select 1
                           from COMANDA c
                           where mod(c.valoare, 10) = 0 and not exists (select 1
                                                                        from istoric_comanda b
                                                                        where c.cod_comanda=b.cod_comanda and b.cod_client=a.cod_client));
         FOR i IN coduri_clienti.FIRST..coduri_clienti.LAST LOOP
              IF coduri_clienti(i) = v_cod_client THEN
                 ok := 1;
              END IF;
         END LOOP;
         IF ok = 1 THEN 
           dbms_output.put_line('Pentru ' || initcap(nume) || ' nu exista comenzi cu valoarea un numar divizibil cu 10 pe care sa nu le fi facut.');
         ELSE
           dbms_output.put_line('Pentru ' || initcap(nume) || ' exista comenzi cu valoarea un numar divizibil cu 10 pe care sa nu le fi facut.');
         END IF;
     ELSE
         dbms_output.put_line('Optiune invalida!');
     END IF;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000,'Nu exista clientul cu numele transmis ca parametru!');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001,'Exista mai multi clienti cu numele transmis ca parametru!');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END ex9;

execute ex9('negoita', 1);

execute ex9('dragomir', 2);

execute ex9('rapeanu', 3);

execute ex9('negoita', 3);

execute ex9('negoita', 4);

execute ex9('nume', 1);

insert into client
values (53, 'Neagu', 'Marian', '0766777890', null, null);

execute ex9('neagu', 1);

--10. Definiti un trigger LMD la nivel de comanda care nu permite modificarea tabelului preparat intr-o zi de duminica.
--De asemenea, se va respecta:
--a) Sa nu se insereze mai mult de 100 de preparate deoarece in acest fel s-ar ingreuna pregatirea acestora, daca meniul ar fi atat de variat. In plus, ar necesita
--prea multa materie prima.
--b) Sa nu se stearga preparate astfel incat sa ramana mai putin de 5.
--Declansati trigger-ul.
ALTER TABLE cuprinde
DROP CONSTRAINT FK_CUP_PREP;

ALTER TABLE cuprinde
ADD CONSTRAINT FK_CUP_PREP 
FOREIGN KEY (cod_preparat) 
REFERENCES PREPARAT(cod_preparat) 
ON DELETE CASCADE;

select constraint_name, search_condition, r_constraint_name, delete_rule 
from user_constraints 
where TABLE_NAME = 'CUPRINDE';  

CREATE OR REPLACE TRIGGER ex10
BEFORE UPDATE OR INSERT or DELETE on preparat
DECLARE
    v_nr_preparate NUMBER;
    v_zi VARCHAR2(20);
BEGIN
    select to_char(sysdate, 'Day', 'NLS_DATE_LANGUAGE = Romanian')
    into v_zi
    from dual;
   
    IF RTRIM(UPPER(v_zi)) = UPPER('duminica') THEN
        RAISE_APPLICATION_ERROR(-20004, 'Nu se pot face modificari duminica!');
    ELSE
        select count(cod_preparat)
        into v_nr_preparate
        from preparat;
    
        IF INSERTING AND v_nr_preparate >= 100 THEN
           RAISE_APPLICATION_ERROR(-20001, 'Nu se pot insera mai mult de 100 de preparate!');
        END IF;
        
        IF DELETING AND v_nr_preparate <= 5 THEN
          RAISE_APPLICATION_ERROR(-20002, 'Nu se pot sterge atatea preparate astfel incat sa ramanem cu mai putin de 5!');
        END IF;
    END IF;
END ex10;

BEGIN
  FOR i IN 73..80 LOOP
     delete from preparat 
     where cod_preparat = i;
  END LOOP;
END;

BEGIN
  FOR i IN 500..600 LOOP
     insert into preparat
     values(i, 'nume', 89);
  END LOOP;
END;

update preparat
set pret = 70
where cod_preparat = 78;

rollback;

drop trigger ex10;

set serveroutput on;
select *
from preparat;
select *
from cuprinde;

--11. Definiti un trigger de tip LMD la nivel de linie care:
--a) Daca este sters un client, va sterge din baza de date si istoricul sau, cat si evidenta rezervarilor la evenimente. Se va retine numarul de linii sterse.
--b) Daca este schimbat codul unui client, se vor face modificarile necesare in istoric cat si in evidenta rezervarilor. Se va retine numarul de linii modificate.
--c) Daca se insereaza un nou client, se vor face urmatoarele verificari asupra numarului de telefon:
--          - numarul introdus sa aiba 10 cifre;
--          - numarul introdus sa inceapa cu '07' deoarece in baza de date vom dori doar numere de mobil, specifice tarii noastre.
--Declansati trigger-ul.
CREATE PACKAGE pachet_contor IS
    v_nr_linii_update_face NUMBER;
    v_nr_linii_update_istoric NUMBER;
    v_nr_linii_delete_face NUMBER;
    v_nr_linii_delete_istoric NUMBER;
END;

CREATE OR REPLACE TRIGGER ex11
BEFORE DELETE OR INSERT OR UPDATE on client
FOR EACH ROW
DECLARE
   exceptie1 EXCEPTION;
   exceptie2 EXCEPTION;
BEGIN
   IF DELETING THEN
      delete from face
      where cod_client = :OLD.cod_client;
      
      pachet_contor.v_nr_linii_delete_face := sql%rowcount;
      
      delete from istoric_comanda
      where cod_client = :OLD.cod_client;
      
      pachet_contor.v_nr_linii_delete_istoric := sql%rowcount;
   ELSIF UPDATING AND :OLD.cod_client != :NEW.cod_client THEN
       update face
       set cod_client = :NEW.cod_client
       where cod_client = :OLD.cod_client;
       
       pachet_contor.v_nr_linii_update_face := sql%rowcount;
       
       update istoric_comanda
       set cod_client = :NEW.cod_client
       where cod_client = :OLD.cod_client;
       
       pachet_contor.v_nr_linii_update_istoric := sql%rowcount;
   ELSIF INSERTING AND length(:NEW.telefon) != 10 THEN
       raise exceptie1;
   ELSIF INSERTING AND :NEW.telefon != '07%' THEN
       raise exceptie2;
   END IF;
   EXCEPTION
      WHEN exceptie1 THEN
        RAISE_APPLICATION_ERROR (-20001, 'Numarul de telefon pe care doriti sa il inserati nu este valid! Introduceti un numar de telefon mobil care are 10 cifre!');
      WHEN exceptie2 THEN
        RAISE_APPLICATION_ERROR (-20002, 'Numarul de telefon pe care doriti sa il inserati nu este valid! Introduceti un numar de telefon mobil care incepe cu 07!');
END ex11;


DECLARE
   total NUMBER;
BEGIN
   update client
   set cod_client = 70
   where cod_client = 41;
   
   total := pachet_contor.v_nr_linii_update_face + pachet_contor.v_nr_linii_update_istoric;
   dbms_output.put_line('S-au modificat ' || total || ' linii.');
END;

DECLARE
   total NUMBER;
BEGIN
   delete from client
   where cod_client = 70;
   
   total := pachet_contor.v_nr_linii_delete_face + pachet_contor.v_nr_linii_delete_istoric;
   dbms_output.put_line('S-au modificat ' || total || ' linii.');
END;


select *
from istoric_comanda;

select * 
from face;

insert into client
values (52, 'nume', 'prenume', '07983849469098', null, null);

insert into client
values (53, 'Nume', 'Prenume', '8798384946', null, null);

--12. Definiti un trigger LDD care permite modificari asupra bazei de date doar de catre utilizatorul andreea_sora1, in intervalul orar 8-21. 
--Toate modificarile (cât și cele încercate în condiții nepermise) facute asupra schemei se vor salva intr-un tabel. Declanșați trigger-ul.
CREATE TABLE istoric_LDD (
utilizator VARCHAR2(40),
nume_baza_de_date VARCHAR2(40),
eveniment VARCHAR2(40),
nume_obiect VARCHAR2(40),
data_modificarii DATE,
eroare VARCHAR2(50)
);

CREATE OR REPLACE TRIGGER ex12
BEFORE CREATE OR ALTER OR DROP ON SCHEMA
DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   IF USER != UPPER('andreea_sora1') THEN
        INSERT INTO istoric_LDD
        VALUES(SYS.LOGIN_USER, SYS.DATABASE_NAME, SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME, SYSDATE, 'alt user');
        commit;
        RAISE_APPLICATION_ERROR(-20900, 'Doar andreea_sora1 are permisiunea de a modifica schema!');
   ELSIF TO_CHAR(SYSDATE, 'HH24') NOT BETWEEN 8 AND 21 THEN
        INSERT INTO istoric_LDD
        VALUES(SYS.LOGIN_USER, SYS.DATABASE_NAME, SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME, SYSDATE, 'in afara orelor permise');
        commit;
        RAISE_APPLICATION_ERROR(-20800, 'Schema nu poate fi actualizata decat intre orele 8:00 si 21:00!');
   ELSE
        INSERT INTO istoric_LDD
        VALUES(SYS.LOGIN_USER, SYS.DATABASE_NAME, SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME, SYSDATE, 'succes');
        commit;
   END IF;
END ex12;

    
create table tabel_proba(
nume VARCHAR2(5)
);
    
drop table tabel_proba;

create table tabel_proba(
nume VARCHAR2(5)
);

alter table tabel_proba
add numar number;

select * from istoric_ldd;

create table tabel(
cod NUMBER
);

--13. Definiți un pachet care să conțină toate obiectele definite în cadrul proiectului.
CREATE OR REPLACE PACKAGE ex13 IS
   PROCEDURE seteaza_valoarea_comenzii;
   PROCEDURE lista_comenzi;
   FUNCTION top3(nume1 client.nume_client%TYPE, nume2 client.nume_client%TYPE, nume3 client.nume_client%TYPE, nume_res restaurant.nume_restaurant%TYPE, 
      data_com comanda.data_comanda%TYPE) RETURN VARCHAR2;
   PROCEDURE detalii(nume client.nume_client%TYPE, optiune NUMBER);
END ex13;

CREATE OR REPLACE PACKAGE BODY ex13 IS

  PROCEDURE seteaza_valoarea_comenzii IS  
    TYPE tab_imb IS TABLE OF NUMBER;
    TYPE comanda_tab IS TABLE OF comanda.cod_comanda%TYPE INDEX BY BINARY_INTEGER;
    v_coduri_preparate tab_imb := tab_imb();
    tabel_comenzi comanda_tab;
    v_valoare comanda.valoare%type;
    nr NUMBER;
    valoare_curenta comanda.valoare%type;
  BEGIN
    select cod_comanda
    bulk collect into tabel_comenzi
    from comanda;
    
    FOR i IN tabel_comenzi.FIRST..tabel_comenzi.LAST LOOP
         v_valoare := 0;
         
         select count(cod_preparat)
         into nr
         from cuprinde c
         where c.cod_comanda = tabel_comenzi(i);
         
         FOR j IN 1..nr LOOP
            v_coduri_preparate.EXTEND;
         END LOOP;
         
         select cod_preparat
         bulk collect into v_coduri_preparate
         from cuprinde c
         where c.cod_comanda= tabel_comenzi(i);
         
         FOR k IN v_coduri_preparate.FIRST..v_coduri_preparate.LAST LOOP
            select p.pret*c.cantitate
            into valoare_curenta
            from preparat p, cuprinde c
            where p.cod_preparat = v_coduri_preparate(k) and c.cod_preparat = v_coduri_preparate(k) and c.cod_comanda = tabel_comenzi(i);
            
            v_valoare := v_valoare + valoare_curenta;
         END LOOP;
         
         update comanda
         set valoare = v_valoare
         where cod_comanda = tabel_comenzi(i);
         
         v_coduri_preparate.DELETE;
         dbms_output.put_line('Comanda ' || tabel_comenzi(i) || ' are valoarea de ' || v_valoare || ' lei.');
         dbms_output.put_line('Update realizat cu succes!');
         dbms_output.new_line();
    END LOOP;
  END seteaza_valoarea_comenzii;

  PROCEDURE lista_comenzi IS
    TYPE comanda_record IS RECORD 
      (cod comanda.cod_comanda%TYPE, 
       data_plasare comanda.data_comanda%TYPE,
       plata comanda.tip_plata%TYPE);
    TYPE tablou_comanda IS TABLE OF comanda_record INDEX BY BINARY_INTEGER;
    TYPE refcursor IS REF CURSOR;
    CURSOR c IS 
       select nume_preparat, CURSOR (select c.cod_comanda, c.data_comanda, c.tip_plata
                                     from comanda c, cuprinde cu
                                     where c.cod_comanda = cu.cod_comanda and cu.cod_preparat = p.cod_preparat)
       from preparat p;
    v_cursor refcursor;
    v_comanda tablou_comanda;
    v_preparat preparat.nume_preparat%TYPE;
    nr NUMBER;
    zi NUMBER;
    an NUMBER;
    luna_cu_spatii VARCHAR2(15);
    luna_fara_spatii VARCHAR2(15);
  BEGIN
    OPEN c;
    LOOP
      FETCH c INTO v_preparat, v_cursor;
      EXIT WHEN c%NOTFOUND;
      dbms_output.put_line('Preparatul: ' || v_preparat);
      nr := 0;
      LOOP
          FETCH v_cursor BULK COLLECT INTO v_comanda;
          nr := v_comanda.COUNT;
          IF nr = 0 THEN
              dbms_output.put_line('Nu exista comenzi care sa cuprinda preparatul respectiv!');
          ELSE
              dbms_output.put_line('Comenzile care curpind preparatul ' || v_preparat || ':');
              FOR i IN v_comanda.FIRST..v_comanda.LAST LOOP
                  zi := extract (day from v_comanda(i).data_plasare);
                  
                  select to_char(v_comanda(i).data_plasare, 'Month', 'NLS_DATE_LANGUAGE = Romanian')
                  into luna_cu_spatii
                  from dual;
                  
                  luna_fara_spatii := RTRIM(luna_cu_spatii, ' ');
                  an := extract(year from v_comanda(i).data_plasare);
                  dbms_output.put_line('Comanda cu codul ' || v_comanda(i).cod || ', plasata in data de ' || zi || ' ' || luna_fara_spatii || ' ' || an 
                     || ' si care are tipul platii ' || v_comanda(i).plata || '.');
              END LOOP;
          END IF;
          EXIT WHEN v_cursor%NOTFOUND;
      END LOOP;
      dbms_output.new_line;
    END LOOP;
    CLOSE c;
  END lista_comenzi;
  
  FUNCTION top3(nume1 client.nume_client%TYPE, nume2 client.nume_client%TYPE, nume3 client.nume_client%TYPE, nume_res restaurant.nume_restaurant%TYPE, 
      data_com comanda.data_comanda%TYPE)
      RETURN VARCHAR2 IS  
    v_cod_res NUMBER;
    v_cod_cl1 client.cod_client%TYPE;
    v_cod_cl2 client.cod_client%TYPE;
    v_cod_cl3 client.cod_client%TYPE;
    nr_cl1 NUMBER;
    nr_cl2 NUMBER;
    nr_cl3 NUMBER;
    aux NUMBER;
    aux_nume client.nume_client%TYPE;
    nume1_copie client.nume_client%TYPE;
    nume2_copie client.nume_client%TYPE;
    nume3_copie client.nume_client%TYPE;
    mesaj VARCHAR2(200);
  BEGIN
    select cod_client
    into v_cod_cl1
    from client
    where upper(nume_client) = upper(nume1);
    
    select cod_client
    into v_cod_cl2
    from client
    where upper(nume_client) = upper(nume2);
    
    select cod_client
    into v_cod_cl3
    from client
    where upper(nume_client) = upper(nume3);
    
    select cod_restaurant
    into v_cod_res
    from restaurant
    where upper(nume_restaurant) = upper(nume_res);
    
    select count(*)
    into nr_cl1
    from istoric_comanda i, client c, comanda co, restaurant r
    where upper(c.nume_client) = upper(nume1) and c.cod_client = i.cod_client and i.cod_comanda = co.cod_comanda and co.cod_restaurant = r.cod_restaurant
    and upper(r.nume_restaurant) = upper(nume_res) and co.data_comanda > data_com;
    
    select count(*)
    into nr_cl2
    from istoric_comanda i, client c, comanda co, restaurant r
    where upper(c.nume_client) = upper(nume2) and c.cod_client = i.cod_client and i.cod_comanda = co.cod_comanda and co.cod_restaurant = r.cod_restaurant
    and upper(r.nume_restaurant) = upper(nume_res) and co.data_comanda > data_com;
    
    select count(*)
    into nr_cl3
    from istoric_comanda i, client c, comanda co, restaurant r
    where upper(c.nume_client) = upper(nume3) and c.cod_client = i.cod_client and i.cod_comanda = co.cod_comanda and co.cod_restaurant = r.cod_restaurant
    and upper(r.nume_restaurant) = upper(nume_res) and co.data_comanda > data_com;
    
    nume1_copie := nume1;
    nume2_copie := nume2;
    nume3_copie := nume3;
    
    IF (nr_cl1 < nr_cl2) THEN
       aux := nr_cl1;
       nr_cl1 := nr_cl2;
       nr_cl2 := aux;
       aux_nume := nume1_copie;
       nume1_copie := nume2_copie;
       nume2_copie := aux_nume;
    END IF;
    
    IF (nr_cl1 < nr_cl3) THEN
       aux := nr_cl1;
       nr_cl1 := nr_cl3;
       nr_cl3 := aux;
       aux_nume := nume1_copie;
       nume1_copie := nume3_copie;
       nume3_copie := aux_nume;
    END IF;
    
    IF (nr_cl2 < nr_cl3) THEN
       aux := nr_cl2;
       nr_cl2 := nr_cl3;
       nr_cl3 := aux;
       aux_nume := nume2_copie;
       nume2_copie := nume3_copie;
       nume3_copie := aux_nume;
    END IF;
    
    mesaj := 'Top 3 dupa numarul de comenzi plasate in restaurantul ' || initcap(nume_res) || ' dupa data de ' || data_com || ': ' || nr_cl1 
    || ' - ' || initcap(nume1_copie) || '; ' || nr_cl2 || ' - ' || initcap(nume2_copie) || '; ' || nr_cl3 || ' - ' || initcap(nume3_copie);
    RETURN mesaj;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        IF v_cod_cl1 IS NULL THEN
           mesaj := 'Nu exista client cu numele ' || initcap(nume1) || '!';
        ELSIF v_cod_cl2 IS NULL THEN
           mesaj := 'Nu exista client cu numele ' || initcap(nume2) || '!';
        ELSIF v_cod_cl3 IS NULL THEN
           mesaj := 'Nu exista client cu numele ' || initcap(nume3) || '!';
        ELSE 
           mesaj := 'Nu exista restaurant cu numele ' || initcap(nume_res) || '!';
        END IF;
        RETURN mesaj;
    WHEN TOO_MANY_ROWS THEN
       IF v_cod_cl1 IS NULL THEN
           mesaj := 'Exista mai multi clienti cu numele ' || initcap(nume1) || '!';
        ELSIF v_cod_cl2 IS NULL THEN
           mesaj := 'Exista mai multi clienti cu numele ' || initcap(nume2) || '!';
        ELSIF v_cod_cl3 IS NULL THEN
           mesaj := 'Exista mai multi clienti cu numele ' || initcap(nume3) || '!';
        ELSE 
           mesaj := 'Exista mai multe restaurante cu numele ' || initcap(nume_res) || '!';
        END IF;
        RETURN mesaj;
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
  END top3;
  
  PROCEDURE detalii(nume client.nume_client%TYPE, optiune NUMBER) IS
    TYPE informatii IS RECORD
     (nr_persoane rezervare.nr_persoane%TYPE,
      data_r rezervare.data_rezervare%TYPE,
      data_e eveniment.data_eveniment%TYPE,
      nume_res restaurant.nume_restaurant%TYPE,
      tip_e tip_eveniment.descriere%TYPE);
    v_inf informatii;
    
    CURSOR c(parametru client.nume_client%type) IS
       select  r.nr_persoane, r.data_rezervare , e.data_eveniment, res.nume_restaurant, t.descriere
       from client c,REZERVARE r, EVENIMENT e, RESTAURANT res, FACE f, tip_eveniment t
       where f.cod_rezervare=r.cod_rezervare and f.cod_restaurant=res.cod_restaurant 
        and f.cod_eveniment=e.cod_eveniment and e.cod_tip = t.cod_tip and f.cod_client = c.cod_client and upper(c.nume_client) = upper(parametru);
        
    TYPE comanda_tip IS REF CURSOR RETURN comanda%ROWTYPE;
    v_comanda comanda_tip;
    v_com comanda%ROWTYPE;
    contor NUMBER :=1;
    ok NUMBER := 0;
    TYPE clienti_tab IS TABLE OF istoric_comanda.cod_client%TYPE INDEX BY BINARY_INTEGER;
    coduri_clienti clienti_tab;
    v_cod_client client.cod_client%TYPE;
  BEGIN
    select cod_client
    into v_cod_client
    from client
    where upper(nume_client) = upper(nume);
    
    IF optiune = 1 THEN
        dbms_output.put_line('Rezervari pentru clientul ' || initcap(nume) || ':');
        OPEN c(nume);
        LOOP
           FETCH c INTO v_inf;
           EXIT WHEN c%NOTFOUND;
           dbms_output.put_line(contor || '. Numar persoane: ' ||  v_inf.nr_persoane || ', Data rezervare: ' || v_inf.data_r || ', Data eveniment: ' || v_inf.data_e 
           || ', Nume restaurant: ' || v_inf.nume_res || ', Tip eveniment: ' || v_inf.tip_e);
           contor := contor + 1;
         END LOOP;
         CLOSE c;
    ELSIF optiune = 2 THEN
         dbms_output.put_line('Comenzi pentru clientul ' || initcap(nume) || ':');
         OPEN v_comanda FOR select co.*
                            from comanda co, client c, istoric_comanda i
                            where upper(c.nume_client) = upper(nume) and c.cod_client = i.cod_client and i.cod_comanda = co.cod_comanda;
         LOOP
            FETCH v_comanda INTO v_com;
            EXIT WHEN v_comanda%NOTFOUND;
            dbms_output.put_line(contor || '. Comanda ' || v_com.cod_comanda || ' cu valoarea de ' || v_com.valoare || ' lei, cu tipul platii ' || v_com.tip_plata);
            contor := contor + 1;
         END LOOP;
         CLOSE v_comanda;
     ELSIF optiune = 3 THEN
         select distinct(a.cod_client)
         bulk collect into coduri_clienti
         from istoric_comanda a
         where not exists (select 1
                           from COMANDA c
                           where mod(c.valoare, 10) = 0 and not exists (select 1
                                                                        from istoric_comanda b
                                                                        where c.cod_comanda=b.cod_comanda and b.cod_client=a.cod_client));
         FOR i IN coduri_clienti.FIRST..coduri_clienti.LAST LOOP
              IF coduri_clienti(i) = v_cod_client THEN
                 ok := 1;
              END IF;
         END LOOP;
         IF ok = 1 THEN 
           dbms_output.put_line('Pentru ' || initcap(nume) || ' nu exista comenzi cu valoarea un numar divizibil cu 10 pe care sa nu le fi facut.');
         ELSE
           dbms_output.put_line('Pentru ' || initcap(nume) || ' exista comenzi cu valoarea un numar divizibil cu 10 pe care sa nu le fi facut.');
         END IF;
     ELSE
         dbms_output.put_line('Optiune invalida!');
     END IF;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000,'Nu exista clientul cu numele transmis ca parametru!');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001,'Exista mai multi clienti cu numele transmis ca parametru!');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
  END detalii;
END ex13;

execute ex13.detalii('frusinoiu', 2);

--14. Definiti un pachet care sa permita gestiunea angajatilor (anumite modificari, afisarea unor anumite detalii etc). Pentru aceasta, se vor defini urmatoarele:
-- - Un record in care se vor inregistra numele, prenumele si salariul unui angajat;
-- - O procedura care afiseaza numele, prenumele si salariul unui angajat cu un cod transmis ca parametru;
-- - Un cursor care retine o lista a angajatilor pe un anumit job, ordonati descrescator dupa salariu;
-- - O procedura care afiseaza lista angajatilor in ordine descrescatoare dupa salariu pentru un anumit job al carui cod este transmis ca parametru;
-- - O functie care returneaza codul adresei al carui oras este transmis ca parametru;
-- - O procedura care mareste salariile cu 5% pentru toti angajatii condusi direct
--sau indirect de un manager transmis ca parametru, dintr-un restaurant care are adresa corespunzatoare codului adresei transmis de asemenea ca parametru;
-- - Un tablou indexat ce retine codurile angajatilor din istoricul job-urilor;
-- - O functie care returneaza numarul angajatilor care au avut 2 job-uri de-a lungul timpului;
-- - O functie care returneaza numarul angajatilor dintr-un restaurant al carui cod este transmis ca parametru;
-- - O procedura care modifica salariul unui angajat al carui cod este transmis ca
--parametru. Salariul nou se va transmite si el ca parametru. Acest salariu trebuie sa corespunda limitelor salariale pe job-ul respectiv;
-- - O procedura care marcheaza faptul ca un angajat a fost concediat in ziua respectiva.
-- Exemplificati functionalitatile pachetului prin apeluri corespunzatoare.
CREATE OR REPLACE PACKAGE ex14 IS
   TYPE ang_record IS RECORD(
      nume angajat.nume_angajat%TYPE, 
      prenume angajat.prenume_angajat%TYPE, 
      salariu_maxim angajat.salariu%TYPE);
   PROCEDURE detalii_angajat (cod angajat.cod_angajat%TYPE);
   CURSOR lista_ang(v_job job.cod_job%TYPE) IS
      select *
      from angajat
      where cod_job = v_job
      order by salariu desc;
   PROCEDURE lista_angajati(cod job.cod_job%TYPE);
   FUNCTION codul_adresei(v_oras adresa.oras%TYPE) RETURN adresa.cod_adresa%TYPE;
   PROCEDURE mareste_salariul(cod angajat.cod_angajat%TYPE, adresa_cod adresa.cod_adresa%TYPE);
   TYPE angajati IS TABLE OF istoric_job.cod_angajat%TYPE INDEX BY BINARY_INTEGER;
   FUNCTION nr_ang_cu_2_joburi RETURN NUMBER;
   FUNCTION nr_ang_in_res(cod restaurant.cod_restaurant%TYPE) RETURN NUMBER;
   PROCEDURE update_salariu(cod angajat.cod_angajat%TYPE, salariu_nou angajat.salariu%TYPE);
   PROCEDURE concediaza(cod istoric_job.cod_angajat%TYPE);
END ex14;

CREATE OR REPLACE PACKAGE BODY ex14 IS

   PROCEDURE detalii_angajat(cod angajat.cod_angajat%TYPE) IS
        v_cod angajat.cod_job%TYPE;
        v_angajat ang_record;
   BEGIN
        select cod_angajat
        into v_cod
        from angajat
        where cod_angajat = cod;

        select nume_angajat, prenume_angajat, salariu
        into v_angajat.nume, v_angajat.prenume, v_angajat.salariu_maxim
        from angajat
        where cod_angajat = v_cod;
        
        dbms_output.put_line('Angajatul ' || v_angajat.nume || ' ' || v_angajat.prenume || ' are salariul ' || v_angajat.salariu_maxim || ' lei.');

   EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000,'Nu exista angajat cu codul transmis ca parametru!');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
   END detalii_angajat;
   
   PROCEDURE lista_angajati(cod job.cod_job%TYPE) IS
       nume job.nume_job%TYPE;
       contor NUMBER := 1;
   BEGIN
       select nume_job
       into nume
       from job
       where cod_job = cod;

       dbms_output.put_line('Angajatii cu jobul ' || nume || ', ordonati descrescator dupa salariu:');
       
       FOR i IN lista_ang(cod) LOOP
           dbms_output.put_line(contor || '. Angajatul ' || i.nume_angajat || ' ' || i.prenume_angajat || ', cu salariul ' || i.salariu || '.');
           contor := contor + 1;
       END LOOP;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20000,'Nu exista job cu codul transmis ca parametru!');
       WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
   END lista_angajati;

   FUNCTION codul_adresei(v_oras adresa.oras%TYPE)
   RETURN adresa.cod_adresa%TYPE IS
       v_cod adresa.cod_adresa%TYPE;
   BEGIN
       select cod_adresa
       into v_cod
       from adresa
       where upper(oras) = upper(v_oras);
       
       RETURN v_cod;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20000,'Nu exista adresa in orasul transmis ca parametru!');
       WHEN TOO_MANY_ROWS THEN
          RAISE_APPLICATION_ERROR(-20001,'Exista mai multe adrese in orasul cu numele transmis ca parametru!');
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
   END codul_adresei;

   PROCEDURE mareste_salariul(cod angajat.cod_angajat%TYPE, adresa_cod adresa.cod_adresa%TYPE) IS
       v_cod_restaurant restaurant.cod_restaurant%TYPE;
       v_sef angajat.cod_sef%TYPE;
   BEGIN
       select cod_restaurant
       into v_cod_restaurant
       from restaurant
       where cod_adresa = adresa_cod;

       select cod_angajat
       into v_sef
       from angajat
       where cod_angajat = cod and cod_sef is null;

       update angajat
       set salariu = salariu * 0.05 + salariu
       where cod_sef in (select cod_angajat
                         from angajat
                         start with cod_angajat = cod
                         connect by prior cod_angajat = cod_sef);
                         
       dbms_output.put_line('Update-uri realizate cu succes!');
                         
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20000,'Nu exista manager cu codul transmis ca parametru!');
       WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
   END mareste_salariul;

   FUNCTION nr_ang_cu_2_joburi
   RETURN NUMBER IS
       v_ang angajati;
       cod istoric_job.cod_angajat%TYPE;
       contor NUMBER := 0;
   BEGIN
       select cod_angajat
       bulk collect into v_ang
       from istoric_job
       where data_final is not null;

       FOR i IN v_ang.FIRST..v_ang.LAST LOOP
            select cod_angajat
            into cod
            from istoric_job
            where data_final is null and cod_angajat = v_ang(i);
   
            IF cod = v_ang(i) THEN
               contor := contor + 1;
            END IF;
       END LOOP;
       RETURN contor;
   END nr_ang_cu_2_joburi;
 
   FUNCTION nr_ang_in_res(cod restaurant.cod_restaurant%TYPE) 
   RETURN NUMBER IS
       cod_r restaurant.cod_restaurant%TYPE;
       nr NUMBER;
   BEGIN
       select cod_restaurant
       into cod_r
       from restaurant
       where cod_restaurant = cod;

       select count(*)
       into nr
       from angajat
       where cod_restaurant = cod_r;
       
       RETURN nr;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20000,'Nu exista restaurant cu codul transmis ca parametru!');
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
   END nr_ang_in_res;

   PROCEDURE update_salariu(cod angajat.cod_angajat%TYPE, salariu_nou angajat.salariu%TYPE) IS
       v_cod angajat.cod_angajat%TYPE;
       v_cod_job angajat.cod_job%TYPE;
       limita_inf job.salariu_minim%TYPE;
       limita_sup job.salariu_maxim%TYPE;
   BEGIN
       select cod_angajat
       into v_cod
       from angajat
       where cod_angajat = cod;

       select cod_job
       into v_cod_job
       from angajat
       where cod_angajat = v_cod;

       select salariu_minim, salariu_maxim
       into limita_inf, limita_sup
       from job
       where cod_job = v_cod_job;

       IF (limita_inf is null and limita_sup is null) or (limita_inf is null and salariu_nou <= limita_sup) or 
         (salariu_nou >= limita_inf and limita_sup is null) or (salariu_nou >= limita_inf and salariu_nou <= limita_sup) THEN
            update angajat
            set salariu = salariu_nou
            where cod_angajat = v_cod;
            
            dbms_output.put_line('Update realizat cu succes!');
       ELSE
            dbms_output.put_line('Salariul nou introdus nu este conform limitelor salariale! Limita inferioara: ' 
               || limita_inf || '; Limita superioara: ' || limita_sup);
       END IF;

   EXCEPTION 
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000,'Nu exista angajat cu codul transmis ca parametru!');
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
   END update_salariu;
   
   PROCEDURE concediaza(cod istoric_job.cod_angajat%TYPE) IS
       v_cod istoric_job.cod_angajat%TYPE;
       nr NUMBER;
   BEGIN
       select cod_angajat
       into v_cod
       from istoric_job
       where cod_angajat = cod;
       
       update istoric_job
       set data_final = sysdate
       where cod_angajat = v_cod and data_final is null;
       
       nr := sql%rowcount;
       IF nr = 1 THEN
            dbms_output.put_line('Angajatul ' || v_cod || ' a fost concediat!');
       ELSE
            dbms_output.put_line('Angajatul ' || v_cod || ' a fost deja concediat!');
       END IF;
   EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000,'Nu exista angajat cu codul transmis ca parametru!');
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
   END concediaza;
   
END ex14;

--APELURI
execute ex14.detalii_angajat(30);

execute ex14.detalii_angajat(70);

execute ex14.lista_angajati(1000);

execute ex14.lista_angajati(1090);

BEGIN
  dbms_output.put_line('Codul adresei cu orasul Sinaia: ' || ex14.codul_adresei('Sinaia'));
END;

BEGIN
  dbms_output.put_line('Codul adresei cu orasul Ploiesti: ' || ex14.codul_adresei('Ploiesti'));
END;

BEGIN
  dbms_output.put_line('Codul adresei cu orasul Mizil: ' || ex14.codul_adresei('Mizil'));
END;

DECLARE
v_oras adresa.oras%TYPE := '&oras';
cod_manager angajat.cod_angajat%TYPE := '&cod';
cod_ad adresa.cod_adresa%TYPE;
BEGIN
   cod_ad := ex14.codul_adresei(v_oras);
   ex14.mareste_salariul(cod_manager, cod_ad);
END;

BEGIN
dbms_output.put_line('Numarul angajatilor cu 2 job-uri: ' || ex14.nr_ang_cu_2_joburi);
END;

BEGIN
dbms_output.put_line('Numarul angajatilor din restaurantul cu codul 101: ' || ex14.nr_ang_in_res(101));
END;

BEGIN
dbms_output.put_line('Numarul angajatilor din restaurantul cu codul 120: ' || ex14.nr_ang_in_res(120));
END;

execute ex14.update_salariu(10, 25700);

execute ex14.update_salariu(23, 259);

execute ex14.concediaza(30);

execute ex14.concediaza(39);
