.. _doc_scenes_and_nodes:

场景与节点
================

介绍
------------

.. image:: /img/chef.png

试想一秒钟你不再是一个游戏开发者。取而代之地，你是一个大厨！把你时髦的衣服换成一个无檐帽和一个双排扣夹克。现在，你是在为你的宾客打造一个美味的菜肴而不是在做游戏。

所以，一个伙夫如何打造一个菜品呢？菜谱被分为两部分，第一个是成分，第二个是关于准备它的说明。以这种方式，任何人都能够遵照菜谱并调制出你的绝佳创意。

在Godot中制作游戏和这种方式非常相同。使用这个引擎感觉就像是在厨房里。在这个厨房里，“节点（Nodes）”就是装满了用于烹饪的新鲜材料的冰箱。

有很多种类型的节点，有的显示图像、有的播放声音、有的节点显示3D模型等等。有很多。

节点（Nodes）
-----

但先让我们来走基础。一个节点是创建一个游戏的基本元素，它具有一下性质：

-  有名字（Name）
-  具有可编辑的属性（Editable Properties）。
-  每帧（Frame）都能接收对进程的回调（Callback）。
-  能够被扩展（Extended）（来具有更多的功能（Functions））。
-  能够加入其他的节点作为子（Child）。

.. image:: /img/tree.png

最后一个很重要。节点能够使其他节点作为子类。当以这种方式编排的时候，节点会变成一个“树”。

在Godot中，以这种方式来编排节点的能力为组织整理工程创造了一个强有力的工具。因为不同的节点有不同的功能，将他们结合起来则允许了创建更多复杂的功能。

这可能还不甚清晰并且几乎没什么意义。但是过了几节后一切都将大白。目前要记住最重要的一点是有节点这个东西存在，并且能够按这种方式来编排。

场景（Scene）
------

.. image:: /img/scene_tree_example.png

既然节点的存在已经被定义了，下一个逻辑步骤就是解释什么是场景了。

一个场景由一组（以树形图的方式）被分层组织的节点组成，它具有以下属性：

-  一个场景有且只能有一个根节点（Root Node）。
-  场景能够被保存到磁盘上，也能被载入回来。
-  场景能够被“实例化”（Instanced）（后文说明原因）。
-  运行一个游戏意味着运行一个场景。
-  一个工程中可以有几个场景，但是要开始，它们中的一个必须被选定来首先载入。

基本上，Godot编辑器就是一个“场景编辑器”（Scene Editor）。它有很多工具来编辑2D和3D场景以及用户界面（UI，User Interface），但是编辑器的所有内容都是围绕着编辑构成它的场景和节点的概念展开的。

创建一个新工程（Project）
----------------------

理论是枯燥的，所以我们来转换话题走向实际。按照教程类文章的长期传统，第一个工程将会是一个Hello World。为了这件事，编辑器将会被使用。

当Godot可执行程序脱离一个工程运行，工程管理器（Project Manager）就出现了，它帮助开发者管理他们的工程。

.. image:: /img/project_manager.png

要创建一个新工程，“新建工程”（New Project）选项肯定被使用。给选择并创建一个路径（Path）然后指定工程的名字（Name）：

.. image:: /img/create_new_project.png

编辑器（Editor）
------

一旦这个“新工程”被创建，下一步就是打开它。这将会打开Godot编辑器。下图展示了刚打开编辑器时它的样子：

.. image:: /img/empty_editor.png

如前文所述，在Godot中制作游戏就像是在厨房里一样，所以我们来打开冰箱然后加入一些新鲜的节点到工程中。我们将会以一个Hello World!开始。为了做到这一点，肯定要按下“新建节点”（New Node）按钮：

.. image:: /img/newnode_button.png

This will open the Create Node dialog, showing the long list of nodes
that can be created:

.. image:: /img/node_classes.png

From there, select the "Label" node first. Searching for it is probably
the quickest way:

.. image:: /img/node_search_label.png

And finally, create the Label! A lot happens when Create is pressed:

.. image:: /img/editor_with_label.png

First of all, the scene is changed to the 2D editor (because Label is
a 2D Node type), and the Label appears, selected, at the top left
corner of the viewport.

The node appears in the scene tree editor (box in the top left
corner), and the label properties appear in the Inspector (box on the
right side).

The next step will be to change the "Text" Property of the label, let's
change it to "Hello, World!":

.. image:: /img/hw.png

Ok, everything's ready to run the scene! Press the PLAY SCENE Button on
the top bar (or hit F6):

.. image:: /img/playscene.png

Aaaand... Oops.

.. image:: /img/neversaved.png

Scenes need to be saved to be run, so save the scene to something like
hello.scn in Scene -> Save:

.. image:: /img/save_scene.png

And here's when something funny happens. The file dialog is a special
file dialog, and only allows to save inside the project. The project
root is "res://" which means "resource path. This means that files can
only be saved inside the project. For the future, when doing file
operations in Godot, remember that "res://" is the resource path, and no
matter the platform or install location, it is the way to locate where
resource files are from inside the game.

After saving the scene and pressing run scene again, the "Hello, World!"
demo should finally execute:

.. image:: /img/helloworld.png

Success!

.. _doc_scenes_and_nodes-configuring_the_project:

Configuring the project
-----------------------

Ok, It's time to do some configuration to the project. Right now, the
only way to run something is to execute the current scene. Projects,
however, have several scenes so one of them must be set as the main
scene. This scene is the one that will be loaded at the time the project
is run.

These settings are all stored in the engine.cfg file, which is a
plaintext file in win.ini format, for easy editing. There are dozens of
settings that can be set in that file to alter how a project executes,
so to make matters simpler, a project setting dialog exists, which is
sort of a frontend to editing engine.cfg

To access that dialog, simply go to Scene -> Project Settings.

Once the window opens, the task will be to select a main scene. This can
be done easily by changing the application/main_scene property and
selecting 'hello.scn'.

.. image:: /img/main_scene.png

With this change, pressing the regular Play button (or F5) will run the
project, no matter which scene is being edited.

Going back to the project settings dialog. This dialog provides a lot
of options that can be added to engine.cfg and show their default
values. If the default value is ok, then there isn't any need to
change it.

When a value is changed, a tick is marked to the left of the name.
This means that the property will be saved to the engine.cfg file and
remembered.

As a side note, for future reference and a little out of context (this
is the first tutorial after all!), it is also possible to add custom
configuration options and read them in run-time using the
:ref:`Globals <class_Globals>` singleton.

To be continued...
------------------

This tutorial talks about "scenes and nodes", but so far there has been
only *one* scene and *one* node! Don't worry, the next tutorial will
deal with that...
