library(dplyr)

# load test data
test.dat<-read.table("test/X_test.txt",header=FALSE,stringsAsFactors=FALSE)
test.sub<-read.table("test/subject_test.txt",header=FALSE,stringsAsFactors=FALSE)
test.act<-read.table("test/y_test.txt",header=FALSE,stringsAsFactors=FALSE)
# merge data
test.full<-cbind(test.sub,test.act,test.dat)

# load train data
train.dat<-read.table("train/X_train.txt",header=FALSE,stringsAsFactors=FALSE)
train.sub<-read.table("train/subject_train.txt",header=FALSE,stringsAsFactors=FALSE)
train.act<-read.table("train/y_train.txt",header=FALSE,stringsAsFactors=FALSE)
# merge data
train.full<-cbind(train.sub,train.act,train.dat)

# merge two datasets
full.dat<-rbind(train.full,test.full)
# make better variable names
features<-read.table("features.txt",header=FALSE,stringsAsFactors=FALSE)
colnames(full.dat)<-c("Subject","Activity",features[,2])

# load activity descriptions
act.lab<-read.table("activity_labels.txt",header=FALSE,stringsAsFactors=FALSE)
# replace activity codes with activity labels
full.dat$Activity<-act.lab$V2[full.dat$Activity]

# extract just the mean and std measurements
get.it<-grep("(-mean\\(\\))|(-std\\(\\))",colnames(full.dat),perl=TRUE)
red.dat<-full.dat[,c(1,2,get.it)]
# get rid of brackets and replace dashes with underscores
colnames(red.dat)<-gsub("\\(|\\)","",colnames(red.dat))
colnames(red.dat)<-gsub("-","_",colnames(red.dat),fixed=TRUE)
# get rid of seemingly redundant extra "Body" in some of the names
colnames(red.dat)[63:68]<- c("fBodyAccJerkMag_mean",
                             "fBodyAccJerkMag_std",
                             "fBodyGyroMag_mean",
                             "fBodyGyroMag_std",
                             "fBodyGyroJerkMag_mean",
                             "fBodyGyroJerkMag_std")

# use dplyr to get means by Subject and Activity
# group_by sets groups to be used in subsequent functions
# summarise_each applies a function to each column by group, in this case: mean
dat.means<-group_by(red.dat,Subject,Activity) %.% summarise_each("mean")

# write tidy dataset to csv file for uploading...
write.csv(dat.means,"Dinnage_GCDR_Assignment_tidyData.csv",row.names=FALSE)


