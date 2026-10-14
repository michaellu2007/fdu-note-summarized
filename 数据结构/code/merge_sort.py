"""归并排序 —— 带完整递归过程追踪的实现

运行方式：
    python merge_sort.py

脚本做三件事：
1. 打印一次完整的归并排序递归过程（含每一层的合并）
2. 统计比较次数，验证 Θ(n log n)
3. 和插入排序正面对比，看 Θ(n²) 与 Θ(n log n) 的差距
"""

import random
import time


# ---------------------------------------------------------------- 基础版本

def merge(left, right, counter=None):
    """合并两个已排序的列表。counter 为 dict 时可统计比较次数。"""
    out = []
    i = j = 0

    # 两个指针同时走，谁小取谁
    while i < len(left) and j < len(right):
        if counter is not None:
            counter["cmp"] += 1
        if left[i] <= right[j]:          # <= 保证稳定排序
            out.append(left[i])
            i += 1
        else:
            out.append(right[j])
            j += 1

    # 某一边先空了，另一边剩下的直接搬过来
    out.extend(left[i:])
    out.extend(right[j:])
    return out


# ------------------------------------------------------- 带过程追踪的版本

def merge_sort_traced(a, depth=0):
    indent = "  " * depth
    print(f"{indent}merge_sort({a})")

    # 递归终止条件：0 或 1 个元素，天然有序
    if len(a) <= 1:
        print(f"{indent}  → 只剩 {len(a)} 个元素，天然有序，直接返回")
        return a[:]

    mid = len(a) // 2                       # ① Divide
    print(f"{indent}  ① 从中间切成 {a[:mid]} 和 {a[mid:]}")

    left = merge_sort_traced(a[:mid], depth + 1)    # ② Conquer
    right = merge_sort_traced(a[mid:], depth + 1)

    merged = merge(left, right)             # ③ Combine
    print(f"{indent}  ③ 合并 {left} + {right} → {merged}")
    return merged


# ------------------------------------------------------------ 统计版本

def merge_sort_count(a, counter):
    if len(a) <= 1:
        return a[:]
    mid = len(a) // 2
    left = merge_sort_count(a[:mid], counter)
    right = merge_sort_count(a[mid:], counter)
    return merge(left, right, counter)


def insertion_sort(a):
    """用作对比的插入排序"""
    a = a[:]
    for i in range(1, len(a)):
        key = a[i]
        j = i - 1
        while j >= 0 and a[j] > key:
            a[j + 1] = a[j]
            j -= 1
        a[j + 1] = key
    return a


# ------------------------------------------------------------------ 主程序

if __name__ == "__main__":
    print("=" * 66)
    print("一、完整递归过程（输入 [5, 2, 8, 1, 9, 3, 7, 4]）")
    print("=" * 66)
    data = [5, 2, 8, 1, 9, 3, 7, 4]
    print(f"最终结果: {merge_sort_traced(data)}")

    print()
    print("=" * 66)
    print("二、比较次数验证（Θ(n log n)）")
    print("=" * 66)
    print(f"{'n':>8} | {'比较次数':>12} | {'n·log₂n':>12} | {'比值':>8}")
    print("-" * 50)

    for n in (100, 1000, 10000, 100000):
        import math
        random.seed(42)
        arr = [random.randint(0, 10 ** 9) for _ in range(n)]
        counter = {"cmp": 0}
        merge_sort_count(arr, counter)
        nlogn = n * math.log2(n)
        print(f"{n:>8,} | {counter['cmp']:>12,} | {nlogn:>12,.0f} | {counter['cmp'] / nlogn:>8.2f}")

    print("\n比值稳定在 1 附近 → 比较次数确实正比于 n log n（而不是 n²）")

    print()
    print("=" * 66)
    print("三、和插入排序正面对比（同一台机器、同一批数据）")
    print("=" * 66)
    print(f"{'n':>8} | {'插入排序':>14} | {'归并排序':>14} | {'快多少倍':>10}")
    print("-" * 58)

    for n in (500, 1000, 2000, 4000):
        random.seed(7)
        arr = [random.randint(0, 10 ** 6) for _ in range(n)]

        t0 = time.perf_counter()
        insertion_sort(arr)
        t_insert = time.perf_counter() - t0

        t0 = time.perf_counter()
        merge_sort_count(arr, {"cmp": 0})
        t_merge = time.perf_counter() - t0

        print(f"{n:>8,} | {t_insert * 1000:>11.1f} ms | {t_merge * 1000:>11.1f} ms | {t_insert / t_merge:>9.1f}x")

    print("\n注意 n 每翻一倍：插入排序耗时约 ×4（n²），归并排序约 ×2.2（n log n）")
    print("这就是为什么排序一百万个元素时，归并是「秒级」而插入是「小时级」。")
