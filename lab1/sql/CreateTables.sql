create table Dim_Timp(
	id				int not null identity(1, 1),
	zi				tinyint not null,
	luna			tinyint not null,
	saptamana		tinyint not null,
	an				int not null,
	data_concreta	date not null,

	constraint Dim_Timp_PK
    primary key (id)
);

create table Dim_Locatie(
	id			int not null identity(1, 1),
	locatie		nvarchar(256) not null,
	zona		nvarchar(256) not null,
	tara		nvarchar(256) not null,

	constraint Dim_Location_PK
    primary key (id)
);

create table Fact_Bilet(
	id					      int not null identity(1, 1),
	vinzare_volum			  money not null,
	vinzare_cantitati_bilete  int not null,
	locatie_id				  int not null,
	timp_id					  int not null,
	
	constraint Fact_Bilet_PK
    primary key (id),

	constraint Fact_Bilet_FK_Dim_Locatie
    foreign key (locatie_id)
    references Dim_Locatie (id),

	constraint Fact_Bilet_FK_Dim_Timp
    foreign key (timp_id)
    references Dim_Timp (id),
);


