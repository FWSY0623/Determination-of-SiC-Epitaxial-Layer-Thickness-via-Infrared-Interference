# src 文件夹说明

&emsp;&emsp;本文件夹包含碳化硅（SiC）和硅（Si）外延层厚度计算的全部MATLAB代码。分为双光束干涉模型（附件1、2）和多光束干涉模型（附件3、4）。

> **重要提示**  
> 本代码是在数学建模竞赛期间快速完成的，当时为了方便简洁，直接写死了本地Excel文件的绝对路径。因此，所有file_path都需要根据你的实际环境手动修改。建议将数据放在当前工作目录下的 `attachment/` 文件夹中，并全局替换路径字符串。如果时间充裕，本可以用相对路径或uigetfile提升通用性，但竞赛优先保证了结果的正确性，望理解。

---

## 一、双光束干涉模型（附件1、2）

### 1.可视化与极值点提取
- `Visualization(attachment 1).m` – 读取附件1，绘图并标记极大/极小值点，筛选波数>2000cm⁻¹的有效极值点,并存入 `valid_data1`, `valid_data2`。
- `Visualization(attachment 2).m` – 同上，处理附件2。

### 2.柯西公式参数拟合（厚度方差最小化）
- `objective_function5.m` – 目标函数：根据柯西参数 `(A,B,C)` 计算各极值点对应的厚度，返回厚度方差。  
- `Parameter Fitting(attachment 1&2 together).m` – 主脚本：调用 `objective_function5`，使用 `fmincon` 优化柯西参数。  
  *依赖：需要先运行可视化脚本生成 `valid_data11` 等变量。*
- `Thickness Calculation(attachment 1&2 together).m` – 利用优化得到的柯西参数 `(a_opt,b_opt,c_opt)` 计算每个极值点对应的厚度，输出平均厚度 `avg_pred`。

### 3.可靠性分析
- `Normality test for thickness(attachment 1&2).m` – 对厚度序列进行散点图、变异系数（CV）、RMSE、直方图、Q‑Q图、Lilliefors正态性检验。  
  *依赖：需要厚度向量 `D11,D12,D21,D22`（由计算厚度的脚本生成）。*

### 4.多光束干涉判断（用于附件1、2）
- `Multi-beam Interference Judgment(attachment 1&2).m` – 利用问题2计算的厚度 `d = 7.4465e-4 cm` 和附件1数据，逐点计算 `η = |r01·r12|`，评估是否发生多光束干涉。

---

## 二、多光束干涉模型（附件3、4）

### 1.可视化与厚度粗估
- `Visualization and Thickness Estimation(attachment 3).m` – 针对附件3（硅，入射角10°）：绘制反射率曲线，去趋势、加窗、FFT，由主峰频率估算厚度初值 `d`。  
  *同理可用于附件4（入射角15°），需修改文件路径和入射角参数。*

### 2.折射率反演与拟合
- `myEquations.m` – 方程组：给定波数 `w` 和反射率 `r`，联立反射率公式和假设 `n1 = 1.1 * n2`，求解 `n1`（外延层）和 `n2`（衬底）。  
- `Data Processing of Refractive Index of Silicon Wafers and Substrates.m` – 主脚本：对附件3的每个波数点用 `fsolve` 求解 `(n1,n2)`，然后用3σ准则剔除异常值并插值，最后用柯西公式拟合 `n1(ν)` 和 `n2(ν)`，绘制对比图。  
  *输出：拟合系数（`p`,`q`）及插值函数 `n1_fit`, `n2_fit`。*  
  *处理附件4时需复制脚本并修改入射角及文件路径。*

- `Rs.m` 和 `Rp.m` – 计算 s 偏振和 p 偏振的反射率（基于Airy公式），用于遗传算法。

### 3.遗传算法优化厚度
- `Genetic Algorithm for Thickness.m` – 主脚本：使用遗传算法最小化理论反射率与实验反射率的残差平方和，优化厚度 `d`。  
  *依赖：需要先运行折射率拟合脚本，使工作区中存在 `n1_fit`, `n2_fit`。*

### 4.其他辅助文件
- `myEquations12.m` – 类似 `myEquations`，但用于碳化硅（附件1、2）的多光束干涉判断。  
- `gauss_fluctuation.m` – 给数据添加高斯随机波动，用于灵敏度分析。  
- `n1_v.m`, `n1_v_interp.m`, `n2_v.m` – 理论折射率模型（未在主流程中使用）。  
- `objective_function4.m`, `objective_function6.m`, `objective_function12.m` – 不同版本的目标函数（可选用）。

---

## 三、运行顺序建议

### 碳化硅（双光束干涉）
1. 修改路径，运行 `Visualization(attachment 1).m` 和 `Visualization(attachment 2).m`  
2. 运行 `Parameter Fitting(attachment 1&2 together).m`  
3. 运行 `Thickness Calculation(attachment 1&2 together).m`  
4. 运行 `Normality test for thickness(attachment 1&2).m`  
5. （可选）运行 `Multi-beam Interference Judgment(attachment 1&2).m`

### 硅（多光束干涉）
1. 修改路径，运行 `Visualization and Thickness Estimation(attachment 3).m` 获取初估厚度  
2. 运行 `Data Processing of Refractive Index of Silicon Wafers and Substrates.m`（附件3）  
3. 运行 `Genetic Algorithm for Thickness.m`  
4. 对附件4重复上述步骤（复制脚本并改入射角及文件路径）

> **注意**：部分脚本依赖前一步生成的工作区变量（如 `valid_data11`, `n1_fit` 等），请严格按照顺序运行，或将依赖代码合并到同一脚本中。

详细数学模型请参考根目录下的论文 `碳化硅外延层厚度的确定.pdf`。
