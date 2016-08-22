# Godot 中文文档计划

这是一个目标为汉化 godot 游戏引擎英文文档的计划。

汉化的目标有二：

1. 官方 rst 文档

2. godot class reference 文档（同样也是 editor 内部的帮助文档）

本项目由 Godot中文交流群(302924317) 发起。

## 参与流程

1. 首先 fork 此项目，找到一项无人认领的待翻译文本

2. 在贡献者一栏签上你的大名

3. 完成汉化后提交一个 Pull Request

4. **记得在任务认领将自己那条标记为完成**

5. **不要忘了阅读 [翻译行文规范](https://github.com/fy0/godot-doc-cn/wiki/翻译行文规范) ！！**

## 认领与汉化 - 官方 rst 文档

1. 要编辑的文档位于 page/locale/zh/LC_MESSAGES/ (除了 classes)，格式为 po 文档，与 page 下的 rst 文档一一对应。建议使用 poedit。

2. 单篇文档篇幅不等，所以也不要求一次认领整篇翻译

3. 在 Issue 中[任务认领](https://github.com/fy0/godot-doc-cn/issues/2)帖子留言认领任务，例如：**认领 xxx.rst 全篇/上半部分**


## 认领与汉化 - class reference

1. 要编辑的文件是 classes/base/classes.xml

2. 文本以一个 Class 为一个最小单位进行认领

3. 在 Issue 中[任务认领](https://github.com/fy0/godot-doc-cn/issues/2)帖子留言认领任务，例如：**认领 @GDScript** (类的名字)


## 编译和查看效果

1. 如果你只翻译page，而不关注 classes 部分（通常这也会拖慢make进程），只要有py2/py3两者之一即可

2. 如果你关注 classes 部分，那么 python2 是必备的，不光如此，若是win环境你还需要找到你的 python.exe 复制一份重命名为 python2.exe

3. 通过 pip 安装以下三个包：pip install sphinx sphinx-intl sphinx_rtd_theme

4. build_page.sh （若需要classes则先执行build_classes.sh）



## 贡献者

* [fy](https://github.com/fy0)

* [小太](https://github.com/Oberon-Tonya)

* [Geequlim](https://github.com/Geequlim)

* [非战不屈](https://github.com/wangshuo1617)

* [zhangshiqian1214](https://github.com/zhangshiqian1214)
 
* [rochesk](https://github.com/rochesk)

