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

当初始化完成后 :ref:`OS <class_OS>` 需要被提供一个 :ref:`MainLoop <class_MainLoop>`来运行。截止到此，所有的这些是在内部完成的(如果你对内部工作原理感兴趣的话，你可以检验源代码中的main/main.cpp文件)

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

根视野(Root Viewport)
-------------

根:ref:`视野(Viewport) <class_Viewport>`
总是在场景的最顶端，通过一个节点它能够以两种不同的方式被获取到。

::

        get_tree().get_root() # access via scenemainloop
        get_node("/root") # access via absolute path

这个节点包含了主要视野，所有作为:ref:`Viewport <class_Viewport>`子的东西默认被绘制在它里面，所以所有节点的顶端总是这个类型是有很重要的，否则什么也看不见！

比较于其他的视野能够被创建在场景中(用来做分屏效果和此类的东西)，这个根视野是永远不会被用户所创建的。它在场景树中被自动创建。

场景树
----------

当一个节点被直接地或间接地连接到根视野时，它就成为 *场景树* 的一部分。

这也就意味着，正如在之前教程中所诠释的那样，将会得到_enter_tree()和_ready()的回调(还有_exit_tree())。

.. image:: /img/activescene.png

When nodes enter the *Scene Tree*, they become active. They get access
to everything they need to process, get input, display 2D and 3D,
notifications, play sound, groups, etc. When they are removed from the
*scene tree*, they lose it.

Tree order
----------

Most node operations in Godot, such as drawing 2D, processing or getting
notifications are done in tree order. This means that parents and
siblings with less order will get notified before the current node.

.. image:: /img/toptobottom.png

"Becoming active" by entering the *Scene Tree*
----------------------------------------------

#. A scene is loaded from disk or created by scripting.
#. The root node of that scene (only one root, remember?) is added as
   either a child of the "root" Viewport (from SceneTree), or to any
   child or grand-child of it.
#. Every node of the newly added scene, will receive the "enter_tree"
   notification ( _enter_tree() callback in GDScript) in top-to-bottom
   order.
#. An extra notification, "ready" ( _ready() callback in GDScript) is
   provided for convenience, when a node and all its children are
   inside the active scene.
#. When a scene (or part of it) is removed, they receive the "exit
   scene" notification ( _exit_tree() callback in GDScript) in
   bottom-to-top order

Changing current scene
----------------------

After a scene is loaded, it is often desired to change this scene for
another one. The simple way to do this to use the
:ref:`SceneTree.change_scene() <class_SceneTree_change_scene>`
function:

::

    func _my_level_was_completed():
        get_tree().change_scene("res://levels/level2.scn")

This is a quick and useful way to switch scenes, but has the drawback
that the game will stall until the new scene is loaded and running. At
some point in your game, it may be desired to create proper loading
screens with progress bar, animated indicators or thread (background)
loading. This must be done manually using autoloads (see next chapter!)
and :ref:`doc_background_loading`.
