.. _doc_scene_tree:

场景树(Scene Tree)
=========

介绍
------------
(译注：SceneTree作为类名时不予翻译)
从这里开始事情开始越来越抽象，但是别担心，因为深奥的东西也不过如此了。

在上篇教程中，所有东西都围绕着节点(Node)的概念，场景(Scene)由它们构成，并且它们一旦进入了"场景树"中它们就开始变得活跃了。

这应该更深入一些。事实上，场景系统甚至都不是Godot中的核心部分，因为它是可以被跳过然后做个脚本(或者C++代码)直接访问伺服器(Server,本篇的Server只指代伺服器，而不指代网络上的服务器，网络服务器会在联网等相关章节中具体标注)。但是那样制作游戏将会有很大工作量并且也是为其他用途预留的。

主循环(MainLoop类)
--------

Godot内部工作原理如下。有一个 :ref:`OS <class_OS>` 类(Class)，是唯一一个在最开始就运行的实例。之后所有的驱动器、伺服器、脚本语言、场景系统等都被载入了。

当初始化完成后 :ref:`OS <class_OS>` 需要被提供一个 :ref:`MainLoop <class_MainLoop>` 来运行。截止到此，所有的这些是在内部完成的(如果你对内部工作原理感兴趣的话，你可以检验源代码中的main/main.cpp文件)

用户系统，或者游戏，在MainLoop中开始。这个类有一些方法(Method)，用于初始化(Initialization)、闲置(Idle)(帧同步回调,freame-synchronized callback)、以及输入(Input)。同样地，这很低级而且在Godot中制作游戏时，写你自己的MainLoop根本没什么意义。

场景树
---------

解释Godot如何工作的方式之一，那就是它是一个在一个低级中间件基础上的高级游戏引擎。

场景系统就是游戏引擎，而 :ref:`OS <class_OS>`和伺服器就是低级应用程序接口(API,Application Plugin Interface)。

无论何时，场景系统为OS、 :ref:`SceneTree <class_SceneTree>` 提供了自己的主循环。

在运行一个场景时，这是被自动实例化并设定的，无需再做额外的事情。

知道一个类的存在是很重要的因为它有如下重要的用处：

-  它包含了根 :ref:`Viewport <class_Viewport>`，当一个场景第一次被打开时，它被添加为它的一个子并成为了 *场景树* 的一部分。(具体内容在后文)
-  它包含了关于组(Group)的信息，并且能够调用组内的所有节点，或者获取到它们的列表。
-  它还包含一些全局级别的功能，比如设定暂停模式或者退出进程等。

当一个节点是场景树的一部分时，
:ref:`SceneTree <class_SceneTree>`
单例类能够通过只调用
:ref:`Node.get_tree() <class_Node_get_tree>`来被获取到。

根视区(Root Viewport)
-------------

根:ref:`视区(Viewport) <class_Viewport>`
总是在场景的最顶端，通过一个节点它能够以两种不同的方式被获取到。

::

        get_tree().get_root() # access via scenemainloop
        get_node("/root") # access via absolute path

这个节点包含了主要视区，所有作为:ref:`Viewport <class_Viewport>`子的东西默认被绘制在它里面，所以所有节点的顶端总是这个类型是有很重要的，否则什么也看不见！

比较于其他的视区能够被创建在场景中(用来做分屏效果和此类的东西)，这个根视区是永远不会被用户所创建的。它在场景树中被自动创建。

场景树
----------

当一个节点被直接地或间接地连接到根视区时，它就成为 *场景树* 的一部分。

这也就意味着，正如在之前教程中所诠释的那样，将会得到_enter_tree()和_ready()的回调(还有_exit_tree())。

.. image:: /img/activescene.png

当节点进入 *场景树* 中时，他们变得活跃了。他们开始获取他们需要处理的一切事物，获取输入、2D和3D显示、通告(Notification)、播放音乐、组等。当他们从*场景树*中被移除时，他们将失去它。

场景树顺序
----------

在Godot中大多数节点操作，比如2D绘制(Drawing)、处理(Processing)或者获取通告都以场景树完成的。这也就是说低阶的父级和姊妹级将会在当前节点之前被通告(Notificated)。

.. image:: /img/toptobottom.png

通过进入 *场景树* 来活跃化
----------------------------------------------

#. 一个场景通过撰写代码来创建或从磁盘导入。
#. 这个场景的根节点(只有一个，还记得么？)被添加作为一个根视区(来自于场景树)的子级或者是被添加到它别的子级以及隔代子级。
#. 新添加的场景中每一个节点都会自上而下接收"enter_tree"通告(在GDScript中的 _enter_tree() 回调)。
#. 又一个通告"ready"(GDScript中的 _ready() 回调)为方便起见被提供，这时一个节点和它的所有子节点都进入了这个活动场景中。
#. 当一个场景(或者它的一部分)被移除时，它们将会自下而上地接收到"exit scene"通告(GDScript中的 _exit_tree() 回调)。

改变当前场景
----------------------

一个场景被载入以后，我们通常都要把一个场景改变为另一个。简单的方法就是使用
:ref:`SceneTree.change_scene() <class_SceneTree_change_scene>`
函数：

::

    func _my_level_was_completed():
        get_tree().change_scene("res://levels/level2.scn")

这是切换场景的一个快速有效的方式，但是有一个缺点：在新场景被载入并运行之前，游戏将被搁置挂起。在你游戏中的一些情况下，我们可能想要创建带有进度条的合适的载入画面、动态指示物或者线程(背景)载入。这必须通过使用AutoLoad(自动载入)和
:ref:`doc_background_loading`
来手动地实现。
