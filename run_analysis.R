###### STEP 1

test_files <- list.files(path="./test",pattern="[.]txt",full.names=TRUE)
train_files <- list.files(path="./train",pattern="[.]txt",full.names=TRUE)
	##read 3 files from test folder
read_all <- lapply(test_files,read.table)
test_data <- do.call(cbind, read_all)
	##read 3 files from train folder
read_all <- lapply(train_files,read.table)
train_data <- do.call(cbind, read_all)
	##join the two data frames by row
all_data <- rbind(test_data,train_data)

###### STEP 4

	##add the appropriate column labels from features.txt
column_names = read.table("features.txt")
colnames(all_data) <- c("Subject", as.character(unlist(column_names[2])), "Activity")

###### STEP 3

	##Convert last column to factor with named activity values
activity_names <- read.table("activity_labels.txt")
all_data$Activity<-factor(all_data$Activity,labels=as.character(unlist(activity_names[2])))

###### STEP 2

	##keep only columns measuring mean and std (as well as subject and activity)
which_columns<-grepl("mean\\(\\)|std\\(\\)|Subject|Activity",names(all_data))
all_data<-all_data[,which_columns]

##Group the data by subject and activity, then write to .txt file
tidy_data <- all_data %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))
write.table(tidy_data, "./tidy_data.txt",sep="\t",row.names=FALSE)