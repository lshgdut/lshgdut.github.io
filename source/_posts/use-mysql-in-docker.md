title: 在docker中使用mysql
date: 2017-12-19 23:22:01
tags:
	- mysql
	- docker
---



### 安装 mysql 的 docker 镜像

```
docker pull mysql
```

### 查看 mysql 镜像是否下载成功

```
➜  blog git:(source) ✗ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mysql               latest              dd0afb9bc4a9        12 days ago         408 MB
```

### 启动 mysql

同时起个名称，也叫`mysql`

```
➜  blog git:(source) ✗ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql
df2c529035d5fd6dee2f49a9e2c7475a2c918703b74d4574ad9bc8e84fa7c449
```

### 查看 mysql 是否启动成功

```
➜  blog git:(source) ✗ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                     PORTS               NAMES
df2c529035d5        mysql               "docker-entrypoint..."   8 days ago          Up 3 seconds               3306/tcp            some-mysql
```

### 连到 mysql

```
➜  blog git:(source) ✗ docker run -it --link some-mysql:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.7.20 MySQL Community Server (GPL)

Copyright (c) 2000, 2017, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

### 查看日志

查看日志有两种方式

1. 通过 docker logs 的方式直接输出

```
➜  blog git:(source) ✗ docker logs some-mysql
Initializing database
Database initialized
Initializing certificates
Generating a 2048 bit RSA private key
.....................+++
.............................................................................................................................................................+++
unable to write 'random state'
writing new private key to 'ca-key.pem'
```

2. 进入 docker 后台查看

```
docker exec -it some-mysql bash
```


### 使用自定义的配置文件 

mysql的启动配置在 `/etc/mysql/my.cnf`， 在这个文件中会加载 `/etc/mysql/conf.d` 目录中以 `.conf` 为后缀名的文件。
因此，可以在宿主机上定义配置文件，然后挂载到mysql容器中去

```
docker run --name some-mysql -v /my/custom:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql
```

### 常用的环境变量

#### MYSQL_ROOT_PASSWORD

这个变量为强制配置，用于指定`root`用户的密码

#### MYSQL_DATABASE

可选变量，用于指定在镜像启动时创建的数据库名称

#### MYSQL_USER, MYSQL_PASSWORD

这两变量也是可选，用于创建额外的用户和密码。如果有使用 `MYSQL_DATABASE` 创建了数据库，该用户会被赋予该数据库的管理员权限

需要注意的是，不需要使用该选项创建root用户，root用户默认就会被创建

#### MYSQL_ALLOW_EMPTY_PASSWORD

可选变量，用于设置root用户为空密码

#### MYSQL_RANDOM_ROOT_PASSWORD

可选变量，用于设置随机的root用户密码（使用pwgen)，生成的密码会被打印在标准输出上。比如：

```
GENERATED ROOT PASSWORD: .....
```


### 数据文件的存储

### 创建数据库dumps文件