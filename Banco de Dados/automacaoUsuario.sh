#!/bin/bash

mysql -u root -p'SPTech#2024' -e "CREATE DATABASE protecaoSoja;"

mysql -u root -p'SPTech#2024' -e "CREATE USER 'funcionario'@'localhost' IDENTIFIED BY 'Urubu100_';"

mysql -u root -p'SPTech#2024' -e "GRANT INSERT  ON protecaoSoja.* TO 'funcionario'@'localhost'; FLUSH PRIVILEGES;" 
