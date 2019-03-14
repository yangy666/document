#!/bin/bash

#Name: mysql.sh
#From: yy <2019/01/29>
#Action: Zabbix monitoring mysql plug-in


MySQlBin=/usr/bin/mysql
MySQLAdminBin=mysqladmin
Host=localhost

if [[ $# == 1 ]];then
case $1 in
#ͳ���м����ڵ�
wsrep_incoming_addresses)
result=`$MySQlBin -h$Host -e "show  global status like 'wsrep_incoming_addresses'"| grep -v Value |awk '{print $2}'|awk -F, '{print NF}'`
echo $result
;;
#����ؿ����б��ҳ����ҳ����Buffer pool size -Database pages��
Free_buffers)
result=`$MySQlBin -h$Host -e 'SHOW ENGINE INNODB STATUS\G' | grep '^Free'|awk '{print $3}'`
echo $result
;;
#���������ص�ҳ����ҳ��������*ҳ���С=����ش�С��
Buffer_pool_size)
result=`$MySQlBin -h$Host -e 'SHOW ENGINE INNODB STATUS\G' | grep '^Buffer pool size'|awk '{print $4}'`
echo $result
;;
#�����LRU list��ҳ����ҳ�����������Ϊ�Ѿ�ʹ�õ�ҳ�棩
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
#Uptime��MySQL �������е�ʱ�䣨�룩
#Threads���ͻ��߳�����
#Opens���������򿪹��ı������
#Flush tables��flush-*, refresh, reload ����ִ�е�����
#Open tables����������ǰ���򿪵ı�����
Threads)
result=`$MySQLAdminBin -h$Host status|cut -f3 -d":"|cut -f1 -d"Q"`
echo $result
;;
#Questions��MySQl ����������Ĳ�ѯ����
Questions)
result=`$MySQLAdminBin -h$Host status|cut -f4 -d":"|cut -f1 -d"S"`
echo $result
;;
#Slow queries������ѯ������ͨ�� long_query_time ��������ѯ��
Slowqueries)
result=`$MySQLAdminBin -h$Host status|cut -f5 -d":"|cut -f1 -d"O"`
echo $result
;;
Qps)
result=`$MySQLAdminBin -h$Host status|cut -f9 -d":"`
echo $result
;;
#��ѯ����io״̬
Slave_IO_State)
result=`if [ "$($MySQlBin -h$Host -e "show slave status\G"| grep Slave_IO_Running|awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi`
echo $result
;;
#��ѯ����sql״̬
Slave_SQL_State)
result=`if [ "$($MySQlBin -h$Host -e "show slave status\G"| grep Slave_SQL_Running|awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi`
echo $result
;;
#Ϊ����С�����̵� I/O �� MyISAM �洢����ı�ʹ�ü����ٻ�����������������������ٻ���Ĵ�С��ͨ�� key-buffer-size ���������á����Ӧ��ϵͳ��ʹ�õı��� MyISAM �洢����Ϊ������Ӧ���ʵ����Ӹò�����ֵ���Ա㾡���ܵĻ�����������߷��ʵ��ٶȡ�
Key_buffer_size)
result=`$MySQlBin -h$Host -e "show variables like 'key_buffer_size';"| grep -v Value |awk '{print $2/1024^2}'`
echo $result
;;
#�Ӵ��̶�ȡ���������������
Key_reads)
result=`$MySQlBin -h$Host -e "show status like 'key_reads';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#�ӻ����ȡ���������������
Key_read_requests)
result=`$MySQlBin -h$Host -e "show status like 'key_read_requests';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#�����δ������Ϊ
Key_cache_miss_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'key_reads';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'key_read_requests';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
echo $result
;;
#��ʾ�����õ�������blocks�� 
Key_blocks_used)
result=`$MySQlBin -h$Host -e "show status like 'key_blocks_used';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#��ʾδʹ�õĻ����(blocks)��
Key_blocks_unused)
result=`$MySQlBin -h$Host -e "show status like 'key_blocks_unused';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#�����õ�������blocks����ʹ����
Key_blocks_used_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'key_blocks_used';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'key_blocks_unused';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`
echo $result
;;
#���Ի��������������ݣ�ֵԽ��IO��д��Խ�٣���������������ݿ���񣬸ò����������õ����������ڴ��80%
Innodb_buffer_pool_size)
result=`$MySQlBin -h$Host -e "show variables like 'innodb_buffer_pool_size';"| grep -v Value |awk '{print $2/1024^2}'`
echo $result
;;
#������־�Ĵ�С
Innodb_log_file_size)
result=`$MySQlBin -h$Host -e "show variables like 'innodb_log_file_size';"| grep -v Value |awk '{print $2/1024^2}'`
echo $result
;;
#�ò���ȷ�����㹻�����־�������������������ڱ�д�뵽��־�ļ�֮ǰ
Innodb_log_buffer_size)
result=`$MySQlBin -h$Host -e "show variables like 'innodb_log_buffer_size';"| grep -v Value |awk '{print $2/1024^2}'`
echo $result
;;
#����ٻ���Ĵ�С��ÿ��MySQL����һ����ʱ������ڱ������л��пռ䣬�ñ�ͱ��򿪲��������У��������Ը���ط��ʱ�����
Table_open_cache)
result=`$MySQlBin -h$Host -e "show variables like 'table_open_cache';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#��ʾ�򿪱������
Open_tables)
result=`$MySQlBin -h$Host -e "show status like 'open_tables';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#��ʾ�򿪹��ı�����
Opened_tables)
result=`$MySQlBin -h$Host -e "show status like 'opened_tables';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#�򿪱�ռ���д򿪵ı�ļ���
Open_tables_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'open_tables';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'opened_tables';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`
echo $result
;;
#�򿪱������ռ�������ı���
Table_open_cache_used_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'open_tables';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show variables like 'table_open_cache';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`
echo $result
;;
#ÿ����һ�����ӣ�����Ҫһ���߳�����֮ƥ�䣬�˲�������������е��̣߳������������٣�����̻߳������п����̣߳���ʱ��������������ӣ�MYSQL�ͻ�ܿ����Ӧ��������
Thread_cache_size)
result=`$MySQlBin -h$Host -e "show variables like 'thread_cache_size';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#����ǰ��ʱ�˿��̻߳������ж��ٿ����߳�
Threads_cached)
result=`$MySQlBin -h$Host -e "show status like 'Threads_cached';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#����ǰ�ѽ������ӵ���������Ϊһ�����Ӿ���Ҫһ���̣߳�����Ҳ���Կ��ɵ�ǰ��ʹ�õ��߳�����
Threads_connected)
result=`$MySQlBin -h$Host -e "show status like 'Threads_connected';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#��������һ�η����������Ѵ����̵߳�����
Threads_created)
result=`$MySQlBin -h$Host -e "show status like 'Threads_created';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#����ǰ����ģ���˯��״̬���߳����������Ǵ�������ʹ�õ��߳�������ʱ�������ѽ������������Ӵ���sleep״̬���������Ӧ���߳�Ҳ��sleep״̬
Threads_running)
result=`$MySQlBin -h$Host -e "show status like 'Threads_running';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#Query Cache ��Ŀǰ���ж���ʣ���blocks�������ֵ��ʾ�ϴ���˵��Query Cache �е��ڴ���Ƭ�϶��ˣ�������ҪѰ�Һ��ʵĻ����������
Qcache_free_blocks)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_free_blocks';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#Query Cache ��Ŀǰʣ����ڴ��С��ͨ������������ǿ��Խ�Ϊ׼ȷ�Ĺ۲����ǰϵͳ�е�Query Cache �ڴ��С�Ƿ��㹻������Ҫ���ӻ��ǹ�����
Qcache_free_memory)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_free_memory';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#���ٴ����С�ͨ������������ǿ��Բ鿴��Query Cache �Ļ���Ч��
Qcache_hits)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_hits';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#���ٴ�δ����Ȼ����롣ͨ����Qcache_hits���͡�Qcache_inserts�������������ǾͿ������Query Cache ����������
Qcache_inserts)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_inserts';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#������Query ��Ϊ�ڴ治����������Query Cache��ͨ����Qcache_lowmem_prunes���͡�Qcache_free_memory���໥��ϣ��ܹ���������˽⵽����ϵͳ��Query Cache ���ڴ��С�Ƿ�����㹻���Ƿ�ǳ�Ƶ���ĳ�����Ϊ�ڴ治�����Query ������
Qcache_lowmem_prunes)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_lowmem_prunes';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#��Ϊquery_cache_type �����û��߲��ܱ�cache ��Query ������
Qcache_not_cached)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_not_cached';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#��ǰQuery Cache ��cache ��Query ����
Qcache_queries_in_cache)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_queries_in_cache';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#��ǰQuery Cache �е�block ����
Qcache_total_blocks)
result=`$MySQlBin -h$Host -e "show status like 'Qcache_total_blocks';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#��ǰQuery Cache ��ʣ���block ����ռtotle��rate
Qcache_fragment_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'Qcache_free_blocks';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'Qcache_total_blocks';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
echo $result
;;
#MYSQL�Ĳ�ѯ�������ڻ���select��ѯ����������´ν��յ�ͬ���Ĳ�ѯ����ʱ������ִ��ʵ�ʲ�ѯ�����ֱ�ӷ��ؽ�����������Ĳ�ѯ��������߲�ѯ���ٶȣ�ʹ��ѯ���ܵõ��Ż���ǰ�����������д�������ͬ�����ƵĲ�ѯ�������ٸı��������ݣ�����û�б�Ҫʹ�ô˹���
Qcache_used_rate)
result=`echo $($MySQlBin -h$Host -e "show variables like 'query_cache_size';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'Qcache_free_memory';"| grep -v Value |awk '{print $2}')| awk '{if($1==0)printf("%1.4f\n",0);else printf("%1.4f\n",($1-$2)/$1*100);}'`
echo $result
;;
#Query Cache ������
Qcache_hits_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'Qcache_hits';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'Qcache_inserts';"| grep -v Value |awk '{print $2}')| awk '{if($1==0)printf("%1.4f\n",0);else printf("%1.4f\n",($1-$2)/$1*100);}'`
echo $result
;;
#ָ��������ѯ�ܹ�ʹ�õĻ�������С��ȱʡΪ1M
Query_cache_limit)
result=`$MySQlBin -h$Host -e "show variables like 'query_cache_limit';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#ָ�����仺�����ռ����С��λ��ȱʡΪ4K�����״ֵ̬ Qcache_free_blocks�������ֵ�ǳ������������������Ƭ�ܶ࣬��ͱ�����ѯ������Ƚ�С
Query_cache_min_res_unit)
result=`$MySQlBin -h$Host -e "show variables like 'query_cache_min_res_unit';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#��ѯ����Ĵ�С
Query_cache_size)
result=`$MySQlBin -h$Host -e "show variables like 'query_cache_size';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#��Sort_merge_passes����ʱ˵��sort�����bufferС�ˣ�ʹ����Ӳ�̻��棬�����״̬�����������ӣ�����Ҫ����sort_buffer_size�����Ĵ�С�ˣ��ǵ���my.cnf���޸ģ��˲�����session�ģ�����̫�����̫���������ֺܴ󣬻ᵼ���ڴ汩��
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
#���������е�һ�еĴ���
Handler_read_first)
result=`$MySQlBin -h$Host -e "show status like 'Handler_read_first';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#�������ֻ��ڼ�����
Handler_read_key)
result=`$MySQlBin -h$Host -e "show status like 'Handler_read_key';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#����������һ������һ�еĴ���
Handler_read_next)
result=`$MySQlBin -h$Host -e "show status like 'Handler_read_next';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#ͨ��������ȡ��һ�����ݵĴ���
Handler_read_prev)
result=`$MySQlBin -h$Host -e "show status like 'Handler_read_prev';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#����������һ���̶�λ�õ�һ�еĴ���
Handler_read_rnd)
result=`$MySQlBin -h$Host -e "show status like 'Handler_read_rnd';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#�����ݽڵ��ȡ��ȡ��һ�����ݵĴ���
Handler_read_rnd_next)
result=`$MySQlBin -h$Host -e "show status like 'Handler_read_rnd_next';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#������¼�����޻���Ĳ�ѯ����+�����ѯ+Ȩ�޼���ѯ
Com_select)
result=`$MySQlBin -h$Host -e "show status like 'com_select';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#����������ݿ�ʵ���Ĳ������Ĵ���
Com_insert)
result=`$MySQlBin -h$Host -e "show status like 'com_insert';"| grep -v Value |awk '{print $2}'`
echo $result
;;

Com_insert_select)
result=`$MySQlBin -h$Host -e "show status like 'com_insert_select';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#�������ִ�д���
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
#�ļ�����
Open_files)
result=`$MySQlBin -h$Host -e "show status like 'open_files';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#�ļ���������
Open_files_limit)
result=`$MySQlBin -h$Host -e "show variables like 'open_files_limit';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#�ļ�����ռ��
Open_files_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'open_files';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show variables like 'open_files_limit';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
echo $result
;;
#�����ϴ�����ʱ��ռ�
Created_tmp_disk_tables)
result=`$MySQlBin -h$Host -e "show status like 'created_tmp_disk_tables';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#��������ʱ��տռ�
Created_tmp_tables)
result=`$MySQlBin -h$Host -e "show status like 'created_tmp_tables';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#�����Ĵ��̱�ռ�ռ��ʱ��ռ�İٷֱ�
Created_tmp_disk_tables_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'created_tmp_disk_tables';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'created_tmp_tables';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
echo $result
;;
#������ӣ��û�����
Max_connections)
result=`$MySQlBin -h$Host -e "show variables like 'max_connections';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#�����mysql�������������ڣ�ͬһʱ�̲��������������ֵ��������ָ��ǰ���������������һ���Ƚ�ֵ
Max_used_connections)
result=`$MySQlBin -h$Host -e "show status like 'Max_used_connections';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#�ж����߳�������
Processlist)
result=`$MySQlBin -h$Host -e "show processlist" | grep -v "Id" | wc -l`
echo $result
;;
#��������������ռ��
Max_connections_used_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'Max_used_connections';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show variables like 'max_connections';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
echo $result
;;
#��ǰ�򿪵����ӵ�����
Connection_occupancy_rate)
result=`echo $($MySQlBin -h$Host -e "show status like 'Threads_connected';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show variables like 'max_connections';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%5.4f\n",$1/$2*100);}'`
echo $result
;;
#��ʾ���ϻ�����Ĳ�ѯ��Ŀ�������myisam����� table_lock_wait ֵ�Ƚϴ���˵�����������⣬�����ߣ��洢������ø�Ϊinnodb���棬��innodb�����£�table_lock_waitֵ����û�á�table_lock_wait ��ͬ��innodb_lock_wait.
Table_locks_immediate)
result=`$MySQlBin -h$Host -e "show status like 'Table_locks_immediate';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#��ʾ�������ϻ����������
Table_locks_waited)
result=`$MySQlBin -h$Host -e "show status like 'table_locks_waited';"| grep -v Value |awk '{print $2}'`
echo $result
;;
#����ѡ��Table_locks_waited��ʾ��Ҫ�ȴ��ı����������Table_locks_immediate / Table_locks_waited > 5000����ò���InnoDB����
Engine_select)
result=`echo $($MySQlBin -h$Host -e "show status like 'Table_locks_immediate';"| grep -v Value |awk '{print $2}') $($MySQlBin -h$Host -e "show status like 'table_locks_waited';"| grep -v Value | awk '{print $2}') | awk '{if($2==0)printf("%1.4f\n",0);else printf("%5.4f\n",$1/$2*100);}'`
echo $result
;;
*)
echo -e "\033[33mUsage: ./getmysqlinfo {Ping|Threads|Questions|Slowqueries|Qps|Slave_IO_State|Slave_SQL_State|Key_buffer_size|Key_reads|Key_read_requests|Key_cache_miss_rate|Key_blocks_used|Key_blocks_unused|Key_blocks_used_rate|Innodb_buffer_pool_size|Innodb_log_file_size|Innodb_log_buffer_size|Table_open_cache|Open_tables|Opened_tables|Open_tables_rate|Table_open_cache_used_rate|Thread_cache_size|Threads_cached|Threads_connected|Threads_created|Threads_running|Qcache_free_blocks|Qcache_free_memory|Qcache_hits|Qcache_inserts|Qcache_lowmem_prunes|Qcache_not_cached|Qcache_queries_in_cache|Qcache_total_blocks|Qcache_fragment_rate|Qcache_used_rate|Qcache_hits_rate|Query_cache_limit|Query_cache_min_res_unit|Query_cache_size|Sort_merge_passes|Sort_range|Sort_rows|Sort_scan|Handler_read_first|Handler_read_key|Handler_read_next|Handler_read_prev|Handler_read_rnd|Handler_read_rnd_next|Com_select|Com_insert|Com_insert_select|Com_update|Com_replace|Com_replace_select|Table_scan_rate|Open_files|Open_files_limit|Open_files_rate|Created_tmp_disk_tables|Created_tmp_tables|Created_tmp_disk_tables_rate|Max_connections|Max_used_connections|Processlist|Max_connections_used_rate|Table_locks_immediate|Table_locks_waited|Engine_select|Connection_occupancy_rate} \033[0m"

;;
esac
fi