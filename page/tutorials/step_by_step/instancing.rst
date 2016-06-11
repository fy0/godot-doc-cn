.. _doc_instancing:

实例化
==========

基本理论
---------

先弄一个场景然后把节点丢进去可能对一个小工程会起作用，但随着工程的增大，越来越多的节点被使用，并且很快它们就会变得难以管理。为了解决这一问题，Godot允许一个工程被分成几个场景。然而，这样和其他游戏引擎的工作方式并不一样。事实上是差别很大，所以请不要跳过本教程！

来回顾一下：一个场景是被组织成树形图的节点的集合，其中它们只能有唯一的节点作为树的根。

.. image:: /img/tree.png

在Godot中，一个场景可以被创建并保存在磁盘上，你可以随心所欲尽可能多的创建并保存场景。

.. image:: /img/instancingpre.png

之后，当编辑一个存在的或者新的场景，其他场景能够被实例化为它的一部分：

.. image:: /img/instancing.png

在上图中，场景B被添加到场景A而成为一个实例。这起初似乎有点诡异，但是在本篇教程的结尾，这将相当的有意义！

实例化，从一点一滴开始
------------------------

要学习如何进行实例化，让我们先以下载一个范例工程开始：:download:`instancing.zip </files/instancing.zip>`.

解压这个场景到你喜欢的任意一个位置。然后把这个场景用“导入”（Import）选项添加到工程管理器中：

.. image:: /img/importproject.png

简单地浏览一下工程位置的内部然后打开engine.cfg文件。这个新的工程将会出现在工程列表中。通过使用“编辑”（Edit）选项来编辑工程。

这个工程包含两个场景“ball.scn”和"container.scn"。这个ball场景只是一个带有物理性质的球，而container场景则是有一个塑形精良的碰撞形体，以备球能够被扔进这里。

.. image:: /img/ballscene.png

.. image:: /img/contscene.png

打开container场景，然后选择根节点：

.. image:: /img/controot.png

之后，按下“+”形状的按钮，这是实例化按钮（Instancing Button）！

.. image:: /img/continst.png

选择场景ball（ball.scn），这个球应当出现在原点（Origin）(0,0)处，把他移到场景中心附近，像这样：

.. image:: /img/continstanced.png

按下运行，然后瞧！

.. image:: /img/playinst.png

这个被实例化的球跌入了坑的底部。

更多内容
-------------

在场境内可以根据需求有尽可能多的实例，那就尝试实例化更多的球，或者复制（Duplicate）它们（Ctrl+D或者复制按钮（Duplicate Button））：

.. image:: /img/instmany.png

然后尝试再次运行场景：

.. image:: /img/instmanyrun.png

很酷，是不是？这就是实例化的工作方式。

编辑实例
-----------------

选择众多球的拷贝当中的一个然后来到属性编辑器（Property Editor）。我们来让它更具有弹性，那就来找到弹性（Bounce）参数然后把他设成1.0：

.. image:: /img/instedit.png

接下来会发生的就是一个绿色的“复原”（Revert）按钮出现了。当这个按钮出现的时候，这就意味着我们从被实例化的场景中修改了一个属性（Property）来让这个值替换掉原来的在实例中的值。即使是属性值在源场景中被修改，自定义的值也总能覆盖它。按下复原按钮将会把属性恢复到来自于场景的原始值。

总结
----------

实例化似乎很便利，但是比起眼前的这些，它还有更多的内容。实例化教程的下一部分就会包含剩下的东西……
