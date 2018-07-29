#loading data
xtrain<-read.table("C:\\Users\\Sony\\Documents\\UCI HAR Dataset\\train\\X_train.txt",header=FALSE)
xtest<-read.table("C:\\Users\\Sony\\Documents\\UCI HAR Dataset\\test\\X_test.txt",header=FALSE)
ytrain<-read.table("C:\\Users\\Sony\\Documents\\UCI HAR Dataset\\train\\y_train.txt",header=FALSE)
ytest<-read.table("C:\\Users\\Sony\\Documents\\UCI HAR Dataset\\test\\y_test.txt",header=FALSE)
subtest<-read.table("C:\\Users\\Sony\\Documents\\UCI HAR Dataset\\test\\subject_test.txt",header=FALSE)
subtrain<-read.table("C:\\Users\\Sony\\Documents\\UCI HAR Dataset\\train\\subject_train.txt",header=FALSE)
act<-read.table("C:\\Users\\Sony\\Documents\\UCI HAR Dataset\\activity_labels.txt")
names(act)<-c("ID","label")
#loading the features
feature<-read.table("C:\\Users\\Sony\\Documents\\UCI HAR Dataset\\features.txt")
feature[,2]<-as.character(feature[,2])
#combining the data set
train <- cbind(subtrain,xtrain,ytrain)
test<-cbind(subtest,xtest,ytest)
combined_data<-rbind(train,test)
colnames(combined_data)=c("subject",feature[,2],"activity")
#Extracting only the measurements on the mean and standard deviation 
desiredfeature<-grepl("subject|activity|mean|std",colnames(combined_data))
combined_data<-combined_data[,desiredfeature]
#replace activity values with named factor labels
combined_data$activity <- factor(combined_data$activity, levels = act[, 1], labels = act[, 2])
#cleaning columnnames
cname<- colnames(combined_data)
cname<-gsub("[-()]","",cname)
#descriptive colnames
cname<- gsub("^f", "frequencyDomain",cname)
cname<- gsub("^t", "timeDomain",cname)
cname <- gsub("Acc", "Accelerometer",cname)
cname<- gsub("Gyro", "Gyroscope",cname)
cname <- gsub("Mag", "Magnitude",cname)
cname<- gsub("Freq", "Frequency",cname)
cname<- gsub("mean", "Mean",cname)
cname<- gsub("std", "StandardDeviation",cname)
colnames(combined_data)<-cname
cname<-gsub("[-()]","",cname)
cname <- gsub("BodyBody", "Body",cname)
colnames(combined_data)<-cname
Means <- combined_data%>% group_by(subject, activity) %>%summarise_each(funs(mean))
# output to file "tidy_data.txt"
write.table(Means, "tidy_data.txt", row.names = FALSE,quote = FALSE)
