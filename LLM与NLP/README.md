# NLP and LLMs（CS40008.01）

复旦大学 数据科学学院《NLP and LLMs》课程笔记。

- 授课教师：**Baojian Zhou**
- 课件来源：<https://baojian.github.io/llm-26-fall/>
- 本目录整理的是 **Lecture 04** 与 **Lecture 05** 两讲

## 笔记

| 讲次 | 内容 | 笔记 |
|---|---|---|
| Lecture 04 | **神经语言模型与循环注意力**：bigram 的上下文限制、定长窗口前馈 LM、张量与损失（含数值稳定性）、循环状态与 BPTT 梯度、LSTM 门控、RNN 编码器–解码器与 Bahdanau 加性注意力 | [LLM-04-神经语言模型与循环注意力.html](./LLM-04-神经语言模型与循环注意力.html) |
| Lecture 05 | **注意力与 Transformer**：自注意力八步、Q/K/V 投影、正弦位置编码、RoPE（旋转、复数、相对偏移）、缩放点积注意力与因果掩码、多头注意力、残差 / LayerNorm / pre-LN / FFN、可运行的小模型与参数计数、原始论文的实验证据 | [LLM-05-注意力与Transformer.html](./LLM-05-注意力与Transformer.html) |

**渲染版（推荐）**：
[Lecture 04](https://michaellu2007.github.io/fdu-note-summarized/LLM与NLP/LLM-04-神经语言模型与循环注意力.html) ·
[Lecture 05](https://michaellu2007.github.io/fdu-note-summarized/LLM与NLP/LLM-05-注意力与Transformer.html)

> 表格里的相对路径链接在 **github.com 的文件页**点开只会看到**源码** —— GitHub 只渲染 Markdown，不渲染 HTML。
> 要看渲染后的页面请用上面的 Pages 链接，或克隆到本地直接双击 `.html`。

## 内容出处（三态）

这门课的原始材料是公开的 reveal.js 课件，每张幻灯片都带一段 `Note:` 讲者备注。
因此本目录的三态标记与「板书 / 讲义」体系略有不同：

| 标记 | 含义 |
|---|---|
| 课件 | 幻灯片正文里的内容（公式、表格、示例数值） |
| 讲者备注 | 幻灯片 `Note:` 里的讲者备注，相当于老师课堂上的口头讲解与提醒 |
| 补充 | 课件**只有图或只有结论、没有展开**的地方，由本笔记补的推导、验算与几何直觉 |

> **为什么要补这么多「补充」？** 这两讲的幻灯片里有大量**交互式示意图**
> （网页上靠 JavaScript 现场绘制，静态打开时是空白的）。本笔记把它们**重画成静态 SVG**，
> 并在每张图下面补齐课件没有写出来的公式推导和数字验算——
> 缺课时光看图是看不懂「这一步到底怎么算出来的」。
>
> 另外，课件里凡是**只给结论**的地方（例如「除以 √d_k 是为了控制方差」「FFN 占 2/3 参数」
> 「玩具批次的损失下界是 log2/10」），笔记里都把推导和验算过程写全了。
> 所有示例数值均独立复算过一遍。

## 勘误

整理过程中发现课件有几处需要限定或纠正的地方，笔记里已就地标注：

| 位置 | 课件原文 | 笔记里的处理 |
|---|---|---|
| L05 §1.7 | 「输入嵌入来自一个单独的预训练嵌入模型」 | 纠正：Transformer 的嵌入表通常与其他参数一起训练；预训练模型只是带着一张已训好的表 |
| L05 §2.7 | 残差学习标注为「CVPR, 2015」 | 纠正：预印本 2015 年，会议论文是 **CVPR 2016** |
| L05 §3.18 | 「比 ConvS2S 快 50 倍」 | 该说法把算力与时间混为一谈，且比较对象不明确；笔记改为按 Table 2 算出 6.5× / 52× 的训练 FLOPs 比 |
| L05 §2.9 | 图示为 post-LN，但代码截图实为 pre-LN | 指出这处不一致，并说明两者雅可比不同 |
| L05 §3.17 | 该参数计数容易被当成「BERT 参数量」 | 明确列出计入与排除的项，声明这不是精确的 BERT 计数 |

## 关于图

- 取自课件原始素材（未修改）：`L04-context-windows.svg`、`L04-feedforward-lm.svg`、
  `L04-recurrent-state.svg`、`L04-encoder-bottleneck.png`、`L04-rnn-attention.png`、
  `L05-rope-complex-plane.svg`、`L05-rope-pair-frequencies.svg`、`L05-decoder-model.svg`、
  `L05-causal-mask.svg`、`L05-ffn-parameter-share.svg`
- 其余示意图（共 16 张）为按课件内容与数据**重绘的静态 SVG**，颜色使用 CSS 变量，深浅色自动适配
- 两张曲线图（玩具训练损失、pre-LN vs post-LN）依据课件给出的实测数据重绘

## 打开方式

直接用浏览器打开对应 `.html` 文件即可，无需联网。
KaTeX 资源已随仓库提交（`assets/katex/`），公式全部本地渲染。

---

课程内容版权归**复旦大学**及授课教师所有，本目录仅收录自己整理的笔记与补充推导。
