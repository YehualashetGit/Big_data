setwd("~/Documents/R/Assign/assign_one/")
library(DBI)
library(RMySQL)
# connecting to the database
mydb <- dbConnect(MySQL(), user='yehuala', password='', dbname='big_data', host='localhost')
#Listing Tables and Fields:

# dbListTables(mydb)
dbListTables(mydb)

## create tables
dbSendQuery(mydb,"CREATE TABLE Author
            (AuthorID INT NOT NULL , 
        AuthorName VARCHAR(50) NOT NULL,
	    PRIMARY KEY (AuthorID)
    ) ")
dbSendQuery(mydb,"CREATE TABLE Category
            (CategoryID INT NOT NULL , 
        CategoryDesc VARCHAR(50) NOT NULL,
	    PRIMARY KEY (CategoryID)
    ) ")

dbSendQuery(mydb,"CREATE TABLE Book
            (BookID INT NOT NULL , 
            CategoryID INT NOT NULL,
            Title VARCHAR(50) NOT NULL,
            ISBN VARCHAR(50) NOT NULL,
            Year VARCHAR(50) NOT NULL,
            Price VARCHAR(50) NOT NULL,
            BookDesc VARCHAR(50) NOT NULL,
	          PRIMARY KEY (BookID)
    ) ")


dbSendQuery(mydb,"ALTER TABLE Book   ADD  CONSTRAINT cat_CategoryID 
                          FOREIGN KEY(CategoryID)
                          REFERENCES Category (CategoryID)")


#Insert Data to the databse
dbSendQuery(mydb,"
                   INSERT INTO Author 
	(AuthorID,AuthorName)
VALUES 
	(1, 'Clarissa Johal'),
	(2, 'Laura A. Barnes'),
	(3, 'Cecelia Hor'),
	(4, 'CM Skiera')
            ")

dbSendQuery(mydb,"
                   INSERT INTO Category 
	(CategoryID, CategoryDesc)
VALUES 
	(1, 'Computer'),
	(2, 'Science' ),
	(3, 'Programming'),
	(4, 'Fiction')
 ")

dbSendQuery(mydb,"
                   INSERT INTO Book 
	(BookID, CategoryID, Title, ISBN,Year,Price,BookDesc)
VALUES 
    (1,1,'Computer Architecture', '123dc','1990','14.90','Programming'),
    (2 ,2,'Advanced Composite Materials', '245ff', '1725', '150','Scence'),
    (3,3,'Asp.Net 4 Blue Book', '35hC', '1990','199','Fiction'),
    (4,4,'Strategies Unplugged', '4fhf', '1990','223','Computer')
                   ")



## Retrieving data from MySQL:
dbClearResult(rs)
rs <- dbSendQuery(mydb, "select * from Employee")
while(!dbHasCompleted(rs)){
  chunk <- dbFetch(rs)
  print(nrow(chunk))
}

dbClearResult(rs)


## Display the data
rs <- dbSendQuery(mydb, "select * from Author")
while(!dbHasCompleted(rs)){
  chunk <- dbFetch(rs)
  print(nrow(chunk))
  View(chunk)
}

rsTwo <- dbSendQuery(mydb, "select * from Category")
while(!dbHasCompleted(rsTwo)){
  chunkTwo <- dbFetch(rsTwo)
  print(nrow(chunkTwo))
  View(chunkTwo)
}

rsThree <- dbSendQuery(mydb, "select * from Book")
while(!dbHasCompleted(rsThree)){
  chunkThree <- dbFetch(rsThree)
  print(nrow(chunkThree))
  View(chunkThree)
}

# Delete Column
dbSendQuery(mydb,"ALTER TABLE Author DROP COLUMN sex")


## this will show the summary
RMySQL::summary(mydb)

## append data to the table in the database
dbSendQuery(mydb, "alter table Author add column sex Varchar(50)")
sex <- factor(c("M","F", "M","F"), levels = c("M", "F"))
authors <- cbind(rs, sex)
test_df <- data.frame(
  AuthorName = c('nick', 'sam')
  , sex = c("M","F", "M","F")
)
dbWriteTable(mydb
             , name = 'Author'
             , value = test_df
             , row.names = FALSE
             , append = TRUE
)

dbSendQuery(mydb,"CREATE TABLE sales
            (cust_id INT NOT NULL , 
        sales_total VARCHAR(50) NOT NULL,
        num_of_orders VARCHAR(50) NOT NULL,
        gender VARCHAR(50) NOT NULL,
	    PRIMARY KEY (cust_id)
    ) ")
testCsv <- read.csv('./test.csv')
# APPEND R DATA FRAME TO TEMP DATA
dbWriteTable(mydb, value=testCsv, name='sales', row.names=FALSE,
             field.types=list(cust_id="VARCHAR(10)", sales_total="VARCHAR(255)", 
                              num_of_orders="VARCHAR(255)", gender="VARCHAR(255)"), 
             append=TRUE, overwrite=FALSE)

## Update query
dbSendQuery(mydb,"UPDATE   Author SET sex='F'WHERE AuthorID=4")

# Remove Table 
dbRemoveTable(mydb,"newTable")












