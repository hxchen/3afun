---
title: "MySQL远程备份与还原"
date: 2019-01-10T14:26:58+08:00
draft: false
lastmod: 2019-01-10T14:26:58+08:00
tags: ["MySQL"]
categories: ["MySQL"]
keywords: ["MySQL"]
description: "MySQL远程备份 还原"
author: "北斗"
toc: false
autoCollapseToc: false
contentCopyright: true
reward: false
---

有时我们需要远程进行MySQL数据库的备份与还原。为此,我们可以使用`mysqldump`命令复制数据库,然后通过管道将其直接传输到远程数据中去。

将数据从A端同步到B端,`mysqldump`命令类似如下:

```bash
mysqldump -u <a_user> \
    --databases <database_name> \
    --single-transaction \
    --compress \
    --order-by-primary  \
    --host <a_host_name> \
    -p<a_password> | mysql -u <b_user> \
        --port=<port_number> \
        --host=<b_host_name> \
        -p<b_password>
```

#### 注意:
确保 -p 选项和输入的密码之间不留空格。

所用参数如下所示：

-u <`a_user`> – 用于指定用户名。在第一次使用该参数时，您指定由 --databases 参数确定的本地 MySQL 或 MariaDB 数据库中的用户账户名称。

--databases <`database_name`> – 用于指定本地 MySQL 或 MariaDB 实例上您要导入 Amazon RDS 的数据库的名称。

--single-transaction – 用于确保从本地数据库加载的所有数据都与单一时间点保持一致。如果在 mysqldump 读取数据期间有其他进程更改数据，使用该选项有助于保持数据完整性。

--compress – 用于降低网络带宽消耗，方式为将数据从本地数据库发送到 Amazon RDS 之前压缩数据。

--order-by-primary – 用于减少加载时间，方式为根据主键对每个表中的数据进行排序。
--host <`a_host_name`> - A端MySQL地址。

-p<`a_password`> – 用于指定密码。在第一次使用该参数时，您为第一个 -u 参数确定的用户账户指定密码。

-u <`b_user`> – 用于指定用户名。在第二次使用该参数时，您指定由 --host 参数确定的 Amazon RDS MySQL 或 MariaDB 数据库实例中的默认数据库的用户账户名称。

--port <`port_number`> – 用于为您的 Amazon RDS MySQL 或 MariaDB 数据库实例指定端口。默认情况下该值为 3306，除非您在创建实例时进行了更改。

--host <`b_host_name`> – B端MySQL地址。

-p<`b_password`> – 用于指定密码。在第二次使用该参数时，您为第二个 -u 参数确定的用户账户指定密码。

您必须在 B端 数据库中手动创建任何存储过程、触发器、函数或事件。如果您所复制的数据库中有上述任一对象，则在运行 mysqldump 时排除这些对象，方式是将以下参数与 mysqldump 命令一起包含：--routines=0 --triggers=0 --events=0。

