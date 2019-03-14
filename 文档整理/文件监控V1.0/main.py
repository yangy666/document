import threading
import time
import Th
import prettytable
import os


tab_hard = prettytable.PrettyTable(["文件名", "初始Size", "现在值/K", "一分钟增长", "实时增长", "总增长"])
input_file_path = input("请输入你要监控的路径:")
global_old_data = {}
global_new_data = {}
global_old_one_time = {}
global__new_one_time = {}
global_tmp_one_time = {}


# 循环10秒，读取所有的文件，并且写入data文件
def get_file_name(file_path):
    data = {}
    for root, dirs, files in os.walk(file_path):
        for file in files:
            if root == file_path:
                file_size = os.path.getsize(os.path.join(root, file))
                data[file] = file_size
        data_file = open("data", "w+")
        data_file.write(str(data))
        data_file.close()


# 初始化并排序数据 (参数为字典)
def init_data(data):
    return sorted(data, key=data.__getitem__, reverse=True)  # 将key从大到小排列


# 读取data文件中的内容并返回
def get_old_size():
    read_file = open("data", "r")
    data = read_file.read()
    data = eval(data)
    return data


# 计算一分钟内的增长
def one_sum():
    global global_old_data
    global global_new_data
    if len(global_old_one_time) == 0:
        for file_name in global_old_data:
            global_old_one_time[file_name] = 0
        for file_name in global_old_data:
            global_tmp_one_time[file_name] = 0
    while True:
        time.sleep(60)
        # 本分钟的增长值 - 上一分钟的增长值
        for i in global__new_one_time:
            global_tmp_one_time[i] = (global__new_one_time[i] - global_old_one_time[i])
            global_old_one_time[i] = (global_new_data[i] - global_old_data[i])


# 获取最新的值
def get_new_size(file_path):
    new_data = {}
    for root, dirs, files in os.walk(file_path):
        for file in files:
            if root == file_path:
                file_size = os.path.getsize(os.path.join(root, file))
                new_data[file] = file_size
    return new_data


# 计算总增长（新的值-旧的值）
def compare_data():
    global tab_hard
    global global__new_one_time
    tab_hard = prettytable.PrettyTable(["文件名", "初始Size", "现在值/K", "一分钟增长", "总增长"])
    new_data_list = init_data(global_new_data)
    for new_data in new_data_list:
        try:
            global__new_one_time[new_data] = (global_new_data[new_data] - global_old_data[new_data])
            tab_hard.add_row([new_data,
                              Th.Byte.convert(global_old_data[new_data], Th.Units.KB, "%.2f"),
                              Th.Byte.convert(global_new_data[new_data], Th.Units.KB, "%.2f"),
                              Th.Byte.convert(global_tmp_one_time[new_data], Th.Units.KB, "%.2f"),
                              Th.Byte.convert((global_new_data[new_data] - global_old_data[new_data]),
                                              Th.Units.KB, "%.2f")])
            # 判断出现新文件异常以后，把新文件数值 写入到data文件内。
        except KeyError:
            global_old_data[new_data] = global_new_data[new_data]
            data_file = open("data", "w+")
            data_file.write(str(global_old_data))
            data_file.close()
    pr_data()


# 打印表格
def pr_data():
    os.system('clear')
    times = (time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())))  # 获取当前时间
    print("------------" + times + "------------监控中：" + input_file_path)
    print(tab_hard)


def init_page():
    get_file_name(input_file_path)
    global global_old_data
    global global_new_data
    global_old_data = get_old_size()
    global_new_data = get_new_size(input_file_path)
    text = init_data(global_old_data)
    for file_name in text:
        tab_hard.add_row([file_name, Th.Byte.convert(global_old_data[file_name], Th.Units.KB, "%.2f"),
                          Th.Byte.convert(global_old_data[file_name], Th.Units.KB, "%.2f"), '0', '0', '0'])


def main():
    # 初始化变量
    global global_old_data
    global global_new_data
    # init 初始化
    get_file_name(input_file_path)
    global_old_data = get_old_size()
    # init_page()
    # 主循环 负责更新数据
    get_file_name(input_file_path)
    th = threading.Thread(target=one_sum)
    th.start()
    while True:
        time.sleep(1)
        global_new_data = get_new_size(input_file_path)
        global_old_data = get_old_size()
        compare_data()


if __name__ == '__main__':
    main()
