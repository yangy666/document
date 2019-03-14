# 本产品功能
   自动监控文件大小的变化，并按照从高到低排序。

使用请运行：
	python3.7 main.py

1、软件运行环境为：Python 3.0版本以上
     使用前，请执行如下命令 ：pip3 install prettytable

2、目前只能监控 已存在的文件，在监控期间添加的软件 不会监控 【待更新】

3、windows 环境下 请更改97行代码：
	os.system('clear') 更改为：os.system('cls')