.. _doc_animations:

动画(Animations)
==========

介绍
------------

这篇教程将会解释Godot中一切是怎样被编成动画的。Godot的动画系统是极其的强大且灵活。

首先，我们就来使用上一篇教程的场景(:ref:`doc_splash_screen`)，目标是加入一些简单的动画。以防万一，这里还有个拷贝：
:download:`robisplash.zip </files/robisplash.zip>`.

创建动画
----------------------

首先，添加一个 :ref:`动画播放器(AnimationPlayer) <class_AnimationPlayer>`节点(译注：AnimationPlayer作为节点名或类时不予翻译)到场景中作为bg(根节点)的一个子节点：

.. image:: /img/animplayer.png

当这种类型的一个节点被选定时，动画编辑器面板(Animation Editor Panel)将会出现：

.. image:: /img/animpanel.png

那么，是时候去创建一个新动画了！按下新建动画(New Animation)按钮，并将动画命名为"intro"。

.. image:: /img/animnew.png

在动画被创建之后，那就该编辑它了，通过按下编辑(Edit)按钮：

.. image:: /img/animedit.png

编辑动画
---------------------

现在就是见证奇迹的时刻(翻译组卖萌：@刘谦)！在编辑按钮被按下时，发生了一些事情，首先就是动画编辑器(Animation Editor)出现在了动画面板的上方。

.. image:: /img/animeditor.png

而第二个最重要，就是属性编辑器(Property Editor)进入了动画编辑(Animation Editing)模式。在这个模式下，一个钥匙的图标出现在了属性编辑器中的每一个属性旁边。这就意味着，在Godot中，*任意对象的任意属性*都是可补间的：

.. image:: /img/propertykeys.png

让logo出现
----------------------

接下来，logo将会从屏幕顶端出现。在选定了动画播放器之后，编辑器面板将始终可见直至手动隐藏(或者动画节点被消除)。利用这一点，选择"logo"节点然后来到"pos"属性，让他动起来，运动到：114,-400。

一到达了这个位置，就按下这个属性旁边的钥匙按钮：

.. image:: /img/keypress.png

由于动画轨(Animation Track)是新的，因此会出现一个询问是否创建这条轨。确定！

.. image:: /img/addtrack.png

然后，这个关键帧(Keyframe)就被添加到了动画编辑器中：

.. image:: /img/keyadded.png

接着，移动编辑器的光标(Cursor)到顶端，通过点击这里：

.. image:: /img/move_cursor.png

改变logo的位置到114,0并再一次添加一个关键帧。有了两个关键帧，动画就产生了。

.. image:: /img/animation.png

按下动画面板的播放(Play)按钮将会使得logo下降出来。为了在运行场景时检验这一点，自动播放(Autoplay)按钮将会把动画标记为场景开始时就自动开始的动画：

.. image:: /img/autoplay.png

最后，当运行场景时，动画应该看起来像这样：

.. image:: /img/out.gif
