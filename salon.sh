#!/bin/bash

echo -e "\n~~~~~ MY SALON ~~~~~\n"

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICES_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
    echo -e "\nWelcome to My Salon, how can I help you?\n"

    SERVICES_INFO=$($PSQL "SELECT * FROM services")
    echo "$SERVICES_INFO" | while read SERVICE_ID BAR SERVICE_NAME
    do  
      echo "$SERVICE_ID) $SERVICE_NAME"
    done

    echo "6) exit"

    read SERVICE_ID_SELECTED

    case $SERVICE_ID_SELECTED in 
      1) CUT_MENU ;;
      2) COLOR_MENU ;;
      3) PERM_MENU ;;
      4) STYLE_MENU ;;
      5) TRIM_MENU ;;
      6) EXIT ;;
      *) SERVICES_MENU "Please enter a valid option." ;;
    esac
    
}

CUT_MENU(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # if not found
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for phone number, what's your name?"
    read CUSTOMER_NAME
    # insert customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME
  # if not a valid input
  RE='^([01]?[0-9]|2[0-3]):[0-5][0-9]$|^(0?[0-9]|1[0-1])(:[0-5][0-9])?[aApP][mM]$'
  if [[ ! $SERVICE_TIME =~ $RE ]]
  then
  # send menu
    SERVICES_MENU "Please enter a valid time."
  else
    # get customer id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE' ")
    # if not found
    if [[ -z $CUSTOMER_ID ]]
    then
      # send menu
      SERVICES_MENU "Something was wrong. please try again."
    fi

    # inser appointment
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, 1, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
    
  fi
}

COLOR_MENU(){
  echo "color_menu"
}

PERM_MENU(){
  echo "perm_menu"
}

STYLE_MENU(){
  echo "style_menu"
}

TRIM_MENU(){
  echo "trim_menu"
}
EXIT(){
  echo -e "\nWe look forward to seeing you again."
}




SERVICES_MENU
