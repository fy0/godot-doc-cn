.. _doc_inputevent:

输入事件（InputEvent）
==========

输入事件是什么？（What is it?）
-----------

不论是什么操作系统、什么平台，管理输入通常都会比较复杂。为了让事情简单一点，Godot提供了一个特殊的内建类：输入事件（:ref:`InputEvent <class_InputEvent>`）。这个数据类型可以被设置为包含几种不同的输入事件。基于包含多种输入的特点，输入事件会在引擎内部传递，可以在很多位置获得。

输入事件如何工作？（How does it work?）
-----------------

每一个输入事件都是由用户/玩家发出的（不过你也可以直接生成一个输入事件，然后把它传递给引擎，在处理姿势信息时这种做法很有用）。各个平台的系统对象会从输入设备那里读取输入事件，然后把他们传递给主循环（MainLoop）。因为场景树（:ref:`SceneTree <class_SceneTree>`）是默认的主循环执行器，所以输入事件就传递给场景树了。Godot提供了一个方法来获取当前的场景树对象：**get_tree()**。

但是场景树并不知道该如何响应输入事件，所以它会把输入事件传递给视窗，从根视窗（:ref:`Viewport <class_Viewport>`）开始一直往下传（根视窗就是场景树的第一个节点）。针对收到的输入事件，视窗会做一系列的工作，顺序如下：

.. image:: /img/input_event_flow.png

1. 首先，它会尝试将输入事件传递给GUI，看看有没有哪个控制节点能响应它。如果有，通过调用方法:ref:`Control._input_event() <class_Control__input_event>`，响应的控制节点（:ref:`Control <class_Control>`）会被使用，同时“输入事件”的信号会被发送出去（这个方法在被继承后，可以通过脚本反复执行）。如果响应的控制节点想要“消耗”掉这个输入事件，它可以调用方法:ref:`Control.accept_event() <class_Control_accept_event>`，这样输入事件就不会继续传递了。

2. 如果GUI中没有能响应这个事件的节点，那么所有“输入处理”设置为开（通过:ref:`Node.set_process_input() <class_Node_set_process_input>`来设置为开，使用方法:ref:`Node._input() <class_Node__input>`会自动设置为开）的节点，都会调用标准输入（standard _input）方法。此时，如果有方法可以消耗这个输入事件，它就会调用:ref:`SceneTree.set_input_as_handled() <class_SceneTree_set_input_as_handled>`，然后，输入事件就不会继续传递了。

3. 如果到了这里，还是没有节点消耗这个输入事件，未处理输入回调会被调用（通过:ref:`Node.set_process_unhandled_input() <class_Node_set_process_unhandled_input>`开启，使用:ref:`Node._unhandled_input() <class_Node__unhandled_input>`会自动开启）。如果有哪个方法消耗掉了这个事件，它会调用:ref:`SceneTree.set_input_as_handled() <class_SceneTree_set_input_as_handled>`，然后，输入事件就不会继续传递了。

4. 如果还是没有节点消耗这个输入事件，那么一个摄像机（:ref:`Camera <class_Camera>`）会被指定到对应的视窗上；同时，会生成一条射线，指向项目的物理世界（从点击处指向世界）。如果这条射线碰撞到了某个对象，它会针对碰撞到的物理对象调用:ref:`CollisionObject._input_event() <class_CollisionObject__input_event>`方法。（默认地，物体（body）会收到这个回调，但是区域（area）收不到；可以通过调整区域节点（:`Area <class_Area>`）的属性，来设置为可以收到回调）

5. 最终，如果这个输入事件还是未处理，它会被传递给场景树中的下一个视窗；如果没有下一个视窗了，它会被直接无视掉。 

输入事件剖析（Anatomy of an InputEvent）
------------------------

输入事件（:ref:`InputEvent <class_InputEvent>`）只是一个基础的内建类，它只包含一些基本的信息，比如说事件ID（event ID，会随着事件数增加），设备号（device index），等等。

输入事件具有“类型（type）”成员。通过指定它的值，输入事件可以代表不同类型的输入。根据角色不同，每种输入事件都有不同的属性。

一个设定事件类型的例子：（译注：例子中新建了一个输入事件，然后才设定为鼠标点击事件）

::

    # 创建输入事件
    var ev = InputEvent()
    # 设定输入事件的类型（鼠标点击）
    ev.type = InputEvent.MOUSE_BUTTON
    # button_index是鼠标点击类型输入事件唯一能够设定的值
    ev.button_index = BUTTON_LEFT

下面的表格中，是一些输入事件的类型：

+-------------------------------------------------------------------+--------------------+-----------------------------------------+
| 事件（Event）                                                     | 类型表示（Index）  | 描述（Description）                     |
+-------------------------------------------------------------------+--------------------+-----------------------------------------+
| :ref:`InputEvent <class_InputEvent>`                              | NONE               | 空白输入事件                            |
+-------------------------------------------------------------------+--------------------+-----------------------------------------+
| :ref:`InputEventKey <class_InputEventKey>`                        | KEY                | 包含键盘扫描码和Unicode编码，           |
|             														|					 | 及修饰键情况                            |
+-------------------------------------------------------------------+--------------------+-----------------------------------------+
| :ref:`InputEventMouseButton <class_InputEventMouseButton>`        | MOUSE_BUTTON       | 包含鼠标点击信息，比如按键、修饰键情况等|
+-------------------------------------------------------------------+--------------------+-----------------------------------------+
| :ref:`InputEventMouseMotion <class_InputEventMouseMotion>`        | MOUSE_MOTION       | 包含鼠标移动信息，比如相对、绝对位置    |
|                                                                   |                    | 和速度                                  |
+-------------------------------------------------------------------+--------------------+-----------------------------------------+
| :ref:`InputEventJoystickMotion <class_InputEventJoystickMotion>`  | JOYSTICK_MOTION    | 包含摇杆、手柄的轴相关信息              |
+-------------------------------------------------------------------+--------------------+-----------------------------------------+
| :ref:`InputEventJoystickButton <class_InputEventJoystickButton>`  | JOYSTICK_BUTTON    | 包含摇杆、手柄的按键相关信息            |
+-------------------------------------------------------------------+--------------------+-----------------------------------------+
| :ref:`InputEventScreenTouch <class_InputEventScreenTouch>`        | SCREEN_TOUCH       | 包含多点触摸按下/抬起信息（只在移动设备 |
|                                                                   |                    | 上可用）                                |
+-------------------------------------------------------------------+--------------------+-----------------------------------------+
| :ref:`InputEventScreenDrag <class_InputEventScreenDrag>`          | SCREEN_DRAG        | 包含多点触控拖拽信息（只在移动设备上    | 
|                                                                   |                    | 可用）                                  |
+-------------------------------------------------------------------+--------------------+-----------------------------------------+
| :ref:`InputEventAction <class_InputEventAction>`                  | SCREEN_ACTION      | 包含一般动作。这类事件通常是由程序员设定|
|                                                                   |                    | 作为反馈使用的。（详细内容请看下一段）  |
+-------------------------------------------------------------------+--------------------+-----------------------------------------+

动作（Actions）
-------

一个输入事件可能代表（也可能不代表）一种事先设定好的动作。在编写游戏逻辑时，动作是个很有用的概念，因为它们抽象地代表了不同的输入设备。这就带来以下好处：

-  同样的代码可以支持不同设备的不同输入装置。（比如，电脑的键盘，主机上的手柄）

-  在运行中，可以重新设置输入方式。

动作可以在 ``项目设置(Project Settings)`` 的 ``动作(Actions)`` 标签页创建。可以看一下:ref:`doc_simple_2d_game-input_actions_setup`，这篇文档具体讲解了如何使用动作编辑器。

所有输入事件都有:ref:`InputEvent.is_action() <class_InputEvent_is_action>`,
:ref:`InputEvent.is_pressed() <class_InputEvent_is_pressed>`和:ref:`InputEvent <class_InputEvent>`，这三个方法。

另外，你可能会需要从代码中产生动作（一个例子就是检测姿势）。场景树（从主循环中产生的）为此提供了一个方法：:ref:`MainLoop.input_event() <class_MainLoop_input_event>`。你可以这样使用这个方法：

::

    var ev = InputEvent()
    ev.type = InputEvent.ACTION
    # 把输入事件设定为动作，名为move_left，按下状态
    ev.set_as_action("move_left", true) 
    # 反馈
    get_tree().input_event(ev)

输入映射（InputMap）
--------

我们经常需要从代码层面，自定义、重新设置输入的方法。如果你的整个工作流都是基于动作的，那么输入映射（:ref:`InputMap <class_InputMap>`）单例就是最理想的，在运行中重设、新建动作的方式了。这个单例是不会被保存的（必须通过手动更改才能保存），它直接由项目设置来运行（engine.cfg）。这样一来，该类型的所有动态设置，都可以以程序员认为最优的方式来存储。