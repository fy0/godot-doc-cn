.. _doc_singletons_autoload:

单例(Singletons)(自动载入)
=====================

介绍
------------

场景单例(Scene Singletons)是非常有用的东西，因为它们代表一个非常普遍的使用情形，但是在最开始他们的价值在哪里不甚清晰。

场景系统非常的有用，但是它自己还有一些缺点：

-  两个场景之间没有存储信息(比如核心(core)、包含的物件)的"共同"位置。
-  当持有那些信息时，我们可以去创建一个载入其他场景作为子级并释放它们的场景，但接下来如果完成了，我们不可以单独运行一个场景并期待它能够工作。
-  我们还可以在磁盘中的
   \`user://\` 下存储持续性的信息并让场景总载入它，但是在切换场景时载入/保存是相当笨拙的。

所以在使用Godot一会之后，这就变得明晰了，有必要具备场景的局部：

-  总被装在，无论场景何时从编辑器被打开。
-  能够存留全局变量(Global Variables)，比如玩家信息、物品、金钱等。
-  能够处理场景的切换和切换效果。
-  就是一种行为上类似于一个单例类的东西，因为GDScript有意地不支持全局变量。

基于这些原因，自动载入节点的选项和脚本就存在了。

自动载入(AutoLoad)
--------

AutoLoad 可以是一个场景、或者一个继承了一个节点（一个将要被创建然后会为它设置脚本的节点）的脚本。它们可以在 Scene > Project Settings > AutoLoad标签页下被添加到工程中。
AutoLoad can be a scene, or a script that inherits from Node (a Node
will be created and the script will be set to it). They are added to the
project in the Scene > Project Settings > AutoLoad tab.

每一个自动载入项
Each autoload needs a name, this name will be the node name, and the
node will be always added to the root viewport before any scene is
loaded.

.. image:: /img/singleton.png

This means, that a for a singleton named "playervariables", any node can
access it by requesting:

::

    var player_vars = get_node("/root/playervariables")

Custom scene switcher
---------------------

This short tutorial will explain how to make a scene switcher by using
autoload. For simple scene switching, the
:ref:`SceneTree.change_scene() <class_SceneTree_change_scene>`
method suffices (described in :ref:`doc_scene_tree`), so this method is for
more complex behaviors when switching scenes.

First download the template from here:
:download:`autoload.zip </files/autoload.zip>`, then open it.

Two scenes are present, scene_a.scn and scene_b.scn on an otherwise
empty project. Each are identical and contain a button connected to a
callback for going to the opposite scene. When the project runs, it
starts in scene_a.scn. However, this does nothing and pressing the
button does not work.

global.gd
---------

First of all, create a global.gd script. The easier way to create a
resource from scratch is from the resources tab:

.. image:: /img/newscript.png

Save the script to a file global.gd:

.. image:: /img/saveasscript.png

The script should be opened in the script editor. Next step will be
adding it to autoload, for this, go to: Scene [STRIKEOUT:> Project
Settings]> AutoLoad and add a new autoload with name "global" that
points to this file:

.. image:: /img/addglobal.png

Now, when any scene is run, the script will be always loaded.

So, going back to it, In the _ready() function, the current scene
will be fetched. Both the current scene and global.gd are children of
root, but the autoloaded nodes are always first. This means that the
last child of root is always the loaded scene.

Also, make sure that global.gd extends from Node, otherwise it won't be
loaded.

::

    extends Node

    var current_scene = null

    func _ready():
            var root = get_tree().get_root()
            current_scene = root.get_child( root.get_child_count() -1 )

Next, is the function for changing scene. This function will erase the
current scene and replace it by the requested one.

::

    func goto_scene(path):

        # This function will usually be called from a signal callback,
        # or some other function from the running scene.
        # Deleting the current scene at this point might be
        # a bad idea, because it may be inside of a callback or function of it.
        # The worst case will be a crash or unexpected behavior.

        # The way around this is deferring the load to a later time, when
        # it is ensured that no code from the current scene is running:

        call_deferred("_deferred_goto_scene",path)


    func _deferred_goto_scene(path):

        # Immediately free the current scene,
        # there is no risk here.    
        current_scene.free()

        # Load new scene
        var s = ResourceLoader.load(path)

        # Instance the new scene
        current_scene = s.instance()

        # Add it to the active scene, as child of root
        get_tree().get_root().add_child(current_scene)

        # optional, to make it compatible with the SceneTree.change_scene() API
        get_tree().set_current_scene( current_scene )

As mentioned in the comments above, we really want to avoid the
situation of having the current scene being deleted while being used
(code from functions of it being run), so using
:ref:`Object.call_deferred() <class_Object_call_deferred>`
is desired at this point. The result is that execution of the commands
in the second function will happen at an immediate later time when no
code from the current scene is running.

Finally, all that is left is to fill the empty functions in scene_a.gd
and scene_b.gd:

::

    #add to scene_a.gd

    func _on_goto_scene_pressed():
            get_node("/root/global").goto_scene("res://scene_b.scn")

and

::

    #add to scene_b.gd

    func _on_goto_scene_pressed():
            get_node("/root/global").goto_scene("res://scene_a.scn")

Finally, by running the project it's possible to switch between both
scenes by pressing the button!

(To load scenes with a progress bar, check out the next tutorial,
:ref:`doc_background_loading`)
