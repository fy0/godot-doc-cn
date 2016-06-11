.. _doc_mouse_and_input_coordinates:

鼠标和输入坐标（Mouse and input coordinates）
===========================

关于（About）
-----

这篇短小的教程，主要是为了指出、阐明一些常见的错误，这类错误往往与输入坐标、获取鼠标位置、屏幕分辨率相关。

硬件显示坐标系（Hardware display coordinates）
----------------------------

在绘制复杂的、运行在电脑上的UI时，使用硬件坐标系往往是个明智的选择，比如说在绘制编辑器、MMO游戏、工具类软件的UI时。不过，如果你不是要做上述这类东西，那么使用硬件坐标系就不是个好主意了。

视窗显示坐标系（Viewport display coordinates）
----------------------------

Godot使用视窗来显示内容，视窗可以通过一些选项来进行缩放（参见 :ref:`doc_multiple_resolutions` 教程）。那么，我们也可以使用针对节点的方法，来获得鼠标的坐标和视窗大小，例如：

::

    func _input(ev):
       # 在视窗坐标系下鼠标的位置

       if (ev.type==InputEvent.MOUSE_BUTTON):
           print("Mouse Click/Unclick at: ",ev.pos)
       elif (ev.type==InputEvent.MOUSE_MOTION):
           print("Mouse Motion at: ",ev.pos)

       # 输出视窗的尺寸

       print("Viewport Resolution is: ",get_viewport_rect().size)

    func _ready():
        set_process_input(true)

另外，也可以直接向视窗请求鼠标的位置，如下：

::

    get_viewport().get_mouse_pos()
