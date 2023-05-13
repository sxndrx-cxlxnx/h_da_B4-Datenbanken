/*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     13.05.2023 16:40:35                          */
/*==============================================================*/


drop index ASSOCIATION_13_FK;

drop index EPISODE_PK;

drop table Episode cascade;

drop index ASSOCIATION_14_FK;

drop index ASSOCIATION_12_FK;

drop table Hauptschauspieler cascade;

drop index KUENSTLER_PK;

drop table Kuenstler cascade;

drop index KUNDE_PK;

drop table Kunde cascade;

drop index SENDER_PK;

drop table Sender cascade;

drop index ASSOCIATION_15_FK;

drop index SERIE_PK;

drop table Serie cascade;

drop index STREAMINGDIENST_PK;

drop table Streamingdienst cascade;

drop index HAT_FK;

drop index HAT2_FK;

drop index VERTRAG_PK;

drop table Vertrag cascade;

drop index ASSOCIATION_11_FK;

drop index ASSOCIATION_10_FK;

drop index AUSGESTRAHLT_PK;

drop table ausgestrahlt cascade;

drop index ASSOCIATION_9_FK;

drop index AUSGESTRAHLT_FK2;

drop index AUSGESTRAHLT_FK;

drop table bietet_an cascade;

/*==============================================================*/
/* Table: Episode                                               */
/*==============================================================*/
create table Episode (
   Serienname           VARCHAR(254)         not null,
   EpisodenNr           INT4                 not null,
   Staffel              INT4                 not null,
   Titel                VARCHAR(254)         not null,
   IMDB_Rating          NUMERIC              null,
   constraint PK_EPISODE primary key (Serienname, EpisodenNr, Staffel)
);

/*==============================================================*/
/* Index: EPISODE_PK                                            */
/*==============================================================*/
create unique index EPISODE_PK on Episode (
Serienname,
EpisodenNr,
Staffel
);

/*==============================================================*/
/* Index: ASSOCIATION_13_FK                                     */
/*==============================================================*/
create  index ASSOCIATION_13_FK on Episode (
Serienname
);

/*==============================================================*/
/* Table: Hauptschauspieler                                     */
/*==============================================================*/
create table Hauptschauspieler (
   Serienname           VARCHAR(254)         not null,
   Hauptschauspieler_ID INT4                 not null,
   constraint PK_HAUPTSCHAUSPIELER primary key (Serienname, Hauptschauspieler_ID)
);

/*==============================================================*/
/* Index: ASSOCIATION_12_FK                                     */
/*==============================================================*/
create  index ASSOCIATION_12_FK on Hauptschauspieler (
Hauptschauspieler_ID
);

/*==============================================================*/
/* Index: ASSOCIATION_14_FK                                     */
/*==============================================================*/
create  index ASSOCIATION_14_FK on Hauptschauspieler (
Serienname
);

/*==============================================================*/
/* Table: Kuenstler                                             */
/*==============================================================*/
create table Kuenstler (
   Kuenstler_ID         INT4                 not null,
   Vorname              VARCHAR(254)         not null,
   Nachname             VARCHAR(254)         not null,
   constraint PK_KUENSTLER primary key (Kuenstler_ID)
);

/*==============================================================*/
/* Index: KUENSTLER_PK                                          */
/*==============================================================*/
create unique index KUENSTLER_PK on Kuenstler (
Kuenstler_ID
);

/*==============================================================*/
/* Table: Kunde                                                 */
/*==============================================================*/
create table Kunde (
   E_Mail               VARCHAR(254)         not null,
   Kundenart            VARCHAR(254)         not null,
   constraint PK_KUNDE primary key (E_Mail)
);

/*==============================================================*/
/* Index: KUNDE_PK                                              */
/*==============================================================*/
create unique index KUNDE_PK on Kunde (
E_Mail
);

/*==============================================================*/
/* Table: Sender                                                */
/*==============================================================*/
create table Sender (
   Sendername           VARCHAR(254)         not null,
   constraint PK_SENDER primary key (Sendername)
);

/*==============================================================*/
/* Index: SENDER_PK                                             */
/*==============================================================*/
create unique index SENDER_PK on Sender (
Sendername
);

/*==============================================================*/
/* Table: Serie                                                 */
/*==============================================================*/
create table Serie (
   Serienname           VARCHAR(254)         not null,
   Stoffentwickler_ID   INT4                 not null,
   constraint PK_SERIE primary key (Serienname)
);

/*==============================================================*/
/* Index: SERIE_PK                                              */
/*==============================================================*/
create unique index SERIE_PK on Serie (
Serienname
);

/*==============================================================*/
/* Index: ASSOCIATION_15_FK                                     */
/*==============================================================*/
create  index ASSOCIATION_15_FK on Serie (
Stoffentwickler_ID
);

/*==============================================================*/
/* Table: Streamingdienst                                       */
/*==============================================================*/
create table Streamingdienst (
   SD_Name              VARCHAR(254)         not null,
   constraint PK_STREAMINGDIENST primary key (SD_Name)
);

/*==============================================================*/
/* Index: STREAMINGDIENST_PK                                    */
/*==============================================================*/
create unique index STREAMINGDIENST_PK on Streamingdienst (
SD_Name
);

/*==============================================================*/
/* Table: Vertrag                                               */
/*==============================================================*/
create table Vertrag (
   Vertrags_ID          INT4                 not null,
   SD_Name              VARCHAR(254)         not null,
   E_Mail               VARCHAR(254)         not null,
   Monatspreis          MONEY                not null,
   Vertragslaufzeit     DATE                 not null,
   constraint PK_VERTRAG primary key (Vertrags_ID)
);

/*==============================================================*/
/* Index: VERTRAG_PK                                            */
/*==============================================================*/
create unique index VERTRAG_PK on Vertrag (
Vertrags_ID
);

/*==============================================================*/
/* Index: HAT2_FK                                               */
/*==============================================================*/
create  index HAT2_FK on Vertrag (
E_Mail
);

/*==============================================================*/
/* Index: HAT_FK                                                */
/*==============================================================*/
create  index HAT_FK on Vertrag (
SD_Name
);

/*==============================================================*/
/* Table: ausgestrahlt                                          */
/*==============================================================*/
create table ausgestrahlt (
   Ausstrahlungsnummer  INT4                 not null,
   Sendername           VARCHAR(254)         not null,
   Serienname           VARCHAR(254)         not null,
   EpisodenNr           INT4                 not null,
   Staffel              INT4                 not null,
   Startzeit            TIMESTAMP            not null,
   Endzeit              TIMESTAMP            not null,
   constraint PK_AUSGESTRAHLT primary key (Ausstrahlungsnummer)
);

/*==============================================================*/
/* Index: AUSGESTRAHLT_PK                                       */
/*==============================================================*/
create unique index AUSGESTRAHLT_PK on ausgestrahlt (
Ausstrahlungsnummer
);

/*==============================================================*/
/* Index: ASSOCIATION_10_FK                                     */
/*==============================================================*/
create  index ASSOCIATION_10_FK on ausgestrahlt (
Serienname,
EpisodenNr,
Staffel
);

/*==============================================================*/
/* Index: ASSOCIATION_11_FK                                     */
/*==============================================================*/
create  index ASSOCIATION_11_FK on ausgestrahlt (
Sendername
);

/*==============================================================*/
/* Table: bietet_an                                             */
/*==============================================================*/
create table bietet_an (
   SD_Name              VARCHAR(254)         not null,
   Serienname           VARCHAR(254)         not null,
   EpisodenNr           INT4                 not null,
   Staffel              INT4                 not null,
   constraint PK_BIETET_AN primary key (Serienname, EpisodenNr, SD_Name, Staffel)
);

/*==============================================================*/
/* Index: AUSGESTRAHLT_FK                                       */
/*==============================================================*/
create  index AUSGESTRAHLT_FK on bietet_an (
Serienname,
EpisodenNr,
Staffel
);

/*==============================================================*/
/* Index: AUSGESTRAHLT_FK2                                      */
/*==============================================================*/
create  index AUSGESTRAHLT_FK2 on bietet_an (
SD_Name
);

/*==============================================================*/
/* Index: ASSOCIATION_9_FK                                      */
/*==============================================================*/
create  index ASSOCIATION_9_FK on bietet_an (
Serienname,
EpisodenNr,
Staffel
);

alter table Episode
   add constraint FK_EPISODE_ASSOCIATI_SERIE foreign key (Serienname)
      references Serie (Serienname)
      on delete restrict on update restrict;

alter table Hauptschauspieler
   add constraint FK_HAUPTSCH_ASSOCIATI_KUENSTLE foreign key (Hauptschauspieler_ID)
      references Kuenstler (Kuenstler_ID)
      on delete restrict on update restrict;

alter table Hauptschauspieler
   add constraint FK_HAUPTSCH_ASSOCIATI_SERIE foreign key (Serienname)
      references Serie (Serienname)
      on delete restrict on update restrict;

alter table Serie
   add constraint FK_SERIE_ASSOCIATI_KUENSTLE foreign key (Stoffentwickler_ID)
      references Kuenstler (Kuenstler_ID)
      on delete restrict on update restrict;

alter table Vertrag
   add constraint FK_VERTRAG_HAT_STREAMIN foreign key (SD_Name)
      references Streamingdienst (SD_Name)
      on delete restrict on update restrict;

alter table Vertrag
   add constraint FK_VERTRAG_HAT2_KUNDE foreign key (E_Mail)
      references Kunde (E_Mail)
      on delete restrict on update restrict;

alter table ausgestrahlt
   add constraint FK_AUSGESTR_ASSOCIATI_EPISODE foreign key (Serienname, EpisodenNr, Staffel)
      references Episode (Serienname, EpisodenNr, Staffel)
      on delete restrict on update restrict;

alter table ausgestrahlt
   add constraint FK_AUSGESTR_ASSOCIATI_SENDER foreign key (Sendername)
      references Sender (Sendername)
      on delete restrict on update restrict;

alter table bietet_an
   add constraint FK_BIETET_A_ASSOCIATI_STREAMIN foreign key (SD_Name)
      references Streamingdienst (SD_Name)
      on delete restrict on update restrict;

alter table bietet_an
   add constraint FK_BIETET_A_ASSOCIATI_EPISODE foreign key (Serienname, EpisodenNr, Staffel)
      references Episode (Serienname, EpisodenNr, Staffel)
      on delete restrict on update restrict;

alter table bietet_an
   add constraint FK_BIETET_A_AUSGESTRA_EPISODE foreign key (Serienname, EpisodenNr, Staffel)
      references Episode (Serienname, EpisodenNr, Staffel)
      on delete restrict on update restrict;

alter table bietet_an
   add constraint FK_BIETET_A_AUSGESTRA_STREAMIN foreign key (SD_Name)
      references Streamingdienst (SD_Name)
      on delete restrict on update restrict;

