.. _doc_instancing:

实例化
==========

基本理论
---------

先弄一个场景然后把节点丢进去可能对一个小工程会起作用，但随着工程的增大，越来越多的节点被使用，并且很快它们就会变得难以管理。为了解决这一问题，Godot允许一个工程被分成几个场景。然而，这样和其他游戏引擎的工作方式并不一样。事实上是差别很大，所以请不要跳过本教程！

To recap: A scene is a collection of nodes organized as a tree, where
they can have only one single node as the tree root.

.. image:: /img/tree.png

In Godot, a scene can be created and saved to disk. As many scenes
can be created and saved as desired.

.. image:: /img/instancingpre.png

Afterwards, while editing an existing or a new scene, other scenes can
be instanced as part of it:

.. image:: /img/instancing.png

In the above picture, Scene B was added to Scene A as an instance. It
may seem weird at first, but at the end of this tutorial it will make
complete sense!

Instancing, step by step
------------------------

To learn how to do instancing, let's start with downloading a sample
project: :download:`instancing.zip </files/instancing.zip>`.

Unzip this scene in any place of your preference. Then, add this scene to
the project manager using the 'Import' option:

.. image:: /img/importproject.png

Simply browse to inside the project location and open the "engine.cfg"
file. The new project will appear on the list of projects. Edit the
project by using the 'Edit' option.

This project contains two scenes "ball.scn" and "container.scn". The
ball scene is just a ball with physics, while container scene has a
nicely shaped collision, so balls can be thrown in there.

.. image:: /img/ballscene.png

.. image:: /img/contscene.png

Open the container scene, then select the root node:

.. image:: /img/controot.png

Afterwards, push the '+' shaped button, this is the instancing button!

.. image:: /img/continst.png

Select the ball scene (ball.scn), the ball should appear in the origin
(0,0), move it to around the center

of the scene, like this:

.. image:: /img/continstanced.png

Press Play and Voila!

.. image:: /img/playinst.png

The instanced ball fell to the bottom of the pit.

A little more
-------------

There can be as many instances as desired in a scene, just try
instancing more balls, or duplicating them (ctrl-D or duplicate button):

.. image:: /img/instmany.png

Then try running the scene again:

.. image:: /img/instmanyrun.png

Cool, huh? This is how instancing works.

Editing instances
-----------------

Select one of the many copies of the balls and go to the property
editor. Let's make it bounce a lot more, so look for the bounce
parameter and set it to 1.0:

.. image:: /img/instedit.png

The next it will happen is that a green "revert" button appears. When
this button is present, it means we modified a property from the
instanced scene to override for a specific value in this instance. Even
if that property is modified in the original scene, the custom value
will always overwrite it. Pressing the revert button will restore the
property to the original value that came from the scene.

Conclusion
----------

Instancing seems handy, but there is more to it than it meets the eye!
The next part of the instancing tutorial should cover the rest..
