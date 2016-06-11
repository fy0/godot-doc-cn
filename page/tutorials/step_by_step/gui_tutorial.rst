.. _doc_gui_tutorial:

GUI教程
============

介绍
~~~~~~~~~~~~

如果有一个东西让程序员又爱又恨，那就是编写图形用户界面(GUI，Graphical User Interface)。这很枯燥、乏味还没有挑战性。还有几个方面使得事情更糟，比如：

-  像素对齐的UI元素很困难(所以它看起来就像是设计师的所拟定的)。
-  UI会因为测试期间出现的设计和实用性的问题上一直在变。
-  要为不同的显示分辨率处理适当的屏幕缩放。
-  为一些屏幕组件制作动画，来让它看起来不是那样的呆板。

GUI编写是让程序员筋疲力尽的主要原因之一。在Godot(和前代引擎)的开发期间很多为UI开发打造的技巧和理论得以实现，比如速成模式(Immediate Mode)、容器(Container)、锚点(Anchor)、脚本等。以减轻不得不把用户界面整合到一起的程序员的压力为主要目标，这些应时刻被做到。

最终，Godot的最终UI分系统是一个解决这一问题的高效解决方案。，并且通过混合一些不同的方式来运作。虽然比别的工具套组的学习曲线更加的陡峭，但开发者能够在短时间内把复杂的用户界面编排到一起，通过和设计师和动画师共用同一套工具。

控件(Control)
~~~~~~~

(*译注：Control作为Godot节点和GDScript的基本类时不予翻译)
UI元素的基本节点是 :ref:`Control <class_Control>`
(有时候在其他工具套组中被称为“小部件”(Widget)或者“框”(Box))。每个提供用户界面功能的节点都是由他继承而来的。

当Control被放在场景树中作为其他Control的子，它的坐标(位置、大小)都是相对于父级的。这为快速地可视地编辑复杂用户界面打下基础。

输入和绘制
~~~~~~~~~~~~~~~~~

控件以
:ref:`Control._input_event() <class_Control__input_event>` 回调
接收一个输入事件。只有一个控件，在焦点中的那个，将会接收键盘/手柄事件。(见：:ref:`Control.set_focus_mode() <class_Control_set_focus_mode>`
和 :ref:`Control.grab_focus() <class_Control_grab_focus>`)。

鼠标活动事件被在鼠标指针下方的控件直接接收。当一个控件接收到一个鼠标按钮按下事件时，所有接下来的活动事件都由被按下的控件接收直至按钮松开，即使是指针已经跑到控件边界以外了。

像所有继承了 :ref:`CanvasItem <class_CanvasItem>` (Control也继承)的类那样，一个 :ref:`CanvasItem._draw() <class_CanvasItem__draw>`
回调将会在最开始和每次控件需要重绘(Redraw)的时候被接收(程序员需要调用
:ref:`CanvasItem.update() <class_CanvasItem_update>`
来入队(enqueue)供重绘的控件)。如果控件是不可见的(CanvasItem的另一种属性)，那么这个控件不接受任何的输入。

但总体上，程序员在搭建UI时不需要直接处理绘制和输入事件，(那对于创建自定义控件时更有用)。取而代之地，控件发射各种带有对于事件何时发生的构造信息的信号(Signals)。比如说一个按钮( :ref:`Button <class_Button>` )在被按下时发射了一个"pressed"信号，一个滚动条( :ref:`Slider <class_Slider>` )将会在被拖动时发射"value_changed"信号等。

自定义控件小教程
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

在深入之前，创建一个自定义控件将会是一个好的方式来掌握控件工作的基本图样，因为它们也许不像看起来那样复杂。

此外，尽管Godot有很多用于不同目的的控件，但通常都是通过创建一个新的会更容易获取到特定的功能。

首先，创建一个单节点场景。节点类型为Control，并且在2D编辑器屏幕中有某一个区域，像这样：

.. image:: /img/singlecontrol.png

为那个节点添加一个脚本，写下如下代码：

::

    extends Control

    var tapped=false

    func _draw():

        var r = Rect2( Vector2(), get_size() )
        if (tapped):
            draw_rect(r, Color(1,0,0) )
        else:
            draw_rect(r, Color(0,0,1) )

    func _input_event(ev):

        if (ev.type==InputEvent.MOUSE_BUTTON and ev.pressed):
            tapped=true
            update()

然后运行场景。当矩形被点击/触击时，它将从蓝色变为红色。这种在事件和绘制之间的配合更多的是大多数控件之间如何工作。

.. image:: /img/ctrl_normal.png

.. image:: /img/ctrl_tapped.png

UI复杂度
~~~~~~~~~~~~~

正如前文所述，Godot准备了一系列控件用于一个用户界面中。这些控件被分为两类。一个是一小部分对于创建大多数游戏用户界面都能良好运作的控件。另一种(绝大多数控件属于这个类型)是打算用于复杂的用户界面和一致包装的风格。下文所呈现的描述帮助理解了哪一个应当在什么场合下使用。

简化的UI控件
~~~~~~~~~~~~~~~~~~~~~~

这组控件对于大多数游戏是足够的，其中复杂的互动或者呈现信息的方式并不是必要的。它们能够被常规的贴图轻而易举的包装起来。

-  标签( :ref:`Label <class_Label>`)：用于显示文本。
-  贴图框( :ref:`TextureFrame <class_TextureFrame>`)：显示单张贴图，既可以拉伸也可以保持固定。
-  贴图按钮( :ref:`TextureButton <class_TextureButton>`)：显示一个简单的带有贴图的按钮，可以设置的状态有按下(Pressed)、悬停(Hover)和禁用(Disabled)等。
-  贴图进度条( :ref:`TextureProgress <class_TextureProgress>`)：显示一个简单的带有贴图的进度条。

此外，在这种情况下重新放置控件的位置利用锚点可以更高效地完成。(详情见教程 :ref:`doc_size_and_anchors` )。

在任何情况下，通常会有即使是对于简单的游戏，也需要更复杂的UI行为。其中一个范例就是一个滚动的元素列表(比如对于一个高分列表)，这可能需要一个滚动容器( :ref:`ScrollContainer <class_ScrollContainer>`)和一个纵向容器框( :ref:`VBoxContainer <class_VBoxContainer>`)。这种更为高级的控件可以和常规的控件天衣无缝地结合在一起(不管怎么说他们都是控件)。

复杂的UI控件
~~~~~~~~~~~~~~~~~~~

其余的控件(有一大堆呢！)是为另一系列场合准备的，最通常地：

-  需要复杂UI的游戏，比如PC RPG(Role Playing Game角色扮演)游戏、MMO(Massively Multiplayer Online，大型多人在线)游戏、策略类游戏、模拟类游戏等。
-  创建自定义的开发工具可以加速内容创作。
-  创建Godot编辑器插件(Editor Plugins)来扩展引擎的功能。

为这些类型的界面重新布置控件通常由容器完成(详情见教程 :ref:`doc_size_and_anchors`)。
