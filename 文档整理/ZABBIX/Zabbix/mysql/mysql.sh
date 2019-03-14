#!/bin/bash

#Name: mysql.sh
#From: yy <2019/01/29>
#Action: Zabbix monitoring mysql plug-in


MySQlBin=/usr/bin/mysql
MySQLAdminBin=mysqladmin
Host=localhost

if [[ $# == 1 ]];then
case $1 in
#统计有几个节点
wsrep_incoming_addresses)
result=`$MySQlBin -h$Host -e "show  global status like 'wsrep_incoming_addresses'"| grep -v Value |awk '{print $2}'|awk -F, '{print NF}'`
echo $result
;;
#缓冲池空闲列表的页面总页数（Buffer pool size -Database pages）
Free_buffers)
result=`$MySQlBin -h$Host -e 'SHOW ENGINE INNODB STATUS\G' | grep '^Free'|awk '{print $3}'`
echo $result
;;
#分配给缓冲池的页面总页数（数量*页面大小=缓冲池大小）
Buffer_pool_size)
result=`$MySQlBin -h$Host -e 'SHOW ENGINE INNODB STATUS\G' | grep '^Buffer pool size'|awk '{print $4}'`
echo $result
;;
#缓冲池LRU list的页面总页数（可以理解为已经使用的页面）
Database_pages)
result=`$MySQlBin -h$Host -e 'SHOW ENGINE INNODB STATUS\G' | grep '^Database pages'|awk '{print $3}'`
echo $result
;;
Com_begin)
result=`$MySQlBin -h$Host -e "show global status where Variable_name='$1';"| grep -v Value |awk '{print $2}'`
echo $result
;;
Bytes_received)
result=`$MySQlBin -h$Host -e "show global status where Variable_name='$1';"| grep -v Value |awk '{print $2}'`
echo $result
;;
Bytes_sent)
result=`$MySQlBin -h$Host -e "show global status where Variable_name='$1';"| grep -v Value |awk '{print $2}'`
echo $result
;;
Com_commit)
result=`$MySQlBin -h$Host -e "show global status where Variable_name='$1';"| grep -v Value |awk '{print $2}'`
echo $result
;;
Com_delete)
result=`$MySQlBin -h$Host -e "show global status where Variable_name='$1';"| grep -v Value |awk '{print $2}'`
echo $result
;;
Com_insert)
result=`$MySQlBin -h$Host -e "show global status where Variable_name='$1';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#Questions)
#result=`$MySQlBin -h$Host -e "show global status where Variable_name='$1';"| grep -v Value |awk '{print $2}'`
#echo $result
#;;
Com_rollback)
result=`$MySQlBin -h$Host -e "show global status where Variable_name='$1';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#Com_select)
#result=`$MySQlBin -h$Host -e "show global status where Variable_name='$1';"| grep -v Value |awk '{print $2}'`
#echo $result
#;;
#Com_update)
#result=`$MySQlBin -h$Host -e "show global status where Variable_name='$1';"| grep -v Value |awk '{print $2}'`
#echo $result
#;;
Uptime)
result=`$MySQlBin -h$Host -e "show global status where Variable_name='$1';"| grep -v Value |awk '{print $2}'`
echo $result
;;
Threads_created)
result=`$MySQlBin -h$Host -e "show global status where Variable_name='$1';"| grep -v Value |awk '{print $2}'`
echo $result
;;
Ping)
result=`$MySQLAdminBin -h$Host ping|grep alive|wc -l`
echo $result
;;
#Uptime：MySQL 服务运行的时间（秒）
#Threads：客户线程数量
#Opens：服务器打开过的表的数量
#Flush tables：flush-*, refresh, reload 命令执行的数量
#Open tables：服务器当前被打开的表数量
Threads)
result=`$MySQLAdminBin -h$Host status|cut -f3 -d":"|cut -f1 -d"Q"`
echo $result
;;
#Questions：MySQl 服务启动后的查询数量
Questions)
result=`$MySQLAdminBin -h$Host status|cut -f4 -d":"|cut -f1 -d"S"`
echo $result
;;
#Slow queries：慢查询数量（通过 long_query_time 设置慢查询）
Slowqueries)
result=`$MySQLAdminBin -h$Host status|cut -f5 -d":"|cut -f1 -d"O"`
echo $result
;;
Qps)
result=`$MySQLAdminBin -h$Host status|cut -f9 -d":"`
echo $result
;;
#查询主从io状态
Slave_IO_State)
result=`if [ "$($MySQlBin -h$Host -e "show slave status\G"| grep Slave_IO_Running|awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi`
echo $result
;;
#查询主从sql状态
Slave_SQL_State)
result=`if [ "$($MySQlBin -h$Host -e "show slave status\G"| grep Slave_SQL_Running|awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi`
echo $result
;;
#为了最小化磁盘的 I/O ， MyISAM 存储引擎的表使用键高速缓存来缓存索引，这个键高速缓存的大小则通过 key-buffer-size 参数来设置。如果应用系统中使用的表以 MyISAM 存储引擎为主，则应该适当增加该参数的值，以便尽可能的缓存索引，提高访问的速度。
Key_buffer_size)
result=`$MySQlBin -h$Host -e "show variables like 'key_buffer_size';"| grep -v Value |awk '{print $2/1024^2}'`
echo $result
;;
#从磁盘读取索引的请求次数。
Key_reads)
result=`$MySQlBin -h$Host -e "show status like 'key_reads';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#从缓存读取索引的请求次数。
Key_read_requests)
result=`$MySQlBin -h$Host -e "show status like 'key_read_requests';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#缓存的未命中率为
Key_cache_miss_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'key_reads';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'key_read_requests';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
echo $result
;;
#表示曾经用到的最大的blocks数 
Key_blocks_used)
result=`$MySQlBin -h$Host -e "show status like 'key_blocks_used';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#表示未使用的缓存簇(blocks)数
Key_blocks_unused)
result=`$MySQlBin -h$Host -e "show status like 'key_blocks_unused';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#曾经用到的最大的blocks数的使用率
Key_blocks_used_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'key_blocks_used';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'key_blocks_unused';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`
echo $result
;;
#可以缓存索引和行数据，值越大，IO读写就越少，如果单纯的做数据库服务，该参数可以设置到电脑物理内存的80%
Innodb_buffer_pool_size)
result=`$MySQlBin -h$Host -e "show variables like 'innodb_buffer_pool_size';"| grep -v Value |awk '{print $2/1024^2}'`
echo $result
;;
#事务日志的大小
Innodb_log_file_size)
result=`$MySQlBin -h$Host -e "show variables like 'innodb_log_file_size';"| grep -v Value |awk '{print $2/1024^2}'`
echo $result
;;
#该参数确保有足够大的日志缓冲区来保存脏数据在被写入到日志文件之前
Innodb_log_buffer_size)
result=`$MySQlBin -h$Host -e "show variables like 'innodb_log_buffer_size';"| grep -v Value |awk '{print $2/1024^2}'`
echo $result
;;
#表高速缓存的大小。每当MySQL访问一个表时，如果在表缓冲区中还有空间，该表就被打开并放入其中，这样可以更快地访问表内容
Table_open_cache)
result=`$MySQlBin -h$Host -e "show variables like 'table_open_cache';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#表示打开表的数量
Open_tables)
result=`$MySQlBin -h$Host -e "show status like 'open_tables';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#表示打开过的表数量
Opened_tables)
result=`$MySQlBin -h$Host -e "show status like 'opened_tables';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#打开表占所有打开的表的几率
Open_tables_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'open_tables';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'opened_tables';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`
echo $result
;;
#打开表的数量占缓存区的比率
Table_open_cache_used_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'open_tables';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show variables like 'table_open_cache';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`
echo $result
;;
#每建立一个连接，都需要一个线程来与之匹配，此参数用来缓存空闲的线程，以至不被销毁，如果线程缓存中有空闲线程，这时候如果建立新连接，MYSQL就会很快的响应连接请求
Thread_cache_size)
result=`$MySQlBin -h$Host -e "show variables like 'thread_cache_size';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#代表当前此时此刻线程缓存中有多少空闲线程
Threads_cached)
result=`$MySQlBin -h$Host -e "show status like 'Threads_cached';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#代表当前已建立连接的数量，因为一个连接就需要一个线程，所以也可以看成当前被使用的线程数。
Threads_connected)
result=`$MySQlBin -h$Host -e "show status like 'Threads_connected';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#代表从最近一次服务启动，已创建线程的数量
Threads_created)
result=`$MySQlBin -h$Host -e "show status like 'Threads_created';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#代表当前激活的（非睡眠状态）线程数。并不是代表正在使用的线程数，有时候连接已建立，但是连接处于sleep状态，这里相对应的线程也是sleep状态
Threads_running)
result=`$MySQlBin -h$Host -e "show status like 'Threads_running';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#Query Cache 中目前还有多少剩余的blocks。如果该值显示较大，则说明Query Cache 中的内存碎片较多了，可能需要寻找合适的机会进行整理
Qcache_free_blocks)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_free_blocks';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#Query Cache 中目前剩余的内存大小。通过这个参数我们可以较为准确的观察出当前系统中的Query Cache 内存大小是否足够，是需要增加还是过多了
Qcache_free_memory)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_free_memory';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#多少次命中。通过这个参数我们可以查看到Query Cache 的基本效果
Qcache_hits)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_hits';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#多少次未命中然后插入。通过“Qcache_hits”和“Qcache_inserts”两个参数我们就可以算出Query Cache 的命中率了
Qcache_inserts)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_inserts';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#多少条Query 因为内存不足而被清除出Query Cache。通过“Qcache_lowmem_prunes”和“Qcache_free_memory”相互结合，能够更清楚的了解到我们系统中Query Cache 的内存大小是否真的足够，是否非常频繁的出现因为内存不足而有Query 被换出
Qcache_lowmem_prunes)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_lowmem_prunes';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#因为query_cache_type 的设置或者不能被cache 的Query 的数量
Qcache_not_cached)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_not_cached';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#当前Query Cache 中cache 的Query 数量
Qcache_queries_in_cache)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_queries_in_cache';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#当前Query Cache 中的block 数量
Qcache_total_blocks)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_total_blocks';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#当前Query Cache 中剩余的block 数量占totle的rate
Qcache_fragment_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'Qcache_free_blocks';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'Qcache_total_blocks';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
echo $result
;;
#MYSQL的查询缓存用于缓存select查询结果，并在下次接收到同样的查询请求时，不再执行实际查询处理而直接返回结果，有这样的查询缓存能提高查询的速度，使查询性能得到优化，前提条件是你有大量的相同或相似的查询，而很少改变表里的数据，否则没有必要使用此功能
Qcache_used_rate)
result=`echo $($MySQlBin -h$Host -e "show variables like 'query_cache_size';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'Qcache_free_memory';"| grep -v Value |awk '{print $2}')| awk '{if($1==0)printf("%1.4f\n",0);else printf("%1.4f\n",($1-$2)/$1*100);}'`
echo $result
;;
#Query Cache 命中率
Qcache_hits_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'Qcache_hits';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'Qcache_inserts';"| grep -v Value |awk '{print $2}')| awk '{if($1==0)printf("%1.4f\n",0);else printf("%1.4f\n",($1-$2)/$1*100);}'`
echo $result
;;
#指定单个查询能够使用的缓冲区大小，缺省为1M
Query_cache_limit)
result=`$MySQlBin -h$Host -e "show variables like 'query_cache_limit';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#指定分配缓冲区空间的最小单位，缺省为4K。检查状态值 Qcache_free_blocks，如果该值非常大，则表明缓冲区中碎片很多，这就表明查询结果都比较小
Query_cache_min_res_unit)
result=`$MySQlBin -h$Host -e "show variables like 'query_cache_min_res_unit';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#查询缓存的大小
Query_cache_size)
result=`$MySQlBin -h$Host -e "show variables like 'query_cache_size';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#在Sort_merge_passes增大时说明sort排序的buffer小了，使用了硬盘缓存，如果此状态参数持续增加，就需要增加sort_buffer_size参数的大小了，记得在my.cnf中修改，此参数是session的，不能太大，如果太大，连接数又很大，会导致内存暴增
Sort_merge_passes)
result=`$MySQlBin -h$Host -e "show status like 'Sort_merge_passes';"| grep -v Value |awk '{print $2}'`
echo $result
;;

Sort_range)
result=`$MySQlBin -h$Host -e "show status like 'Sort_range';"| grep -v Value |awk '{print $2}'`
echo $result
;;

Sort_rows)
result=`$MySQlBin -h$Host -e "show status like 'Sort_rows';"| grep -v Value |awk '{print $2}'`
echo $result
;;
Sort_scan)
result=`$MySQlBin -h$Host -e "show status like 'Sort_scan';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#请求读入表中第一行的次数
Handler_read_first)
result=`$MySQlBin -h$Host -e "show status like 'Handler_read_first';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#请求数字基于键读行
Handler_read_key)
result=`$MySQlBin -h$Host -e "show status like 'Handler_read_key';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#请求读入基于一个键的一行的次数
Handler_read_next)
result=`$MySQlBin -h$Host -e "show status like 'Handler_read_next';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#通过索引读取上一条数据的次数
Handler_read_prev)
result=`$MySQlBin -h$Host -e "show status like 'Handler_read_prev';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#请求读入基于一个固定位置的一行的次数
Handler_read_rnd)
result=`$MySQlBin -h$Host -e "show status like 'Handler_read_rnd';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#从数据节点读取读取下一条数据的次数
Handler_read_rnd_next)
result=`$MySQlBin -h$Host -e "show status like 'Handler_read_rnd_next';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#变量记录的是无缓存的查询次数+错误查询+权限检查查询
Com_select)
result=`$MySQlBin -h$Host -e "show status like 'com_select';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#用来监控数据库实例的插入语句的次数
Com_insert)
result=`$MySQlBin -h$Host -e "show status like 'com_insert';"| grep -v Value |awk '{print $2}'`
echo $result
;;

Com_insert_select)
result=`$MySQlBin -h$Host -e "show status like 'com_insert_select';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#更新语句执行次数
Com_update)
result=`$MySQlBin -h$Host -e "show status like 'com_update';"| grep -v Value |awk '{print $2}'`
echo $result
;;
Com_replace)
result=`$MySQlBin -h$Host -e "show status like 'com_replace';"| grep -v Value |awk '{print $2}'`
echo $result
;;
Com_replace_select)
result=`$MySQlBin -h$Host -e "show status like 'com_replace_select';"| grep -v Value |awk '{print $2}'`
echo $result
;;
Table_scan_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'Handler_read_rnd_next';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'com_select';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
echo $result
;;
#文件打开数
Open_files)
result=`$MySQlBin -h$Host -e "show status like 'open_files';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#文件打开数极限
Open_files_limit)
result=`$MySQlBin -h$Host -e "show variables like 'open_files_limit';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#文件打开数占比
Open_files_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'open_files';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show variables like 'open_files_limit';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
echo $result
;;
#磁盘上创建临时表空间
Created_tmp_disk_tables)
result=`$MySQlBin -h$Host -e "show status like 'created_tmp_disk_tables';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#创建的临时表空空间
Created_tmp_tables)
result=`$MySQlBin -h$Host -e "show status like 'created_tmp_tables';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#创建的磁盘表空间占临时表空间的百分比
Created_tmp_disk_tables_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'created_tmp_disk_tables';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'created_tmp_tables';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
echo $result
;;
#最大连接（用户）数
Max_connections)
result=`$MySQlBin -h$Host -e "show variables like 'max_connections';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#从这次mysql服务启动到现在，同一时刻并行连接数的最大值。它不是指当前的连接情况，而是一个比较值
Max_used_connections)
result=`$MySQlBin -h$Host -e "show status like 'Max_used_connections';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#有多少线程在运行
Processlist)
result=`$MySQlBin -h$Host -e "show processlist" | grep -v "Id" | wc -l`
echo $result
;;
#最高情况下连接数占比
Max_connections_used_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'Max_used_connections';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show variables like 'max_connections';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
echo $result
;;
#当前打开的连接的数量
Connection_occupancy_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'Threads_connected';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show variables like 'max_connections';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%5.4f\n",$1/$2*100);}'`
echo $result
;;
#表示马上获的锁的查询数目；如果是myisam引擎表 table_lock_wait 值比较大，那说明性能有问题，并发高，存储引擎最好改为innodb引擎，在innodb引擎下，table_lock_wait值几乎没用。table_lock_wait 不同于innodb_lock_wait.
Table_locks_immediate)
result=`$MySQlBin -h$Host -e "show status like 'Table_locks_immediate';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#表示不能马上获得锁的数据
Table_locks_waited)
result=`$MySQlBin -h$Host -e "show status like 'table_locks_waited';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#引擎选择；Table_locks_waited表示需要等待的表锁数，如果Table_locks_immediate / Table_locks_waited > 5000，最好采用InnoDB引擎
Engine_select)
result=`echo $($MySQlBin -h$Host -e "show status like 'Table_locks_immediate';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'table_locks_waited';"| grep -v Value | awk '{print $2}') | awk '{if($2==0)printf("%1.4f\n",0);else printf("%5.4f\n",$1/$2*100);}'`
echo $result
;;
*)
echo -e "\033[33mUsage: ./getmysqlinfo {Ping|Threads|Questions|Slowqueries|Qps|Slave_IO_State|Slave_SQL_State|Key_buffer_size|Key_reads|Key_read_requests|Key_cache_miss_rate|Key_blocks_used|Key_blocks_unused|Key_blocks_used_rate|Innodb_buffer_pool_size|Innodb_log_file_size|Innodb_log_buffer_size|Table_open_cache|Open_tables|Opened_tables|Open_tables_rate|Table_open_cache_used_rate|Thread_cache_size|Threads_cached|Threads_connected|Threads_created|Threads_running|Qcache_free_blocks|Qcache_free_memory|Qcache_hits|Qcache_inserts|Qcache_lowmem_prunes|Qcache_not_cached|Qcache_queries_in_cache|Qcache_total_blocks|Qcache_fragment_rate|Qcache_used_rate|Qcache_hits_rate|Query_cache_limit|Query_cache_min_res_unit|Query_cache_size|Sort_merge_passes|Sort_range|Sort_rows|Sort_scan|Handler_read_first|Handler_read_key|Handler_read_next|Handler_read_prev|Handler_read_rnd|Handler_read_rnd_next|Com_select|Com_insert|Com_insert_select|Com_update|Com_replace|Com_replace_select|Table_scan_rate|Open_files|Open_files_limit|Open_files_rate|Created_tmp_disk_tables|Created_tmp_tables|Created_tmp_disk_tables_rate|Max_connections|Max_used_connections|Processlist|Max_connections_used_rate|Table_locks_immediate|Table_locks_waited|Engine_select|Connection_occupancy_rate} \033[0m"

;;
esac
fi