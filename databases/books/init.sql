drop table if exists TitlesAuthors;
drop table if exists Titles;
drop table if exists Authors;
go

create table Titles (
  ISBN10   char(10)    not null primary key
, Title    varchar(48) not null
, Language char(2)     not null
);

create table Authors (
  AuthorCode int         not null primary key
, AuthorName varchar(32) not null
);
go

create table TitlesAuthors (
  ISBN10     char(10) not null references Titles(ISBN10)
, AuthorCode int      not null references Authors(AuthorCode)
, primary key (ISBN10, AuthorCode)
);
go

set nocount on;
go

begin transaction;

insert into Authors
  (AuthorCode, AuthorName           )
values
  (         1, 'Leo Perutz'         )
, (         2, 'Paul Frank'         )
, (         3, 'John Green'         )
, (         4, 'Benjamin Hoff'      )
, (         5, 'Geoffrey James'     )
, (         6, 'Andy Stanton'       )
, (         7, 'Georges Simenon'    )
, (         8, 'Italo Calvino'      )
, (         9, 'Heimito von Doderer')
, (        10, 'Antal Szerb'        )
, (        11, 'Walter Kappacher'   )
, (        12, 'Sven Regener'       )
, (        13, 'Haruki Murakami'    )
, (        14, 'Joseph Roth'        )
, (        15, 'Ernst Weiß'         )
, (        16, 'Ryuichiro Utsumi'   )
, (        17, 'Ryunosuke Akutagawa')
, (        18, 'Lion Feuchtwanger'  )
;

commit;
go

begin transaction;

insert titles
  (ISBN10,       Title                                 , Language)
values
  ('014241493X', 'Paper Towns'                         ,     'en')
, ('0416199259', 'The Tao of Pooh and the Te of Piglet',     'en')
, ('0931137071', 'The Tao of Programming'              ,     'de')
, ('1405223103', 'You''re a Bad Man, Mr Gum!'          ,     'en')
, ('3257238606', 'Maigret und der Clochard'            ,     'de')
, ('3423107421', 'Der Ritter, den es nicht gab'        ,     'de')
, ('3423114118', 'Die Wasserfälle von Slunj'           ,     'de')
, ('3423131608', 'Der schwedische Reiter'              ,     'de')
, ('3423135794', 'Die dritte Kugel'                    ,     'de')
, ('3423136200', 'Reise im Mondlicht'                  ,     'de')
, ('3423138726', 'Selina oder Das andere Leben'        ,     'de')
, ('3426601001', 'Das Mangobaumwunder'                 ,     'de')
, ('3442453305', 'Herr Lehmann'                        ,     'de')
, ('3442730503', 'Naokos Lächeln'                      ,     'de')
, ('3446234772', 'Margos Spuren'                       ,     'de')
, ('3462034901', 'Die Geschichte von der 1002. Nacht'  ,     'de')
, ('3518395041', 'Der arme Verschwender'               ,     'de')
, ('3551789762', 'Von der Natur des Menschen'          ,     'de')
, ('3630620124', 'Rashomon'                            ,     'de')
, ('374665632X', 'Der falsche Nero'                    ,     'de')
, ('3746656362', 'Goya'                                ,     'de')
;

commit;
go

begin transaction;

insert into TitlesAuthors
  (ISBN10      , AuthorCode)
values
  ('014241493X',          3)
, ('0416199259',          4)
, ('0931137071',          5)
, ('1405223103',          6)
, ('3257238606',          7)
, ('3423107421',          8)
, ('3423114118',          9)
, ('3423131608',          1)
, ('3423135794',          1)
, ('3423136200',         10)
, ('3423138726',         11)
, ('3426601001',          1)
, ('3426601001',          2)
, ('3442453305',         12)
, ('3442730503',         13)
, ('3446234772',          3)
, ('3462034901',         14)
, ('3518395041',         15)
, ('3551789762',         16)
, ('3630620124',         17)
, ('374665632X',         18)
, ('3746656362',         18)
;

commit;
go
