.. _doc_resources:

资源（Resource）
=========

节点和资源
-------------------

到目前为止， :ref:`Nodes <class_Node>`
已经成为了Godot中最重要的数据类型（Datatype），因为引擎的绝大多数行为和特性都是通过他们实现的。尽管如此，还有另外一种数据类型也是同样地重要，那就是
:ref:`Resource <class_Resource>`.

*节点*关注在行为上，比如绘制一个精灵、绘制一个3D模型、物理、GUI控制等，

**资源** 仅仅是 **数据容器（Data Container）**，这意味着他们既没有任何动作也不生成任何信息。资源仅仅包含着数据而已。

资源的样本有：
:ref:`Texture <class_Texture>`,
:ref:`Script <class_Script>`,
:ref:`Mesh <class_Mesh>`,
:ref:`Animation <class_Animation>`,
:ref:`Sample <class_Sample>`,
:ref:`AudioStream <class_AudioStream>`,
:ref:`Font <class_Font>`,
:ref:`Translation <class_Translation>`,
etc.

当Godot保存或载入（从硬盘）一个场景（.scn或者.xml）、一个图片（png，jpg
）、一个脚本（.gd）或者很多的东西，那个文件就被称为一个资源。

当一个资源被从磁盘里载入时，**它总是只被载入一次**。那也就意味着，如果在内存中已经有一份该资源被载入了，尝试一次又一次载入该资源将只返回相同的那份资源。这与资源只是数据容器这一事实相对应，因此没必要去让他们被复制。

通常地，Godot中每一个对象（节点、资源或者别的东西）都能够导出属性（Properties），属性可以是许多种类型（例如一个字符串（String）、整数（Integers）、2D向量（Vector2）等）并且这些类型中每一个都能成为一个资源。这意味着节点和资源都可以包含资源作为属性。
为了使它更加的直观一点：

.. image:: /img/nodes_resources.png

外部与内置
--------------------

资源属性可以以两种方式引用资源，*外部*（磁盘）或**内置**。

为了更具体一些，在一个 :ref:`Sprite <class_Sprite>` 节点中有一个 :ref:`Texture <class_Texture>`：

.. image:: /img/spriteprop.png

按下预览右侧的">"按钮将允许查看并编辑资源属性。其中有一个属性（path）显示了它来自于哪里。在这个案例中，它来自于一个png图片。

.. image:: /img/resourcerobi.png

当资源来自于一个文件时，它被认为是一个*外部*的资源。如果这个路径（path）属性被擦除了（或者开始就没有一个路径），那么他就被认为是一个内置的资源。

比如说，如果路径\`"res://robi.png"\`从上述范例中"path"属性被抹消，那么接下来这个场景被保存，资源就会被存到.scn场景文件里，不再引用外部的"robi.png"。然而，即使被存为内置资源，尽管这个场景可以被实例化多次，资源将仍然只载入一次。那意味着，同时被实例化的不同的Robi机器人场景将分享相同的图片。

利用代码载入资源
---------------------------

Loading resources from code is easy, there are two ways to do it. The
first is to use load(), like this:

::

    func _ready():
            var res = load("res://robi.png") # resource is loaded when line is executed
            get_node("sprite").set_texture(res)

The second way is more optimal, but only works with a string constant
parameter, because it loads the resource at compile-time.

::

    func _ready():
            var res = preload("res://robi.png") # resource is loaded at compile time
            get_node("sprite").set_texture(res)

Loading scenes
--------------

Scenes are also resources, but there is a catch. Scenes saved to disk
are resources of type :ref:`PackedScene <class_PackedScene>`,
this means that the scene is packed inside a resource.

To obtain an instance of the scene, the method
:ref:`PackedScene.instance() <class_PackedScene_instance>`
must be used.

::

    func _on_shoot():
            var bullet = preload("res://bullet.scn").instance()
            add_child(bullet)                  

This method creates the nodes in hierarchy, configures them (sets all
the properties) and returns the root node of the scene, which can be
added to any other node.

The approach has several advantages. As the
:ref:`PackedScene.instance() <class_PackedScene_instance>`
function is pretty fast, adding extra content to the scene can be done
efficiently. New enemies, bullets, effects, etc can be added or
removed quickly, without having to load them again from disk each
time. It is important to remember that, as always, images, meshes, etc
are all shared between the scene instances.

Freeing resources
-----------------

Resource extends from :ref:`Reference <class_Reference>`.
As such, when a resource is no longer in use, it will automatically free
itelf. Since, in most cases, Resources are contained in Nodes, scripts
or other resources, when a node is removed or freed, all the children
resources are freed too.

Scripting
---------

Like any object in Godot, not just nodes, resources can be scripted too.
However, there isn't generally much of a win, as resources are just data
containers.
