# 作业代码 · 题目对照与运行结果图

> **公式完整版**：[作业代码索引.html](./作业代码索引.html) —— 独立 HTML，204 个公式全部由随仓库提交的 KaTeX 本地渲染，带两级目录与小节锚点，断网可用。
> 在 github.com 上点 `.html` 只会看到源码，看渲染版请走 [GitHub Pages](https://michaellu2007.github.io/fdu-note-summarized/数值算法与案例分析/作业代码/作业代码索引.html)，或克隆仓库后直接双击打开。
>
> **这一份是速览版**：只放图、结论和链接，不写数学公式。GitHub 的 Markdown 对公式定界符有严格边界要求，紧贴中文时公式会退化成美元符号原文，行间公式写成同一行还会被降级成行内、把行距撑歪。所有式子都搬到上面那份 HTML 里了，逐题的完整解读也在那里。

把每周作业题、我自己写的 MATLAB 代码、以及代码跑出来的图放在一起对照。**先看题目在问什么，再看图说了什么结论**——图不是装饰，是把题目里那句「What do you observe?」变成能看见的东西。

- 覆盖 2026-09-08 ~ 2026-11-03 共 **8 周作业**、**11 份作业 MATLAB 代码 + 2 份补做可视化脚本**、**19 张运行结果图**。
- 前 4 周以证明/手算题为主，代码写在 C++ 里或没留代码，所以没有图；有图的从 10-13 开始。
- 19 张图里 **14 张由作业脚本直接导出**，另 **5 张**来自 `visualize/` 下补写的两份脚本（10-27 P1、11-03 P4 的原脚本只打印数值、不画 figure）。图全部由本机 **MATLAB R2025a** 无头模式实跑导出，没有手绘、没有示意假图。

---

## 目录怎么读

```
作业代码/
├── README.md                      ← 本文件（图 + 结论速览）
├── 作业代码索引.html                ← 公式完整版，离线 KaTeX
├── 2026-10-20/                    ← 一周一个目录
│   ├── homework-20261020.pdf      ← 老师出的题目原文
│   ├── P2_Pascal_INVIT_RQI.m      ← 题号前缀 + 内容描述
│   └── ...
├── figures/2026-10-20/            ← 这一周跑出来的图
│   └── 20261020_P2_Pascal_INVIT_RQI_fig1.png
└── visualize/                     ← 两道「原脚本只打印数字」的题，补做的可视化脚本
    ├── VIS_P1_eigenvector_visualization.m
    └── VIS_P4_Jordan_forward_error.m
```

文件名的 `P<n>_` 前缀对应题目 PDF 里的第 n 题。**没有代码的题不编造代码**，在每周末尾列出并说明为什么没有。

> ⚠️ `Homework & Exam/数值算法 01–13` 是往届学长的作业解答，PDF 里带姓名学号，**不是我的成果，不入库**，只作参考。
> 题目 PDF 的版权归复旦大学及授课教师所有，这里仅为个人复习存档。

---

## 八周总览

| 周次 | 题目 PDF | 有代码的题 | 图 | 一眼看懂的结论 |
|---|---|---|---|---|
| 09-08 | [PDF](./2026-09-08/homework-20260908.pdf) | P5 | 1 | GE 计时在双对数上斜率 2.58，接近理论的三次增长但还没进渐近区 |
| 09-15 | [PDF](./2026-09-15/homework-20260915.pdf) | — | 0 | 浮点误差分析周，代码是 C++，按约定未入库 |
| 09-22 | [PDF](./2026-09-22/homework-20260922.pdf) | — | 0 | 三对角 GE 精度，代码是 C++，未入库 |
| 09-29 | [PDF](./2026-09-29/homework-20260929.pdf) | — | 0 | P4 六种 QR 正交性比较（题目要求画图），当时没留代码 |
| 10-13 | [PDF](./2026-10-13/homework-20261013.pdf) | P2, P5 | 2 | Arnoldi 的正交性随步数丢到百万分之一量级；正矩阵幂法第二步就贴上真值 |
| 10-20 | [PDF](./2026-10-20/homework-20261020.pdf) | P2, P3, P5×2 | 6 | RQI 比 INVIT 快；子空间迭代「多取一列」才不卡住；MGS-Arnoldi 在退化矩阵上彻底不正交 |
| 10-27 | [PDF](./2026-10-27/homework-20261027.pdf) | P1, P4, P5 | 7 | 回代分母就是特征值之差；秩一修正方程的根与特征值一一交错；Jacobi 的收敛史 |
| 11-03 | [PDF](./2026-11-03/homework-20261103.pdf) | P4 | 3 | Jordan 块把机器精度级的舍入放大成万分之一量级的特征值误差 |

---

## 运行结果图（按周）

### 2026-09-08 · P5 Gaussian elimination 计时

代码：[`P5_GE_timing_loglog.m`](./2026-09-08/P5_GE_timing_loglog.m)　题目：[PDF](./2026-09-08/homework-20260908.pdf)

![GE 计时的双对数曲线](./figures/2026-09-08/20260908_P5_GE_timing_fig1.png)

双对数上拟合斜率 **2.577**，理论该是 3；规模还不够大、BLAS 与内存访问的常数项没进渐近区，计时还含矩阵生成开销。跑到 `n=2400` 用了 67.2 秒。

### 2026-10-13 · P2 Arnoldi 正交性、P5 幂法

代码：[`P2_Arnoldi_orthogonality.m`](./2026-10-13/P2_Arnoldi_orthogonality.m)、[`P5_power_iteration_rho.m`](./2026-10-13/P5_power_iteration_rho.m)　题目：[PDF](./2026-10-13/homework-20261013.pdf)

![Arnoldi 过程中的正交性损失](./figures/2026-10-13/20261013_P2_Arnoldi_orthogonality_fig1.png)

![幂法收敛历史](./figures/2026-10-13/20261013_P5_power_iteration_fig1.png)

左图：不修正与重正交化两条曲线都随步数上升，只差约一个数量级——长递推里 MGS 一步步把舍入累积进正交基。右图：随机正矩阵的幂法第二步就贴上谱半径，100 步后差约 `5.68e-13`。

### 2026-10-20 · P2 INVIT/RQI、P3 子空间迭代、P5 Hessenberg

代码：[`P2_Pascal_INVIT_RQI.m`](./2026-10-20/P2_Pascal_INVIT_RQI.m)、[`P3_Wilkinson_subspace_iteration.m`](./2026-10-20/P3_Wilkinson_subspace_iteration.m)、[`P5_Hessenberg_Householder_vs_Arnoldi.m`](./2026-10-20/P5_Hessenberg_Householder_vs_Arnoldi.m)、[`P5_Hessenberg_orthogonality_early.m`](./2026-10-20/P5_Hessenberg_orthogonality_early.m)　题目：[PDF](./2026-10-20/homework-20261020.pdf)

![INVIT 与 RQI 收敛历史](./figures/2026-10-20/20261020_P2_Pascal_INVIT_RQI_fig1.png)

![子空间迭代 5 列与 6 列的收敛对比](./figures/2026-10-20/20261020_P3_subspace_iteration_fig1.png)

RQI 约 5 步到机器精度平台，INVIT 要 8 步左右。子空间迭代取 5 列时残差降到 `1e-8` 就平了，取 6 列一路降到 `1e-15`——Wilkinson 矩阵第 5、6 个特征值模几乎相等，多取一列才换掉分母。

![四种情形下的逐元素正交性色图](./figures/2026-10-20/20261020_P5_Hessenberg_fig1.png)

![正交性损失随矩阵维度变化](./figures/2026-10-20/20261020_P5_Hessenberg_fig2.png)

![早期版的逐元素正交性色图](./figures/2026-10-20/20261020_P5_early_fig1.png)

![早期版的范数随维度变化](./figures/2026-10-20/20261020_P5_early_fig2.png)

随机矩阵上 Householder 与 MGS-Arnoldi 都好；换成全 1 严格上三角阵，Arnoldi 的 Krylov 序列几步就塌到同一个方向，维度越大越糟，是量级上的崩塌而不是缓慢变差。后两张是同一份代码的早期版本，误差集中在后生成的列之间，正是 MGS 逐步累积的样子。

### 2026-10-27 · P1 特征向量、P4 秩一修正、P5 Jacobi

代码：[`P1_upper_triangular_eigenvectors.m`](./2026-10-27/P1_upper_triangular_eigenvectors.m)、[`P4_rank1_eigenvalue_plot.m`](./2026-10-27/P4_rank1_eigenvalue_plot.m)、[`P5_Jacobi_diagonalization.m`](./2026-10-27/P5_Jacobi_diagonalization.m)　题目：[PDF](./2026-10-27/homework-20261027.pdf)

> 下面前两张图由 [`VIS_P1_eigenvector_visualization.m`](./visualize/VIS_P1_eigenvector_visualization.m) 补做，原作业脚本只打印三个数值、不画图。

![回代法与 eig 的残差、夹角](./figures/2026-10-27/20261027_P1_eigenvector_residual_fig1.png)

![特征值间隔缩小时回代法的变化](./figures/2026-10-27/20261027_P1_eigenvector_residual_fig2.png)

对角元离得开时，自己写的回代法和 `eig` 一样准。但把间隔缩小，归一化**之前**的向量范数会暴涨到 `1e100` 以上——归一化把中间量的爆炸掩盖了，只看残差会漏掉这个陷阱；原因就是回代分母等于两个特征值之差。

![f(lambda) 曲线、渐近线与特征值](./figures/2026-10-27/20261027_P4_rank1_f_fig1.png)

6 个特征值全部落在曲线的零点上，每两个相邻极点之间恰好一个——秩一修正的交错性质，也是 D&C 分治解特征值方程的图形依据。

![Jacobi 耗时随规模变化](./figures/2026-10-27/20261027_P5_Jacobi_fig1.png)

![Jacobi 与 MATLAB eig 的耗时对比](./figures/2026-10-27/20261027_P5_Jacobi_fig2.png)

![整体收敛史](./figures/2026-10-27/20261027_P5_Jacobi_fig3.png)

![逐分量收敛观察](./figures/2026-10-27/20261027_P5_Jacobi_fig4.png)

自写 Jacobi 比内置 `eig` 慢 1~2 个数量级，算法对但工程实现和 LAPACK 差得远。收敛史里红色（cyclic + 选最大元）平稳下降，黑色经典版提前终止，蓝色「故意选错旋转」几乎水平——选对旋转不是优化，是能不能收敛的前提。

### 2026-11-03 · P4 Jordan 块的特征值前向误差

代码：[`P4_Jordan_eigenvalue_error.m`](./2026-11-03/P4_Jordan_eigenvalue_error.m)　题目：[PDF](./2026-11-03/homework-20261103.pdf)

> 下面三张图由 [`VIS_P4_Jordan_forward_error.m`](./visualize/VIS_P4_Jordan_forward_error.m) 补做，原作业脚本只打印一张误差表、不画图。

![不同重数 Jordan 块的误差](./figures/2026-11-03/20261103_P4_Jordan_forward_error_fig1.png)

![Jordan 块与可对角化矩阵的误差对照](./figures/2026-11-03/20261103_P4_Jordan_forward_error_fig2.png)

![cond(X) 对误差的影响](./figures/2026-11-03/20261103_P4_Jordan_forward_error_fig3.png)

给 m 重 Jordan 块加一点扰动，特征值前向误差正比于扰动的 m 次方根：双对数上是斜率 `1/m` 的直线，重数越高越平、误差越大。双精度舍入本身就有 `1e-16` 量级扰动，四重块的特征值误差天生在 `1e-4` 量级。换成真对角阵，同样的构造流程误差立刻掉 9 个数量级。

---

## 需要注意的实现缺口

| 位置 | 情况 |
|---|---|
| 10-20 P5 | 题目要求同时检查还原精度 `Q*AQ-H` 和正交性 `Q*Q-I` 两个指标，代码与上面六张图**只画了后者**，前者没算。正交性这一半结论可信，另一半还没验证 |
| 10-13 P2 | 代码图例写「重正交化修正（误差极小）」，但图上绿线同样升到 `1e-7`，并没保持机器精度；也没有和 CGS2/MGS2 对照 |
| 10-13 P2 | `Arnoldi.m` 把局部函数定义写在脚本段**之前**，直接运行会报错。仓库里的图是用「把第 1–43 行挪到文件末尾」的临时副本跑的，**代码内容原样未改** |
| 09-29 P4 | 题目要求用 `imagesc` 比较六种 QR 的正交性损失，当时没留代码；10-20 P5 的色图可以当作它的「后人」对照看 |
| 09-15 / 09-22 | 两份 C++ 程序在工作区根目录，按约定未入库 |
| 10-20 早期版 | 原文件名 `RQgenerateuppertriangular.m` 名实不符（内容其实是 Hessenberg 约化的正交性检查），按内容重命名并作为 P5 早期版本保留 |

---

## 复现这些图

```matlab
% 普通作业脚本：进入对应周目录直接运行，figure 会显示出来
cd('2026-10-20'); P2_Pascal_INVIT_RQI

% 补做的两份可视化：直接运行即可，PNG 自动写进 ../figures/<周>/
cd('visualize'); VIS_P1_eigenvector_visualization
cd('visualize'); VIS_P4_Jordan_forward_error
```

批量导出用 `matlab -batch` + `set(0,'DefaultFigureVisible','off')` + `print(h,'-dpng','-r130')`，中文标签在本机默认字体下正常。**随机矩阵都设了种子**（作业脚本自带的 `rng` 保留），不同机器重跑数值量级一致、末位会有差别。

---

## 交叉索引：图 ↔ 课堂笔记

| 图中看到的现象 | 笔记里的推导 | 相关作业 |
|---|---|---|
| Arnoldi 正交性随步数丢失 | [10.20 课堂笔记 §4.3–§4.5](../课堂笔记-20261020-Krylov子空间与Arnoldi分解.html) | 10-13 P2、09-29 P4 |
| 幂法一步收敛 / 重根情形 | [10.13 补课笔记 §1.4](../补课笔记-幂法反幂法与第3章引言.html) | 10-13 P3/P4/P5 |
| 子空间迭代卡在 `1e-8` 平台 | [10.20 课堂笔记 §3.4](../课堂笔记-20261020-Krylov子空间与Arnoldi分解.html) | 10-20 P3 |
| RQI 三次收敛 | [10.13 补课笔记 §2.6](../补课笔记-幂法反幂法与第3章引言.html) | 10-20 P2 |
| 回代分母 = 特征值之差 | [10.27 课堂笔记 §2.3–§2.6](../课堂笔记-20261027-特征向量的计算.html) | 10-27 P1 |
| 秩一修正方程的零点与特征值交错 | [10.27 课堂笔记 §5.2](../课堂笔记-20261027-特征向量的计算.html) | 10-27 P3/P4 |
| 非对角范数下降、错旋转不收敛 | [10.27 课堂笔记 §4.1–§4.4](../课堂笔记-20261027-特征向量的计算.html) | 10-27 P5 |

> 上面这些 `.html` 链接在 github.com 上点开只会看到源码，看渲染版请走 [GitHub Pages](https://michaellu2007.github.io/fdu-note-summarized/)；或克隆仓库后直接双击打开（KaTeX 已随仓库提交，离线可用）。

---

课程内容与题目 PDF 版权归复旦大学及授课教师所有；代码、补做的可视化脚本与结果图为我本人所作，仅供个人复习存档。
