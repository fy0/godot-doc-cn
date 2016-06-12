.. _doc_splash_screen:

启动画面(Splash Screen)
=============

教程
--------

这将是一个简单的教程来巩固关于GUI子系统如何工作的基本想法。目标是去创建一个十足简单的、静态的启动画面(译注：启动画面一说溅射屏幕，本文统一译为启动画面)。

下图是一个包含着接下来要用的资源的文件。这些东西可以直接添加到你的工程文件夹中——无需导入它们：

:download:`robisplash_assets.zip </files/robisplash_assets.zip>`.

建立
----------

在工程设定中设定显示分辨率为800×450，然后像这样建立一个新场景：

.. image:: /img/robisplashscene.png

.. image:: /img/robisplashpreview.png

节点"background"和"logo"属于 :ref:`贴图框(TextureFrame) <class_TextureFrame>`
类型。这些东西有一个特殊的属性来设定待显示的贴图，只需要载入相应的文件。

.. image:: /img/texframe.png

节点"start"是一个 :ref:`贴图按钮(TextureButton) <class_TextureButton>`，它为自己的不同状态取得几张图像，但在这个范例中，我们只提供正常的和按下的：

.. image:: /img/texbutton.png

最后，节点"copyright"是一个 :ref:`标签(Label) <class_Label>`。标签可以通过下面的属性被设定一个自定义字体：

.. image:: /img/label.png

附注，字体由一个TTF文件导入进来，见 :ref:`doc_importing_fonts`。
