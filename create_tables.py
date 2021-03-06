import sys

def judge_one_vis(visible, nums):
    result_list = []

    for items in nums:
        count = 1
        max_item = items[0]
        for each_item in items[1:]:
            if each_item > max_item:
                count += 1
                max_item = max(items[0], each_item)
        if count == visible:
            result_list.append(items)
    return result_list


def create_dict(nums, num):
    res_dict = {}
    for visible in range(1, num+1):
        vis_list = []
        line_list = judge_one_vis(visible, nums)
        if line_list is not []:
            vis_list += line_list
        res_dict[visible] = vis_list
    return res_dict


def permute(nums):
    res = []

    def backtrack(nums, tmp):
        if not nums:
            res.append(tmp)
            return
        for i in range(len(nums)):
            backtrack(nums[:i] + nums[i + 1:], tmp + [nums[i]])

    backtrack(nums, [])
    return res


def create_tables(vis_dict):
    tables = []
    table_sizes = []
    for key in vis_dict:
        temp_table = []
        # print(vis_dict[key])
        for items in vis_dict[key]:
            # print(items)
            temp = ','.join(items)
            temp_table.append(temp)
        table_sizes.append(len(temp_table))
        res_table = '|' + '|'.join(temp_table) + '|'
        tables.append(res_table)
        # print(res_table)
    return tables, table_sizes



if __name__ == '__main__':
    num = int(sys.argv[1])
    initial_list = []
    for i in range(num):
        initial_list.append(str(i+1))
    permute_list = permute(initial_list)
    vis_dict = create_dict(permute_list, num)
    tables, table_sizes = create_tables(vis_dict)
    print('sizes of each table:', table_sizes)

    with open('./tables.dzn', 'w') as f:
        for i in range(len(table_sizes)):
            s = 'table' + str(i+1) + ' = ['
            f.write(s + tables[i] + ']; \n')

