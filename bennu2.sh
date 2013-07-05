#!/bin/bash

echo "This script will install all necessary modules to install bennu2."
echo "IT WILL WIPE groupIds pt and dml of YOUR .M2 REPOSITORY ..."

read -p "Continue? [y/n] " -n 1 -r
if [[ $REPLY =~ ^[Nn]$ ]]
then
	echo "Aborting ..."
	exit;
fi


echo -e "\n\n\nClean maven repository ..."
rm -rf ~/.m2/repository/pt/*
rm -rf ~/.m2/repository/dml/*

echo "Cloning right bennu from GitHub ..."

git clone https://github.com/ist-dsi/bennu.git
git clone https://github.com/ist-dsi/dsi-commons.git
git clone https://github.com/ist-dsi/ist-dsi-maven
git clone https://github.com/sergiofbsilva/bennu-webapp.git
git clone https://github.com/sergiofbsilva/bennu-themes.git


echo "Install modules by the right order ..."

cd ist-dsi-maven/
mvn clean install
cd ..

cd dsi-commons/
mvn clean install
cd ..

cd bennu/
git checkout develop-2.0
git submodule init
git submodule update
mvn clean install
cd ..

cd bennu-themes/bootstrap-theme
mvn clean install
cd ..

cd dot-theme/
mvn clean install
cd ../../

cd bennu-webapp/
git checkout feature/bennu2
cp src/main/resources/configuration.properties.sample src/main/resources/configuration.properties
mvn clean package
cd ..

echo "At this point all modules are compiled. "
echo "To run app just 'cd bennu-webapp/' and 'run mvn jetty:start.'"
echo "After running your app will be available at http://localhost:8080/bennu2/"
echo "The default configuration will need a database with the name 'bennu2' and user root with password empty"
echo "If you want to change these settings edit file bennu-webapp/src/main/resources/fenix-framework.properties"
