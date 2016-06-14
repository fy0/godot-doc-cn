.. _doc_custom_drawing_in_2d:

自定义2D绘图
====================

为什么?
----

Godot通过节点来绘制精灵(sprites)，多边形(polygons)，粒子(particles)和其他所有的类型。
大多数情况下这已经足够创作者的需求，但不是全部。如果有些需要的功能但godot又不支持的话，在你因为需要某些特殊的东西需要绘制但又无法实现而哭鼻子之前，你需要了解下通过自定义命令来绘制2d节点(:ref:`Control <class_Control>` or :ref:`Node2D <class_Node2D>`) 。而且，这*非常*容易实现。

但是...
------

手动绘制节点真得非常有用。看看下面的例子：
-  绘制形状或者某些特殊的节点（如：绘制圆，图片轨迹(image with trails)，带有动画的多边形等等）。
-  一些与节点不兼容的东西（如：俄罗斯方块）。它使用了自定义的方法来绘制方块。
-  管理大量（如：子弹）逻辑性但非常简单的东西。考虑到性能问题，最好不要用大量的节点来绘制这些东西。相反，绘制回调(draw calls)就显得非常高效。可以查看demo里面的"Shower of Bullets"。
-  创建自定义UI。godot提供了大量现成的控件，但也许你仍然需要绘制一个新的。

该怎么做?
--------
为任何派生自 :ref:`CanvasItem <class_CanvasItem>` 的节点添加脚本，如：:ref:`Control <class_Control>` 或
:ref:`Node2D <class_Node2D>`. 重写 _draw() 方法。

::

    extends Node2D

    func _draw():
        #your draw commands here
        pass

查看 :ref:`CanvasItem <class_CanvasItem>` 来了解都有哪些绘制命令(draw commands)，相信我，真的有很多。

更新(Updating)
--------

_draw() 方法只会被调用一次，然后绘制命令就被保存起来，因此不需要再次调用。

如果因为状态或其他什么改变导致节点确实需要重新绘制的时候，只需要简单的调用 :ref:`CanvasItem.update() <class_CanvasItem_update>`，之后一个新的 _draw() 将会被调用。

下面是一些更复杂的例子。节点将在 texture 属性改变时重新绘制：

::

    extends Node2D

    var texture setget _set_texture

    func _set_texture(value):
        #if the texture variable is modified externally,
        #this callback is called.
        texture=value #texture was changed
        update() #update the node

    func _draw():
        draw_texture(texture,Vector2())

在有些情况下，实现这样的效果可能需要每帧都进行绘制。但在这个例子中，只需要在 _process() 中调用 update() 方法，就像这样：

::

    extends Node2D

    func _draw():
        #your draw commands here
        pass

    func _process(delta):
        update()

    func _ready():
        set_process(true)

好了！这就是基本的用法！发挥想象，绘制你的专属节点吧！

工具
-----

在编辑器中，可能需要预览自定义绘制的行为功能。

记住，只在脚本顶部需要使用 "tool" 关键字，如果你忘记了怎么用，查看 :ref:`doc_gdscript`。
