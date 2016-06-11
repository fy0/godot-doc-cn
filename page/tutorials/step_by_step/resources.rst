.. _doc_resources:

资源（Resource）
=========

节点和资源
-------------------

到目前为止， :ref:`Nodes <class_Node>`
已经成为了Godot中最重要的数据类型（Datatype），因为引擎的绝大多数行为和特性都是通过他们实现的。尽管如此，还有另外一种数据类型也是同样地重要，那就是
:ref:`Resource <class_Resource>`.

节点关注在行为上，比如绘制一个精灵、绘制一个3D模型、物理、GUI控制等，

**资源** 仅仅是 **数据容器(Data Container)**，这意味着他们既没有任何动作也不生成任何信息。资源仅仅包含着数据而已。

资源的样本有：
:ref:`Texture <class_Texture>`,
:ref:`Script <class_Script>`,
:ref:`Mesh <class_Mesh>`,
:ref:`Animation <class_Animation>`,
:ref:`Sample <class_Sample>`,
:ref:`AudioStream <class_AudioStream>`,
:ref:`Font <class_Font>`,
:ref:`Translation <class_Translation>`,
等等。

当Godot（从硬盘）保存或载入一个场景（.scn或者.xml）、一个图片（png，jpg
）、一个脚本（.gd）或者其他什么类似的东西，那个文件就被称为一个资源。

当一个资源被从磁盘里载入时，**它永远只被载入一次**。那也就意味着，如果在内存中已经有一份该资源被载入了，尝试再次载入该资源将只返回相同的那份资源。这与资源只是数据容器这一事实相对应，因此没必要去让他们存在多个副本。

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

比如说，如果路径\`"res://robi.png"\`从上述范例中"path"属性被抹消，那么接下来当这个场景被保存，资源就会被存到.scn场景文件里，不再引用外部的"robi.png"。然而，即使被存为内置资源，尽管这个场景可以被实例化多次，资源将仍然只载入一次。那意味着，同时被实例化的不同的Robi机器人场景将分享相同的图片。

使用代码载入资源
---------------------------

使用代码载入资源非常简单，有两种方式都能够完成此事。第一种是使用 load() 函数，就像这样：

::

    func _ready():
            var res = load("res://robi.png") # resource is loaded when line is executed
            get_node("sprite").set_texture(res)

第二种方式要更理想，但是参数必须是一个字符串常量才能工作，因为它将在编译时载入资源。

::

    func _ready():
            var res = preload("res://robi.png") # resource is loaded at compile time
            get_node("sprite").set_texture(res)

加载场景
--------------

场景同样也是资源，但有点特别。场景会以 :ref:`PackedScene <class_PackedScene>` 这种资源类型保存到硬盘。这意味着场景会被打包进一份资源之内。

如果想要获得场景的实例(instance)，必须使用这个方法：:ref:`PackedScene.instance() <class_PackedScene_instance>`

::

    func _on_shoot():
            var bullet = preload("res://bullet.scn").instance()
            add_child(bullet)                  

这个方法能创建场景树每一层的节点，初始化它们(包括设定所有属性)同时返回
场景的根节点。根节点能被添加为其他任意节点的子节点。

下面这个方法有若干优点：:ref:`PackedScene.instance() <class_PackedScene_instance>` 函数执行地非常快，能够高效的往场景里添加额外内容(extra content)。新的敌人、子弹、特效等等能够被快速添加或移除，而不需要每次都从硬盘上读取。记住这点，这非常重要：同样的，图片、网格(meshes)以及其他全部都是在场景实例间共享的。


释放资源
-----------------

资源类(Resource)都继承自 :ref:`Reference <class_Reference>` 。因此，当一个资源不再使用的时候，他将自动被释放。因为在大多数情况下资源被包含在节点、脚本或者其他资源中，当一个节点被移除或者释放时，作为其子节点的资源也跟着被释放了。

脚本
---------

如同 Godot 中的其他对象（而不仅仅是Nodes）一般，资源也是可以附加脚本的。
但这通常没什么卵用，因为资源只是数据容器罢了。
        
