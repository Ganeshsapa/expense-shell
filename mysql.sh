#!/bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Please run this script with root priveleges $N" | tee -a $LOG_FILE
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is...$R FAILED $N"  | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}

echo "Script started executing at: $(date)" | tee -a $LOG_FILE

CHECK_ROOT

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabled MySQL Server"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Started MySQL server"

mysql -h mysql.chanakya.blog -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo "MySQL root password is not setup, setting now" &>>$LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "Setting UP root password"
else
    echo -e "MySQL root password is already setup...$Y SKIPPING $N" | tee -a $LOG_FILE
fi

# Assignment
# check MySQL Server is installed or not, enabled or not, started or not
# implement the above things

# LOGS_FOLDER="var/log/expense"
# SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
# TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
# LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
# mkdir -p $LOGS_FOLDER

# #!/bin/bash

# USERID=$(id -u)

# R="\e[31m"
# G="\e[32m"
# G="\e[0m"
# Y="\e[33m"

# CHECK_ROOT(){
# if [ $USERID -ne 0 ]
# then echo "$R Please run this script with root priveleges $N" &>>LOG_FILE

# exit 1
# fi
# }

# VALIDATE()
#    if [ $1 -ne 0 ]
#         then
#             echo " $2 is ..$R FAILED $N" | tee -a $LOG_FILE
#             exit 1
#         else 
#             echo " $2 is ..$R SUCCESS $N" | tee -a $LOG_FILE

#     fi
  
#   echo "Script started executing at: #(date)" | tee -a $LOG_FILE

#   CHECK_ROOT
#   dnf install mysql-server -y &>>LOG_FILE
#   VALIDATE $? "Installing Mysql server" &>>LOG_FILE
  
#   systemctl enable mysqld
#   VALIDATE $? "Enabled Mysql server" &>>LOG_FILE

#   systemctl start mysqld &>>LOG_FILE
#   VALIDATE $? "Started MySQL server"


#   mysql -h 54.82.69.88 -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE
#   if [ $? -ne 0 ]
#   then
#     echo "MySQL root password is not setup, setting now" &>>LOG_FILE
#     mysql_secure_installation --set-root-pass ExpenseApp@1
#     VALIDATE $? "Setting up root password"
# else
#     echo -e "MySQL root password is already setup...$Y SKIPPING $N" | tee -a &>>LOG_FILE
# fi
