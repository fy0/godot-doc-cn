.. _doc_canvas_layers:

画布层(Canvas layers)
=============

视窗与画布项(Viewport and Canvas items)
-------------------------
一般的2D节点, 如 :ref:`Node2D <class_Node2D>` 或
:ref:`Control <class_Control>` 都继承自
:ref:`CanvasItem <class_CanvasItem>`, 这是所有2D节点的基类。 
CanvasItem 按次序地放置在一个树形结构内，它们都会继承其坐标信息。这意味着，当父节点移动时，子节点也将移动。

这些节点可以直接或间接地放置于:ref:`Viewport <class_Viewport>`内, 并通过其显示出来。

视窗有一个 "canvas_transform" :ref:`Viewport.set_canvas_transform() <class_Viewport_set_canvas_transform>` 属性，
此属性允许通过自定义的 :ref:`Matrix32 <class_Matrix32>` 设置层级下所有 CanvasItem 的坐标信息。
节点，如:ref:`Camera2D <class_Camera2D>`通过改变这个坐标，同样有效。

设置画布坐标非常有用，因为这比移动节点更加高效。
画布坐标只是一个简单的保存了2D绘图偏移量的矩阵信息，因此这是滚动的最佳方式。


还不够...
-------------

但这还不够。在游戏或应用中经常有 不需要所有的东西都通过canvas_transform移动 的情况，如：


-  **视差滚动**: 背景比舞台上的其他东西移动地更慢。
-  **HUD**: 显示在角色上方的信息，或者GUI. 当游戏内容移动时，生命计数，分数等必须保持静止。
-  **过渡效果(Transitions)**: 过渡效果 (渐隐，混合等) 也许需要保持其位置不变。

在单个场景树中如何解决这些问题？

画布层(CanvasLayers)
------------

答案是 :ref:`CanvasLayer <class_CanvasLayer>`。
CanvasLayers为其所有的子节点添加了一个2D渲染层用以分割。默认情况下，视窗下的所有子节点都被绘制在 layer0 上，然而CanvasLayer可在所有标明的 layer 上绘制。
编号越大的层将绘制在越上面（这号理解）。CanvasLayers 同样有其自身的坐标系统，而且不依赖其他层的坐标，当游戏内容移动时，这个特性可以保持 UI 位置固定。

视差滚动就是一个经典例子。背景绘制在 layer-1，分数、生命和暂停按钮绘制在 layer1。 

下面的图显示了这个工作流程：

.. image:: /img/canvaslayers.png

对于树形结构，CanvasLayers 是独立的，不参与排序，它们只受 layer编号的影响。因此，在需要的时候，尽情实例化他们吧~~

性能
-----------
即使没有任何性能限制，我们也不建议使用过多的 layer 来绘制节点。最佳方式就是通树形结构排序来绘制节点。
2d节点同样可以通过 :ref:`Node2D.set_z() <class_Node2D_set_z> 来设置绘制顺序。
