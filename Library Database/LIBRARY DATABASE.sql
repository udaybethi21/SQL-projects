-- creating database
create database if not exists library;
-- using database
use library;

-- creating table tbl_publisher
create table tbl_publisher
( publisher_PublisherName varchar(255) primary key,
publisher_PublisherAddress varchar(255),
publisher_PublisherPhone varchar(20));

-- creating table tbl_borrower
create table tbl_borrower
( borrower_CardNo int auto_increment primary key,
borrower_BorrowerName varchar(255),
borrower_BorrowerAddress varchar(255),
borrower_BorrowerPhone varchar(20));

-- creating table tbl_library_branch
create table tbl_library_branch
( library_branch_BranchID int auto_increment primary key,
library_branch_BranchName varchar(255),
library_branch_BranchAddress varchar(255));

-- creating table tbl_book
create table tbl_book
( book_BookID int auto_increment primary key,
book_Title varchar(255),
book_PublisherName varchar(255),
foreign key (book_PublisherName) references tbl_publisher(publisher_PublisherName)
on delete cascade
on update cascade);

-- creating table tbl_book_authors
create table tbl_book_authors
(book_authors_AuthorID int auto_increment primary key,
book_authors_BookID int,
book_authors_AuthorName varchar(255),
foreign key (book_authors_BookID) references tbl_book(book_BookID)
on delete cascade
on update cascade);

-- creating table tbl_book_copies
create table tbl_book_copies
( book_copies_CopiesID int auto_increment primary key,
book_copies_BookID int,
book_copies_BranchID int,
book_copies_No_Of_Copies int,
foreign key (book_copies_BookID) references tbl_book(book_BookID)
on delete cascade
on update cascade,
foreign key (book_copies_BranchID) references tbl_library_branch(library_branch_BranchID)
on delete cascade
on update cascade);

-- creating table tbl_book_loans
create table tbl_book_loans
( book_loans_LoansID int auto_increment primary key,
book_loans_BookID int,
book_loans_BranchID int,
book_loans_CardNo int,
book_loans_DateOut date,
book_loans_DueDate date,
foreign key (book_loans_BookID) references tbl_book(book_BookID)
on delete cascade
on update cascade,
foreign key (book_loans_BranchID) references tbl_library_branch(library_branch_BranchID)
on delete cascade
on update cascade,
foreign key (book_loans_CardNo) references tbl_borrower(borrower_CardNo) 
on delete cascade
on update cascade);

-- Task Questions
-- How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select b.book_title,l.library_branch_BranchName, sum(c.book_copies_No_Of_Copies)
from tbl_library_branch as l
left join tbl_book_copies as c
on l.library_branch_BranchID = c.book_copies_BranchID
left join tbl_book as b 
on b.book_BookID = c.book_copies_BookID
where b.book_Title = 'The Lost Tribe'
and l.library_branch_BranchName = 'Sharpstown'
group by b.book_Title , l.library_branch_BranchName;

-- How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select b.book_title,l.library_branch_BranchName, sum(c.book_copies_No_Of_Copies)
from tbl_library_branch as l
left join tbl_book_copies as c
on l.library_branch_BranchID = c.book_copies_BranchID
left join tbl_book as b 
on b.book_BookID = c.book_copies_BookID
where b.book_Title = 'The Lost Tribe'
group by b.book_Title , l.library_branch_BranchName;

-- Retrieve the names of all borrowers who do not have any books checked out.
select b.borrower_CardNo , b.borrower_BorrowerName , l.book_loans_DateOut
from tbl_borrower as b
left join tbl_book_loans as l
on b.borrower_CardNo = l.book_loans_CardNo
where l.book_loans_DateOut is null ;

-- For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.
select b.book_Title , br.borrower_BorrowerName , br.borrower_BorrowerAddress
from  tbl_book_loans as bl 
left join tbl_borrower as br 
on br.borrower_CardNo = bl.book_loans_CardNo
left join tbl_book as b
on b.book_BookID = bl.book_loans_BookID
left join tbl_library_branch as l
on l.library_branch_BranchID = bl.book_loans_BranchID
where l.library_branch_BranchName = 'Sharpstown'
and book_loans_DueDate = '2018/2/3';

-- For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select b.library_branch_BranchID, count(l.book_loans_DateOut) as loanedOut
from tbl_library_branch as b
left join tbl_book_loans as l
on l.book_loans_BranchID = b.library_branch_BranchID
group by b.library_branch_BranchID;

-- Retrieve the names, addresses, and number of books checked out for all borrowers who have  more than five books checked out.
select b.borrower_BorrowerName,b.borrower_BorrowerAddress, count(l.book_loans_DateOut) as books_checked_out 
from tbl_borrower as b
left join tbl_book_loans as l
on b.borrower_CardNo = l.book_loans_CardNo
group by b.borrower_BorrowerName , b.borrower_BorrowerAddress
having count(l.book_loans_DateOut) > 5;

-- For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select a.book_authors_AuthorName, b.book_Title , c.book_copies_No_Of_Copies , l.library_branch_BranchName
from tbl_book_authors as a
left join tbl_book as b 
on a.book_authors_AuthorID = b.book_BookID
left join tbl_book_copies as c
on b.book_BookID = c.book_copies_BookID
left join tbl_library_branch as l
on l.library_branch_BranchID = c.book_copies_BranchID
where a.book_authors_AuthorName = "Stephen King" 
and l.library_branch_BranchName ="Central";