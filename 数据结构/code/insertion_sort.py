"""插入排序 —— 带完整过程追踪的实现

运行方式（Windows Git Bash / PowerShell / CMD 均可）：
    python insertion_sort.py

这个脚本做两件事：
1. 打印一次完整的插入排序过程，逐轮展示「取 key → 挪空位 → 放 key」
2. 用最坏/最好输入统计比较次数，验证 Θ(n²) 与 Θ(n)
"""


def insertion_sort_traced(a):
    """插入排序，打印每一轮的详细过程。"""
    a = a[:]                      # 不修改调用者的数组
    n = len(a)
    print(f"初始数组: {a}")
    print("=" * 62)

    for i in range(1, n):
        key = a[i]                # ① 取出 key（必须先存起来！）
        j = i - 1
        print(f"第 {i} 轮：key = a[{i}] = {key}，要把它插进左边已排好序的 a[0..{i-1}] = {a[:i]}")

        # ② 从右往左扫，比 key 大的都右移一格，空位左移
        while j >= 0 and a[j] > key:
            print(f"    a[{j}] = {a[j]} > {key}  →  右移一格到 a[{j + 1}]")
            a[j + 1] = a[j]
            j -= 1

        # ③ 空位找到了，放 key
        if j < 0:
            print(f"    已扫到数组开头  →  {key} 放在 a[0]")
        else:
            print(f"    a[{j}] = {a[j]} ≤ {key}  →  停止，{key} 放在 a[{j + 1}]")
        a[j + 1] = key

        print(f"    本轮结束: {a}   （已排序区 = a[0..{i}]，共 {i + 1} 个元素）")
        print("-" * 62)

    print(f"最终结果: {a}")
    return a


def count_ops(a):
    """统计比较次数和赋值（移动）次数。"""
    a = a[:]
    n = len(a)
    cmp_cnt = move_cnt = 0

    for i in range(1, n):
        key = a[i]
        j = i - 1
        while j >= 0:
            cmp_cnt += 1
            if a[j] > key:
                a[j + 1] = a[j]
                move_cnt += 1
                j -= 1
            else:
                break
        a[j + 1] = key
        move_cnt += 1

    return cmp_cnt, move_cnt


def verify_complexity():
    print("\n=== 复杂度验证 ===")
    print(f"{'n':>7} | {'最坏比较':>10} | {'n(n-1)/2':>10} | {'最好比较':>10}")
    print("-" * 50)

    for n in (10, 100, 1000):
        worst = list(range(n, 0, -1))   # 完全逆序 → 最坏情况
        best = list(range(1, n + 1))    # 已经有序 → 最好情况
        c_worst, _ = count_ops(worst)
        c_best, _ = count_ops(best)
        print(f"{n:>7} | {c_worst:>10,} | {n * (n - 1) // 2:>10,} | {c_best:>10}")

    print("\n结论：")
    print("  最坏比较次数 = n(n-1)/2 = Θ(n²)  —— 完全逆序时每个元素都要挪到头")
    print("  最好比较次数 = n-1      = Θ(n)   —— 已经有序时每轮只比较 1 次就停")
    print("  这就是插入排序的「适应性」：对近似有序的数据特别快")


if __name__ == "__main__":
    insertion_sort_traced([8, 2, 4, 9, 3, 6])
    verify_complexity()
