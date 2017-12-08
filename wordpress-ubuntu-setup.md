## References
 [WordPress Install Document](https://codex.wordpress.org/Installing_WordPress#Using_the_MySQL_Client)
 [Install Wordpress on Ubuntu Server](https://peteris.rocks/blog/unattended-installation-of-wordpress-on-ubuntu-server/)

# MySQL Setup for Wordpress

## Install MySQL:
`sudo apt-get install mysql-server`
- Set `root` password when prompted 

## Initialize MySQL:
Login as root:
```mysql -u root -p```
Create `wordpress` database:
```
CREATE DATABASE wordpress;
```
Create a non-root DB user and grant user privileges:
```
CREATE USER 'non-root-user'@'localhost' IDENTIFIED BY 'complex-password';
GRANT ALL PRIVILEGES ON * . * TO 'non-root-user'@'localhost';
```
## Exit mysql shell and sign in as new user
```exit```

## Follow instructions from [WordPress Install Document](https://codex.wordpress.org/Installing_WordPress#Using_the_MySQL_Client):
```
$ mysql -u adminusername -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 5340 to server version: 3.23.54
 
Type 'help;' or '\h' for help. Type '\c' to clear the buffer.
 
mysql> CREATE DATABASE databasename;
Query OK, 1 row affected (0.00 sec)
 
mysql> GRANT ALL PRIVILEGES ON databasename.* TO "wordpressusername"@"localhost"
    -> IDENTIFIED BY "complex-password";
Query OK, 0 rows affected (0.00 sec)
  
mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.01 sec)

mysql> EXIT
Bye
$ 
```

Follow instructions here for installing  [Wordpress on Ubuntu Server](https://peteris.rocks/blog/unattended-installation-of-wordpress-on-ubuntu-server/)
