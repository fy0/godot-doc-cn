.. _doc_simple_2d_game:

简单2D游戏
==============

Pong
~~~~

在这个简单的教程中，我们将创建一个基础的游戏Pong（对板弹球）。引擎一并包含了很多更加复杂的范例和演示，但是这个应该可以为一个人介绍2D游戏的基本设计目的。

资源
~~~~~~

这里包含了这个教程需要的资源：
:download:`pong_assets.zip </files/pong_assets.zip>`.

场景建立
~~~~~~~~~~~

由于过去时代的原因，游戏将以640×480的像素分辨率运行。这可以在工程设定（Project Setting）中配置（详情参见 :ref:`doc_scenes_and_nodes-configuring_the_project` ）。默认背景颜色应当被设置为黑色：

.. image:: /img/clearcolor.png

创建一个 :ref:`class_Node2D` 节点作为工程的根基。Node2D是2D引擎的基本类型。在此之后，添加一些精灵（Sprites， :ref:`class_Sprite`
节点）并且为每一个精灵设定对应的贴图（Textures）。最终场景布局应当看起来像下面那样（注意：小球在中央！）：

.. image:: /img/pong_layout.png

那么，场景树应当看起来像这样：

.. image:: /img/pong_nodes.png

保存场景为"pong.scn"然后在工程属性（Project Properties）中把它设置为主场景。

.. _doc_simple_2d_game-input_actions_setup:

输入动作建立
~~~~~~~~~~~~~~~~~~~

对于电子游戏会有很多的输入方法……键盘、手柄、鼠标、触控屏（多点触控）。好在这只是Pong。唯一重要的输入就是给板子上下移动的。

处理所有可能的输入方法会使非常令人恼火的并且还会需要大量代码。大多数游戏允许控制器自定义按键这一事实更是雪上加霜。对于这一点，Godot创建了“输入动作”（Input Actions）。一个动作被定义，那么触发它的输入方式就被添加。


再次打开工程属性对话框，但这次调到“输入映射”（Input Map）选项卡。

在这上面加入4个动作：
``left_move_up``, ``left_move_down``, ``right_move_up``, ``right_move_down``.
分配你想要的按键。A/Z（对于惯用左手的玩家）和上/下（对于惯用右手的玩家）作为在绝大多数情形中工作的键位。

.. image:: /img/inputmap.png

脚本
~~~~~~

为场景的根节点创建一个脚本然后打开它（正如在 :ref:`doc_scripting-adding_a_script`中解释得那样）。这个脚本将会继承Node2D类：

::

    extends Node2D

    func _ready():
        pass

在构造器（Constructor）中，必须完成两件事情。第一个就是去处理，然后第二个存储一些有用的值。这些值就是屏幕或者挡板的尺寸：

::


    extends Node2D

    var screen_size
    var pad_size

    func _ready():
        screen_size = get_viewport_rect().size
        pad_size = get_node("left").get_texture().get_size()
        set_process(true)

然后添加用于游戏内部处理的代码：

::

    #speed of the ball (in pixels/second)

    var ball_speed = 80
    #direction of the ball (normal vector)

    var direction = Vector2(-1, 0)
    #constant for pad speed (also in pixels/second)

    const PAD_SPEED = 150

最终，process函数：

::

    func _process(delta):

获得到有用的值用于计算。首先是球的位置（从代码），第二个就是每个挡板的矩形区域（“Rect2”）。默认地精灵居中于他们的贴图。所以加入一个小的调整“pad_size / 2”。

::

        var ball_pos = get_node("ball").get_pos()
        var left_rect = Rect2( get_node("left").get_pos() - pad_size/2, pad_size )
        var right_rect = Rect2( get_node("right").get_pos() - pad_size/2, pad_size )

由于球的位置已经获知，把它们累加起来应当不是问题：

::

        ball_pos += direction * ball_speed * delta

然后，既然球拥有了一个新的位置。它倚在所有东西上都应该被检测。先是底部和顶部：

::

        if ( (ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
            direction.y = -direction.y

如果一个挡板被触碰，改变方向然后轻微加速。

::

        if ( (left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
            direction.x = -direction.x
            ball_speed *= 1.1
            direction.y = randf() * 2.0 - 1
            direction = direction.normalized()

如果游戏飞出屏幕外部，游戏结束。游戏重启：

::

        if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
            ball_pos = screen_size * 0.5  # ball goes to screen center
            ball_speed = 80
            direction = Vector2(-1, 0)

一旦球上的所有事情都做完了，节点就应当以一个新的位置更新：

::

        get_node("ball").set_pos(ball_pos)

只根据用户输入来更新挡板。Input类此时很有用：

::

        #move left pad  
        var left_pos = get_node("left").get_pos()

        if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
            left_pos.y += -PAD_SPEED * delta
        if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
            left_pos.y += PAD_SPEED * delta

        get_node("left").set_pos(left_pos)

        #move right pad 
        var right_pos = get_node("right").get_pos()

        if (right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
            right_pos.y += -PAD_SPEED * delta
        if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
            right_pos.y += PAD_SPEED * delta

        get_node("right").set_pos(right_pos)

这就成了！一个用几行代码写出来的简单的对板弹球。
