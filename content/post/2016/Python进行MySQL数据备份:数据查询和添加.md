---
title: "Python进行MySQL数据备份:数据查询和添加"
date: 2016-01-06T18:20:00+08:00
draft: false
tags: ["Python","MySQL"]
categories: ["Python","MySQL"]
author: "北斗"
---

运行前，需要安装MySQLdb模块！！！

sudo yum install MySQL-python



```
#!/usr/bin/python
# -*- coding: UTF-8 -*-
import MySQLdb
import datetime



def backYestoday():
    today = datetime.date.today()
    yesterday = today - datetime.timedelta(days=1)

    # 打开数据库连接

    db_mat = MySQLdb.connect("hostname", "root", "password", "db", charset='utf8')

    # 使用cursor()方法获取操作游标
    cursor = db_mat.cursor()

    # 使用execute方法执行SQL语句
    sql_select = "select id, created, agency_name, app_name, match_type, campaign_id, campaign_name, country_name, currency_code, is_view_through, site_name, site_id, publisher_name, publisher_id, existing_user, region_name, session_datetime, session_ip, impression_created, stat_click_id, stat_impression_id, payout, referral_source, referral_url, ip, revenue, revenue_usd, status, status_code, tracking_id, os_id, wurfl_brand_name, debug_mode, device_brand, device_carrier, device_id, device_ip, device_model, device_type, os_version, google_aid, ios_ifa, ios_ifv, language, mac_address, odin, sdk, sdk_version, test_profile, unid, user_agent, windows_aid, publisher_sub_ad_name, publisher_sub_adgroup_name, publisher_sub_campaign_name, publisher_sub_campaign_id, publisher_sub_campaign_ref, publisher_sub_keyword_name, publisher_sub_placement_name, publisher_sub_placement_id, publisher_sub_publisher_id, publisher_sub_publisher_name, publisher_sub_site_name, publisher_ref_id, publisher_sub1, advertiser_ref_id, advertiser_sub_ad_name, advertiser_sub_adgroup_name, advertiser_sub_adgroup_id, advertiser_sub_ad_id, advertiser_sub_campaign_name, advertiser_sub_campaign_id, advertiser_sub_campaign_ref, advertiser_sub_keyword_name, advertiser_sub_publisher_name, advertiser_sub_publisher_id, advertiser_sub_placement_name, advertiser_sub_placement_id, advertiser_sub_site_name, user_id, currency_rate, ip_from, ip_to, os_jailbroke FROM install where created >= '"+str(yesterday)+" 00:00:00' and created <='"+str(yesterday)+" 23:59:59'"
    cursor.execute(sql_select)
    result = cursor.fetchall()
    db_mat.close()

    # 插入数据
    db_advertisement = MySQLdb.connect("127.0.0.1", "root", "password", "db",charset='utf8')

    # 使用cursor()方法获取操作游标
    cursor = db_advertisement.cursor()

    # SQL 插入语句
    sql_insert = "insert into install(id, created, agency_name, app_name, match_type, campaign_id, campaign_name, country_name, currency_code, is_view_through, site_name, site_id, publisher_name, publisher_id, existing_user, region_name, session_datetime, session_ip, impression_created, stat_click_id, stat_impression_id, payout, referral_source, referral_url, ip, revenue, revenue_usd, status, status_code, tracking_id, os_id, wurfl_brand_name, debug_mode, device_brand, device_carrier, device_id, device_ip, device_model, device_type, os_version, google_aid, ios_ifa, ios_ifv, language, mac_address, odin, sdk, sdk_version, test_profile, unid, user_agent, windows_aid, publisher_sub_ad_name, publisher_sub_adgroup_name, publisher_sub_campaign_name, publisher_sub_campaign_id, publisher_sub_campaign_ref, publisher_sub_keyword_name, publisher_sub_placement_name, publisher_sub_placement_id, publisher_sub_publisher_id, publisher_sub_publisher_name, publisher_sub_site_name, publisher_ref_id, publisher_sub1, advertiser_ref_id, advertiser_sub_ad_name, advertiser_sub_adgroup_name, advertiser_sub_adgroup_id, advertiser_sub_ad_id, advertiser_sub_campaign_name, advertiser_sub_campaign_id, advertiser_sub_campaign_ref, advertiser_sub_keyword_name, advertiser_sub_publisher_name, advertiser_sub_publisher_id, advertiser_sub_placement_name, advertiser_sub_placement_id, advertiser_sub_site_name, user_id, currency_rate, ip_from, ip_to, os_jailbroke) values(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
    try:
        # 执行sql语句
        cursor.executemany(sql_insert, result)
        # 提交到数据库执行
        db_advertisement.commit()
    except:
        db_advertisement.rollback()

    # 关闭数据库连接
    db_advertisement.close()

backYestoday()
```