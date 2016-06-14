.. _doc_viewport_and_canvas_transforms:

视窗与画布变换(Viewport and canvas transforms)
==============================

介绍
------------

这篇教程创建于一个对于大多数用户来说都比较晦涩难懂的主题之后，并解释了所有节点上的2D变换发生时，在绘制场景时同时其绘制自身。

画布变换(Canvas transform)
----------------

上个教程提到，:ref:`doc_canvas_layers`，每个CanvasItem节点（记住，所有继承自Node2D和Control的节点都以CanvasItem作为其根节点）都属于 *Canvas Layer*。每个canvas layer都有一个变换属性（平移，旋转，缩放等），可以通过 :ref:`Matrix32 <class_Matrix32>` 访问。

我们知道，默认情况下，节点被绘制在 layer0，可以使用:ref:`CanvasLayer
<class_CanvasLayer>`来将节点绘制在不同的层。

全局画布变换(Global canvas transform)
-----------------------

视窗拥有一个全局画布变换的属性，这是一个:ref:`Matrix32 <class_Matrix32>`。
此属性最主要且影响其他所有 *Canvas Layer*。我们一般不会用到这个属性，但在Godot编辑器中被用作编辑 Canvas Item。

拉伸(Stretch transform)
-----------------

视窗有一个 *Stretch Transform* 属性，用于屏幕大小变化时。这个属性一般由系统内部调用（详见：:ref:`doc_multiple_resolutions`），但也可以手动设置。

:ref:`MainLoop._input_event() <class_MainLoop__input_event>`回调发出的Input事件同样受该属性影响。要将事件坐标转化为CanvasItem的坐标，使用:ref:`CanvasItem.make_input_local() <class_CanvasItem_make_input_local>`。

变换顺序(Transform order)
---------------

要将 CanvasItem 的本地坐标转换为屏幕坐标， 需要经过以下流程：

.. image:: /img/viewport_transforms2.png

变换方法(Transform functions)
-------------------
可以通过以下方法来获取每个变换：

+----------------------------------+--------------------------------------------------------------------------------------+
| Type                             | Transform                                                                            |
+==================================+======================================================================================+
| CanvasItem                       | :ref:`CanvasItem.get_global_transform() <class_CanvasItem_get_global_transform>`     |
+----------------------------------+--------------------------------------------------------------------------------------+
| CanvasLayer                      | :ref:`CanvasItem.get_canvas_transform() <class_CanvasItem_get_canvas_transform>`     |
+----------------------------------+--------------------------------------------------------------------------------------+
| CanvasLayer+GlobalCanvas+Stretch | :ref:`CanvasItem.get_viewport_transform() <class_CanvasItem_get_viewport_transform>` |
+----------------------------------+--------------------------------------------------------------------------------------+

然后，要将CanvasItem的本地坐标转化为屏幕坐标，只需按照下面的顺序相乘：

::

    var screen_coord = get_viewport_transform() + ( get_global_transform() + local_pos )

注意，一般不通过屏幕坐标来进行变换，我们建议使用画布的本地坐标(``CanvasItem.get_global_transform()``)来保证屏幕分辨率改变时正确工作。

触发自定义事件
---------------------------

如需要在场景中触发自定义事件，通过前面的教程，可以这样做：

::

    var local_pos = Vector2(10,20) # local to Control/Node2D
    var ie = InputEvent()
    ie.type = InputEvent.MOUSE_BUTTON
    ie.button_index = BUTTON_LEFT
    ie.pos = get_viewport_transform() + (get_global_transform() + local_pos)
    get_tree().input_event(ie)
