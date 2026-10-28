# FDU Note Summarized

把复旦课程的**讲义、板书、课堂照片**整理成**可离线阅读**的数学笔记。

笔记以单文件 HTML 交付，公式用 [KaTeX](https://katex.org/) 本地渲染（不依赖 CDN，断网也能正常显示），
示意图用内联 SVG（深浅色自动适配）。每一节都标注了**来源**：

| 标记 | 含义 |
|---|---|
| `板书 N` | 老师课上确实写过（附板书逐字原文） |
| `讲义 §x.y` | 讲义里有，但课上没讲 |
| *（无标记）* | 讲义没写、板书没有，是我按教材补的推导 |

这样缺课时能立刻判断「哪块现在必须看、哪块可以等老师讲到再回来」。

> 《NLP and LLMs》那几讲的原始材料是公开课件（每张幻灯片都带一段讲者备注），
> 所以用的是另一套标记：**课件** / **讲者备注** / **补充**，含义一一对应。
> 例外是 **Lecture 08**（后训练）：该讲幻灯片老师尚未发布，笔记改按课堂拍的 22 张**板书**整理，
> 用的是 **板书** / **补充** / **推导** / **易错** 四档，并附「板书逐张对照」表。
> 详见 [LLM与NLP/README.md](./LLM与NLP/README.md)。

## 在线预览（渲染版）

> **在 GitHub 上点开 `.html` 只会看到源码** —— github.com 的文件页只渲染 Markdown，HTML 一律当纯文本显示（安全考虑：渲染任意 HTML/JS 等于开放 XSS）。这是 GitHub 的既定行为，不是笔记的问题。
>
> 要看渲染后的样子（公式、内联 SVG、目录、深色模式），请走 **GitHub Pages**：

**<https://michaellu2007.github.io/fdu-note-summarized/>**

首页点课程卡片即可进入各笔记的渲染版。也可以把仓库克隆到本地，直接双击 `.html` 打开（完全离线，KaTeX 已随仓库提交）。

## 目录

| 课程 | 内容 | 笔记 |
|---|---|---|
| 数值算法与案例分析 | **10.13 补课**：幂法 / 反幂法、第 2 章补充（Krylov 子空间、Arnoldi、Lanczos）、第 3 章迭代法（Jacobi、Gauss-Seidel、收敛性判据、SOR）；**10.20 课堂**：子空间迭代、Krylov / Arnoldi 分解、QR 方法（Hessenberg 约化 → shifting → deflation、隐式 QR、牛顿法视角）；**10.27 课堂**：特征向量与对称特征值（Schur 型 + 回代法 dtrevc、特征向量条件数 1/|yᵀx|；对称特征值计算：全景（QZ / A = A* / Wilkinson / 连续映射）→ **Jacobi 方法** → **D&C 分治**含完整行列式引理（矩阵行列式引理 / Sylvester 行列式定理）；非对称 T 的分块回代 / 不变子空间 / 排序） | [进入](./数值算法与案例分析/) |
| 计算理论 | 有限自动机（Ch.2）/ 上下文无关语言（Ch.3） | [进入](./计算理论/) |
| 数据结构（与算法） | 绪论：数组 / 链表 / 栈 / 队列、括号匹配与表达式求值、算法分析、渐进记号、插入排序；第二讲 递归：递归三要素、二分查找、快速幂、Fibonacci 的二分递归陷阱、归并排序、递归树与主定理、树与三种遍历、堆与堆排序、优先队列；第三讲 快速排序：Partition 两种写法、最坏 / 平均分析、指示器随机变量、比较排序的 Ω(n log n) 下界（决策树）、计数排序与基数排序 | [进入](./数据结构/) |
| NLP and LLMs（CS40008.01） | Lecture 04 神经语言模型与循环注意力（前馈 LM、循环状态与 BPTT、LSTM、Bahdanau 注意力）；Lecture 05 注意力与 Transformer（自注意力、Q/K/V、正弦位置编码与 RoPE、多头、残差 / LayerNorm / FFN、原始论文证据）；Lecture 06 预训练与解码实践（位移目标与 token 损失、优化器更新八步、AdamW、warmup + 余弦、梯度裁剪、验证损失与困惑度、checkpoint 恢复、贪心 / 温度 / top-p 解码）；Lecture 07 算力预算与扩展律（6ND 与 16N 的记账、等算力剖面与最优分配、幂律拟合与外推失败、Chinchilla 前后对比）；Lecture 08 后训练：SFT 与奖励模型（loss mask 与 teacher forcing、前向 KL 的多峰平均、Bradley–Terry 与「分数差 = 偏好 log odds」、奖励模型训练细节、REINFORCE 与 log-derivative trick、Return / Value / Advantage、KL 约束闭式解与 DPO） | [进入](./LLM与NLP/) |
| 概率论 | 第四章 §4.1 数学期望（简单 → 非负 → 一般的三层定义、Lévy 单调收敛定理、线性性的完整证明、独立 ⇒ 乘积期望分解）；§3.3 随机变量独立性；随机变量可测性前置（σ-代数 / Borel 集 / 集族法）；§4.2 收敛定理（MCT / Fatou / 控制收敛 / a.s.）；§4.3 期望的计算（LOTUS、Stieltjes 积分）；§4.4 方差与五条性质；作业 14 题提示 | [进入](./概率论/) |

## 原始资料

本仓库的笔记是对下列**公开资料**的整理与补充，不是原始资料的转载：

- [Snivallus/FDU-Course-Notes-2024-2025](https://github.com/Snivallus/FDU-Course-Notes-2024-2025)
  —— 讲义 PDF 来源（`数值算法与案例分析Ⅰ` 目录下共 8 份）
- [Snivallus/Fudan-Courses](https://github.com/Snivallus/Fudan-Courses)
  —— 同一门课的 Python Notebook 笔记（`数值算法与案例分析` 目录）
- [baojian.github.io/llm-26-fall](https://baojian.github.io/llm-26-fall/)
  —— 《NLP and LLMs》(CS40008.01) 课件（Lecture 04 / 05 的笔记据此整理）

课程内容版权归**复旦大学**及授课教师所有，本仓库仅收录自己整理的笔记与补充推导。

## 打开方式

直接用浏览器打开对应目录下的 `.html` 文件即可，无需联网、无需安装任何东西。
KaTeX 资源已随仓库一起提交（`assets/katex/`）。
