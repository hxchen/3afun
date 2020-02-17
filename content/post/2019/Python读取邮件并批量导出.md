---
title: "Python读取邮件并批量导出"
date: 2019-12-04T19:22:53+08:00
draft: false
lastmod: 2019-12-04T19:22:53+08:00
tags: ["Python"]
categories: ["Python"]
keywords: ["Python","邮件"]
description: "Python 导出 邮件"
author: "北斗"
---
利用Python对邮件进行备份导出到txt文本文件：
```Python
from email.parser import Parser
from email.header import decode_header
from email.utils import parseaddr
import poplib

# 输入邮件地址, 口令和POP3服务器地址:
email = 'email@domain.com'
password = 'password'
pop3_server = 'pop.domain.com'


def decode_str(s):
    value, charset = decode_header(s)[0]
    if charset:
        value = value.decode(charset)
    return value


def guess_charset(msg):
    charset = msg.get_charset()
    if charset is None:
        content_type = msg.get('Content-Type', '').lower()
        pos = content_type.find('charset=')
        if pos >= 0:
            charset = content_type[pos + 8:].strip()
    return charset


def print_info(msg, id):
    mail_content = "--------------"+str(id)+"--------------\n"
    for header in ['From', 'To', 'Subject']:
        value = msg.get(header, '')
        if value:
            if header=='Subject':
                value = decode_str(value)
            else:
                hdr, addr = parseaddr(value)
                name = decode_str(hdr)
                value = u'%s <%s>' % (name, addr)
        print('%s: %s\n' % (header, value))
        mail_content += '%s: %s\n' % (header, value)
    # 循环信件中的每一个mime的数据块
    for part in msg.walk():
        # 这里要判断是否是multipart，是的话，里面的数据是一个message 列表
        if not part.is_multipart():
            content_type = part.get_content_type()
            if content_type == 'text/plain' or content_type == 'multipart/alternative' or content_type == 'multipart/mixed':
                content = part.get_payload(decode=True)
                charset = guess_charset(part)
                if charset:
                    content = content.decode(charset)
                print('Text: %s\n' % content)
                mail_content += 'Text: %s\n' % content
            else:
                print('Attachment: %s\n' % content_type)
                mail_content += 'Attachment: %s\n' % content_type
    return mail_content


def write2txt(msg):
    f = open('mail_list.txt', 'a')
    f.write(msg)
    f.close


def read_email():
    # 连接到POP3服务器:
    server = poplib.POP3(pop3_server)
    # 可以打开或关闭调试信息:
    server.set_debuglevel(0)
    # 可选:打印POP3服务器的欢迎文字:
    print(server.getwelcome().decode('utf-8'))

    # 身份认证:
    server.user(email)
    server.pass_(password)

    # stat()返回邮件数量和占用空间:
    print('Messages: %s. Size: %s' % server.stat())

    # list()返回所有邮件的编号:
    resp, mails, octets = server.list()
    # 可以查看返回的列表类似[b'1 82923', b'2 2184', ...]
    # print(mails)

    # 获取最新一封邮件, 注意索引号从1开始:
    index = len(mails)
    print("index = " + str(index))
    # 获取第[6626,6629)封邮件
    for index in range(6626,6630):
        resp, lines, octets = server.retr(index)
        # lines存储了邮件的原始文本的每一行,
        # 可以获得整个邮件的原始文本:
        msg_content = b'\r\n'.join(lines).decode('utf-8')
        # 稍后解析出邮件:
        msg = Parser().parsestr(msg_content)
        mail_list = print_info(msg, index)
        write2txt(mail_list)

    # 关闭连接:
    server.quit()


if __name__== "__main__":
    read_email()

```
导出格式：
```text
--------------6626--------------
From: name <abc@gmail.com>
To:  <email@domain.com>
Subject: 主题
Text: 这里是测试邮件
```
