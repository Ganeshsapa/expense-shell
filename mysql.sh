#!/bin/bash

LOGS_FOLDER="var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
G="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
if [ $USERID -ne 0 ]
then echo "$R Please run this script with root priveleges $N" &>>LOG_FILE

exit 1
fi
}

VALIDATE()
{   if [ $1 -ne 0 ]
        then
            echo " $2 is ..$R FAILED $N" | tee -a $LOG_FILE
            exit 1
        else 
            echo " $2 is ..$R SUCCESS $N" | tee -a $LOG_FILE

    fi
  
  echo "Script started executing at: #(date)" | tee -a $LOG_FILE

  CHECK_ROOT