.. _doc_viewports:

视窗（Viewports）
=========

简介
------------

Godot有一个小巧却非常有用的特点，称为视窗（viewport）。顾名思义，视窗就是用来描绘游戏世界的一个长方形区域。
视窗有三个主要的应用，不过也可以很灵活的应用到更多方面。
所有的应用都是通过视窗节点（ :ref:`Viewport <class_Viewport>` ）实现的。


.. image:: /img/viewportnode.png

上面提到的三个主要应用如下：

-  **场景根节点（Scence Root）**: 当前活跃场景的根总是一个视窗。
   这个视窗负责展示用户所创建的场景。（看了前面的教程你应该已经知道这个了！）
-  **子视窗（Sub-viewport）**: 当视窗是控制节点（:ref:`Control <class_Control>`）的子节点时，
   可以创建子视窗。
-  **渲染目标（Render Targets）**: 视窗可以设定为“渲染目标（RenderTarget）”模式。
   这表示视窗不能直接被看到，但是它的内容可以通过材质（:ref:`Texture <class_Texture>`）来获取。

输入（Input）
-----

视窗还可以用来将调整、缩放过的输入事件传递给它的子节点。根视窗
和子视窗会自动执行这种传达，但是渲染目标模式下的视窗不会自动执行。
因此，如果需要渲染目标模式的视窗也执行这种传递，用户必须手动调用
:ref:`Viewport.input() <class_Viewport_input>` 函数来达到目的。

收听站（Listener）
--------

Godot支持3D声音（2D节点和3D节点都支持），关于这一点将在另外一篇教程中
详细讨论（不知道哪天……）。为了让这类声音能够被人听到，视窗需要启用
收听站（可以支持2D和3D）。如果你使用自定义的视窗来展示你的世界，别忘了
启用收听站哦！
译者注：注意此处listener并非指监听器

摄像机(2D & 3D)
-----------------

当使用2D或者3D的摄像机节点（:ref:`Camera <class_Camera>` /
:ref:`Camera2D <class_Camera2D>`）时，该摄像机节点总是会
显示在最近的父视窗节点上（向根节点方向的最近）。例如，在下面的
这种结构中：

-  视窗（Viewport）

   -  摄像机（Camera）

上面这个摄像机节点会显示在它的父视窗节点上，但是看下面这个例子：

-  摄像机（Camera）

   -  视窗（Viewport）

这里的摄像机节点就不会显示在例子中的视窗节点上（如果这是一个子场景的话，
可能它会显示在根视窗节点上）

每个视窗都只能有一个活跃中的摄像机节点，所以如果你的视窗有多于一个摄像机
节点，请确保你想用的那个摄像机节点被设置了“当前（current）”属性。
或者，你也可以通过如下函数来设定当前摄像机：

::

    camera.make_current()

缩放和拉伸（Scale & stretching）
------------------

视窗具有矩形这个属性。Viewports have a "rect" property. X and Y are often not used (only the
root viewport really uses them), while WIDTH AND HEIGHT represent the
size of the viewport in pixels. For Sub-Viewports, these values are
overridden by the ones from the parent control, but for render targets
this sets their resolution.

It is also possible to scale the 2D content and make it believe the
viewport resolution is other than the one specified in the rect, by
calling:

::

    viewport.set_size_override(w,h) #custom size for 2D
    viewport.set_size_override_stretch(true/false) #enable stretch for custom size

The root viewport uses this for the stretch options in the project
settings.

世界（Worlds）
------

For 3D, a Viewport will contain a :ref:`World <class_World>`. This
is basically the universe that links physics and rendering together.
Spatial-base nodes will register using the World of the closest
viewport. By default, newly created viewports do not contain a World but
use the same as a parent viewport (root viewport does contain one
though, which is the one objects are rendered to by default). A world can
be set in a viewport using the "world" property, and that will separate
all children nodes of that viewport from interacting with the parent
viewport world. This is specially useful in scenarios where, for
example, you might want to show a separate character in 3D imposed over
the game (like in Starcraft).

As a helper for situations where you want to create viewports that
display single objects and don't want to create a world, viewport has
the option to use it's own World. This is very useful when you want to
instance 3D characters or objects in the 2D world.

For 2D, each Viewport always contains it's own :ref:`World2D <class_World2D>`.
This suffices in most cases, but in case sharing them may be desired, it
is possible to do so by calling the viewport API manually.

捕捉（Capture）
-------

It is possible to query a capture of the viewport contents. For the root
viewport this is effectively a screen capture. This is done with the
following API:

::

    # queues a screen capture, will not happen immediately
    viewport.queue_screen_capture() 

After a frame or two (check _process()), the capture will be ready,
get it back by using:

::

    var capture = viewport.get_screen_capture()

If the returned image is empty, capture still didn't happen, wait a
little more, as this API is asyncronous.

子视窗（Sub-viewport）
------------

If the viewport is a child of a control, it will become active and
display anything it has inside. The layout is something like this:

-  Control

   -  Viewport

The viewport will cover the area of it's parent control completely.

.. image:: /img/subviewport.png

渲染目标（Render target）
-------------

To set as a render target, just toggle the "render target" property of
the viewport to enabled. Note that whatever is inside will not be
visible in the scene editor. To display the contents, the render target
texture must be used. This can be requested via code using (for
example):

::

    var rtt = viewport.get_render_target_texture() 
    sprite.set_texture(rtt)

By default, re-rendering of the render target happens when the render
target texture has been drawn in a frame. If visible, it will be
rendered, otherwise it will not. This behavior can be changed to manual
rendering (once), or always render, no matter if visible or not.

A few classes are created to make this easier in most common cases
inside the editor:

-  :ref:`ViewportSprite <class_ViewportSprite>` (for 2D).
-  ViewportQuad (for 3D).
-  ViewportFrame (for GUI).

*TODO: Review the doc, ViewportQuad and ViewportFrame don't exist in 2.0.*

Make sure to check the viewport demos! Viewport folder in the demos
archive available to download, or
https://github.com/godotengine/godot/tree/master/demos/viewport
