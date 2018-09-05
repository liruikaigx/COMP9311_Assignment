-- COMP9311 18s2 Assignment 1
-- Schema for the myPhotos.net photo-sharing site
--
-- Written by:
--    Name:  <<YOUR NAME GOES HERE>>
--    Student ID:  <<YOUR STUDENT ID GOES HERE>>
--    Date:  ??/09/2018
--
-- Conventions:
-- * all entity table names are plural
-- * most entities have an artifical primary key called "id"
-- * foreign keys are named after either:
--   * the relationship they represent
--   * the table being referenced

-- Domains (you may add more)

create domain URLValue as
	varchar(100) check (value like 'http://%');

create domain EmailValue as
	varchar(100) check (value like '%@%.%');

create domain GenderValue as
	varchar(6) check (value in ('male','female'));

create domain GroupModeValue as
	varchar(15) check (value in ('private','by-invitation','by-request'));

create domain ContactListTypeValue as
	varchar(10) check (value in ('friends','family'));

create domain NameValue as varchar(50);

create domain LongNameValue as varchar(100);

create domain VisibilityValue as
    varchar(15) check (value in ('private','friends','family','friends+family','public'));

create domain SafetylevelValue as 
    varchar(10) check (value in ('safe','moderate','restricted'));

create domain RatingValue as 
    char(1) check (value ~ '[1-5]');

-- Tables (you must add more)

create table People (
	id                     serial,
	FamilyName             NameValue,
	GivenName              NameValue not null,
	DisplayedName          LongNameValue,
	EmailAddress           EmailValue not null unique,
	primary key (id)
);

create table Users (
	id                     integer references People(id),
	photoid                integer,
	website                URLValue unique,
	DateRegistered         Date,
	gender                 GenderValue,
	birthday               Date,
	password               text not null,
	primary key (id)
);

create table Discussions (
	id                     serial,
	title                  NameValue,
    primary key (id)
);

create table Photos (
	id                serial,
	userid            integer not null,
	discussionid      integer,       
	title             NameValue not null,
	FileSize          integer not null,
	visibility        VisibilityValue,
	DateTaken         Date,
	DateUploaded      Date,
	description       text,
	SafetyLevel       SafetylevelValue,
	TechnicalDetails  text,
	primary key (id),
	foreign key (userid) references Users(id),
	foreign key (discussionid) references Discussions(id)
);

create table Groups (
	id                serial,
    userid            integer not null,
    mode              GroupModeValue not null,
    title             text not null,
    primary key (id),
    foreign key (userid) references Users(id)	
);

create table GroupHasDiscussion (
	discussionid      integer,
	groupid           integer,
	title             NameValue not null,
	primary key (discussionid, groupid),
	foreign key (discussionid) references Discussions(id),
	foreign key (groupid) references Groups(id)
);

create table group_users (
    groupid           integer,
    userid            integer not null,
    primary key (groupid, userid),
    foreign key (groupid) references Groups(id),
    foreign key (userid) references Users(id)
);

create table ContactLists (
	id                serial,
    userid            integer not null,
    type              ContactListTypeValue,
    title             text not null,
    primary key (id),
    foreign key (userid) references Users(id)
);

create table contact_people (
    contactid         integer,
    peopleid          integer not null,
    primary key (contactid, peopleid),
    foreign key (contactid) references ContactLists(id),
    foreign key (peopleid) references People(id)
);

alter table Users add constraint FK_constraint
	foreign key (photoid) references Photos(id)
;

create table Rates (
	photoid           integer,
	userid            integer,
	WhenRated         timestamp,
	rating            RatingValue,
	primary key (photoid, userid),
	foreign key (photoid) references Photos(id),
	foreign key (userid) references Users(id)
);

create table Tags (
	id                serial,
	name              NameValue not null,
	freq              integer not null,
	primary key (id)
);

create table PhotoHasTag (
	userid            integer not null,
	tagid             integer,
	photoid           integer not null,
	WhenTagged        timestamp,
	primary key (tagid, photoid, userid),
	foreign key (tagid) references Tags(id),
	foreign key (photoid) references Photos(id),
	foreign key (userid) references Users(id)
);

create table Collections (
	id                serial, 
	photoid           integer not null,
	title             NameValue not null,
	description       text,
	primary key (id),
	foreign key (photoid) references Photos(id)
);

create table UserCollection (
	collectionid      integer,
	userid            integer not null,
	primary key (collectionid),
	foreign key (collectionid) references Collections(id),
	foreign key (userid) references Users(id)
);

create table GroupCollection (
	collectionid      integer,
	groupid           integer not null,
	primary key (collectionid),
	foreign key (collectionid) references Collections(id),
	foreign key (groupid) references Groups(id)
);

create table PhotoInCollection (
	collectionid      integer,
	photoid           integer,
    "order"           integer not null check ("order" > 0),
	primary key (collectionid, photoid),
	foreign key (collectionid) references Collections(id),
	foreign key (photoid) references Photos(id)
);

create table Comments (
	id                serial,
	CommentId         integer,
	userid            integer not null,
	discussionid      integer not null,
	content           text,
	WhenPosted        timestamp not null,
	primary key (id),
	foreign key (discussionid) references Discussions(id),
	foreign key (userid) references Users(id),
	foreign key (CommentId) references Comments(id)
);





