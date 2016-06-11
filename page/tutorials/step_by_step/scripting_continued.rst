.. _doc_scripting_continued:

脚本(续)
=====================

处理
----------

在Godot中一些动作由回调函数或虚函数触发，所以没必要去检查持续执行的代码。不仅如此，很多都能够用动画播放器（Animation Player）来完成。

然而，有一个脚本在每一帧进行处理依旧是一个常见情况。有两种处理方式，空闲处理（Idle Processing）和固定处理（Fixed Processing）。

空闲处理由
:ref:`Node.set_process() <class_Node_set_process>`
函数激活。一旦激活， :ref:`Node._process() <class_Node__process>` 回调将会在每一帧被调用。举个例子

::

    func _ready():
        set_process(true)

    func _process(delta):
        # do something...

参数delta描述了从上一次回调_process()到现在的持续时间（以秒为单位，为浮点数）。固定处理也是相似的，但只在和物理引擎同步的时候才会用到。

验证这件事的一个简单方式就是去创建一个包含一个带有如下脚本的标签节点的场景：

::

    extends Label

    var accum=0

    func _ready():
        set_process(true)

    func _process(delta):
        accum += delta
        set_text(str(accum))

这将会显示一个每秒递增的计数器。

组（Groups）
------

节点可以被添加到组里（每个节点根据需要可以尽可能多的添加）。这对于组织大型场景是一个简单的但是很有用的特性。有两种方式能够做到这点，第一个就是通过UI，在Groups按钮（Groups button）中：

.. image:: /img/groups.png

而另一种就是通过代码。比如，下面就一个很有用的范例来标记作为敌人的场景。

::

    func _ready():
        add_to_group("enemies")

以这种方式，如果在秘密基地里乱跑的玩家被发现了，通过使用
:ref:`SceneTree.call_group() <class_SceneTree_call_group>`:
，所有的敌人都能够注意到警报的响起，

::

    func _on_discovered():
        get_tree().call_group(0, "guards", "player_was_discovered")

上述代码将会调用在组"guards"里面所有成员上的函数"player_was_discovered"。

可选地，你也可以获取到"guards"节点的完整列表，通过调用
:ref:`SceneTree.get_nodes_in_group() <class_SceneTree_get_nodes_in_group>`:

::

    var guards = get_tree().get_nodes_in_group("guards")

更多关于
:ref:`SceneTree <class_SceneTree>`
的内容将会在后面加入

通告（Notifications）
-------------

Godot还有一个通告系统，这通常不需要从脚本中调用，因为他们太低层了并且虚函数能够提供他们中的绝大部分。你只消知道他们存在就可以了。在你的脚本中单纯添加一个
:ref:`Object._notification() <class_Object__notification>`
函数： 

::

    func _notification(what):
        if (what == NOTIFICATION_READY):
            print("This is the same as overriding _ready()...")
        elif (what == NOTIFICATION_PROCESS):     
            var delta = get_process_time()
            print("This is the same as overriding _process()...")

在 :ref:`Class Reference <toc-class-ref>` 中
关于每个类（Class）的文档显示了他能接收到的通告。然而，还是，对于大多数的情形下，脚本提供了更简单的可重载函数。

可重载函数（Overrideable Functions）
----------------------

正如前文所述，最好去使用这些函数。节点提供了许多有用的可重载函数，其被如下描述：
As mentioned before, it's better to use these functions. Nodes provide
many useful overrideable functions, which are described as follows:

::

    func _enter_tree():
        # When the node enters the _Scene Tree_, it become active 
        # 当节点进入节点树的时候，他开始活动。
        # and  this function is called. Children nodes have not entered 
        # 并且这个函数被调用。子节点还没有进入到
        # the active scene yet. In general, it's better to use _ready() 
        # 活动场景中。总体上，最好去使用_ready()函数
        # for most cases.
        # 对于大多数情形。
        pass

    func _ready():
        # This function is called after _enter_tree, but it ensures 
        # 这个函数在_enter_tree之后被调用，但是它确保了
        # that all children nodes have also entered the _Scene Tree_, 
        # 所有的子节点也进入到了节点树，
        # and became active.
        # 并开始活跃。
        
        pass 

    func _exit_tree():
        # When the node exits the _Scene Tree_, this function is called. 
        # 当节点退出节点树的时候，这个函数将会被调用。
        # Children nodes have all exited the _Scene Tree_ at this point 
        # 子节点已经全部退出了节点树
        # and all became inactive.
        # 并且都变得不活跃了。
        pass

    func _process(delta):
        # When set_process() is enabled, this function is called every frame.
        # 当set_process()被启用时，这个函数可以在每帧被调用。
        pass

    func _fixed_process(delta):
        # When set_fixed_process() is enabled, this is called every physics 
        # 当set_fixed_process()被启用时，这在每个物理帧中被调用。
        # frame.
        pass

    func _paused():
        # Called when game is paused. After this call, the node will not receive 
        # 当游戏被暂停时调用。在这次调用之后，节点将不再收到
        # any more process callbacks.
        # process回调。
        pass

    func _unpaused():
        # Called when game is unpaused.
        # 当游戏被解除暂停时调用。
        pass

创建节点
--------------

为了通过代码来创建一个节点，只需要调用.new()方法即可，（就像其余的基于类的数据类型），比如说：
To create a node from code, just call the .new() method, (like for any
other class based datatype). Example:

::

    var s
    func _ready():
        s = Sprite.new() # create a new sprite!
        add_child(s) # add it as a child of this node

欲删除一个节点，无论在场景内外，free()都必须被使用：

::

    func _someaction():
        s.free() # immediately removes the node from the scene and frees it

当节点被释放（Free）后，它也将释放所有的子节点。由于这一点，手动删除节点比让它出现是更简单的。只需要释放基节点（Base Node）继而在分支树下的所有东西都将随之消失。

然而，这可能是一种普遍情况，我们可能想要去删除一个当前被“封锁”的节点，就是这个节点正在发射信号（Signals）或者在调用一个函数。这就会导致游戏崩溃。在调试器（Debugger）中运行Godot通常会捕获（Catch）这个情况并且警告你。

删除节点的最安全的方式就是去使用
:ref:`Node.queue_free() <class_Node_queue_free>`
作为替代。这会在闲置时安全地擦除这个节点。

::

    func _someaction():
        s.queue_free() # remove the node and delete it while nothing is happening

场景的实例化
-----------------

通过代码来实例化一个场景是相当简单的并且在两步内就能完成。第一步就是从磁盘载入场景。

::

    var scene = load("res://myscene.scn") # will load when the script is instanced

有时预加载会更方便，因为它发生在语义解析（Parse）期间。

::

    var scene = preload("res://myscene.scn") # will load when parsing the script

但是 'scene' 依旧不是一个包含着子节点的节点。它被封装在一个特殊的资源叫做（此处供测试，如果成功将会替换 :ref:`封装场景 <class_PackedScene>`） :ref:`PackedScene <class_PackedScene>`.
为了创建实际的节点，函数
:ref:`PackedScene.instance() <class_PackedScene_instance>`
必须被调用。这将会返回可以添加到活动场景中的节点树：

::

    var node = scene.instance()
    add_child(node)

这两步处理的优势在于一个封装的场景可能会持续地加载并准备就绪，所以它可以被用于创建尽可能多的实例。这特别地有用，比如说，用来在活动场景中快速地实例化一些敌人、子弹等。
