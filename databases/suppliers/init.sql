create table Suppliers
(
SupplierID char(2) primary key,
SupplierName char(6),
SupplierCity char(6),
SupplierDiscount decimal(2)
);
go

create table Parts
(
PartID char(2) primary key,
PartName char(8),
PartColor char(5),
PartPrice smallmoney,
PartCity char(6)
);
go

create table SupplierParts
(
SupplierID char(2) references Suppliers(SupplierID),
PartID char(2) references Parts(PartID),
Amount decimal(4),
primary key (SupplierID, PartID)
);
go

insert into Suppliers
(SupplierID, SupplierName, SupplierCity, SupplierDiscount)
values
('L1' , 'Schmid' , 'London' , 20)
, ('L2' , 'Jonas' , 'Paris' , 10)
, ('L3' , 'Berger' , 'Paris' , 30)
, ('L4' , 'Klein' , 'London' , 20)
, ('L5' , 'Adam' , 'Athen' , 30)
;
go

insert into Parts
(PartID, PartName , PartColor, PartPrice, PartCity)
values
  ('T1' , 'Mutter' , 'rot' , 12, 'London')
, ('T2' , 'Bolzen' , 'gelb' , 17, 'Paris' )
, ('T3' , 'Schraube', 'blau' , 17, 'Rom' )
, ('T4' , 'Schraube', 'rot' , 14, 'London')
, ('T5' , 'Welle' , 'blau' , 12, 'Paris' )
, ('T6' , 'Zahnrad' , 'rot' , 19, 'London')
;
go

insert into SupplierParts
(SupplierID, PartID, Amount)
values
  ('L1' , 'T1' , 300)
, ('L1' , 'T2' , 200)
, ('L1' , 'T3' , 400)
, ('L1' , 'T4' , 200)
, ('L1' , 'T5' , 100)
, ('L1' , 'T6' , 100)
, ('L2' , 'T1' , 300)
, ('L2' , 'T2' , 400)
, ('L3' , 'T2' , 200)
, ('L4' , 'T2' , 200)
, ('L4' , 'T4' , 300)
, ('L4' , 'T5' , 400)
;
go