.. _doc_vector_math:

向量数学
===========

介绍
~~~~~~~~~~~~

这篇小教程意在对向量数学(Vector Mathematics)进行简短和实用的介绍，在2D和3D游戏中都非常有用。再说一遍，向量数学不仅是对3D有用， *而且* 对2D游戏也有用。一旦你掌握了它那么它是一个很棒的工具并能让复杂行为的编写更加简单。

通常地，新手程序员太依赖于 *不正确* 的数学来解决一大堆问题，比如说在2D游戏中只用三角几何学而不用向量。

这篇教程将关注于实用的用途，以及对游戏编程行业的快速应用。

2D坐标系(2D Coordinate System)
~~~~~~~~~~~~~~~~~~~~~~~

通常地，我们用有序数对(Pairs)(x,y)来定义坐标，x代表了水平偏移量而y代表了竖直偏移量。这在给定了一个二维矩形的屏幕时是有意义的。举个例子，在2D空间中有一个位置:

.. image:: /img/tutovec1.png

位置可以是空间内的任意地方。位置(0,0)有一个名字，叫做 **原点(Origin)** 。牢记这一点因为接下来它会有很多隐含的用法。一个n维坐标系中，(0,0)就是 **原点** (译注：此处说法似乎有问题，一个3D坐标系的原点是(0,0,0)，一个4D坐标系原点应当是(0,0,0,0)，一个n维坐标系的原点应当是(0,0,...,0))

在向量数学中，坐标有两种用途，这两者都很重要。它们既被用于代表一个 *位置(Position)* 又被用来代表一个 *向量(Vector)* 。位置用途同之前所述，而当视为向量时，它却有另外一番含义。

.. image:: /img/tutovec2.png

当被视为向量时，我们就可以推测出两个属性， **方向(Direction)** 和 **模(Magnitude，又称为长度，与向量的范数(norm)相等)** 。空间中的每一个位置都可以是一个向量，除了 **原点** （译注：在数学中，这种情况也是向量，但被叫做零向量）。这是因为坐标(0,0)无法代表方向(模为0)（译注：在数学中，零向量的方向是任意的）

.. image:: /img/tutovec2b.png

方向(Direction)
---------

方向就和向量指向是一致的。试想一个箭头从 **原点** 出发然后朝向一个[STRIKEOUT:位置]（译注：这里STRIKEOUT格式意义不明）。箭头的末梢在一个位置中，因此它总是指向原点外的。把向量视为箭头会大有裨益。

.. image:: /img/tutovec3b.png

模(Magnitude)
---------

最终，向量的长度就是原点到这个位置的距离。获取这个距离很容易，用
`勾股定理 <http://en.wikipedia.org/wiki/Pythagorean_theorem>`__ (Gou-gu Theorem，国外称毕达哥拉斯定理(Pythagorean Theorem))就可以了。

::

    var len = sqrt( x*x + y*y )

但是……角度呢?
--------------

但为什么不用一个 *角度* 呢？毕竟我们也能够把一个向量想成一个角度和一个模来替换一个方向和一个模。角度也是更加为人所熟知概念。

说实话，在向量数学中，角度不是那么有用，并且绝大多数时候它们也不是直接被处理的。也许它们在2D中还能运作，但到了3D中，很多能够用角度解决的问题就不再能用了。

还是，角度使用依然不是一个托辞，即使对于2D来说。在2D中绝大多数大量依靠角度的事物，在向量数学中也能很自然很容易的被解决。在向量数学中，角度只在作为一个量度的时候有用，而在其中不占多大成分。所以尽早放弃三角几何学，准备好去拥抱向量吧！

任何情况下，获得一个向量的角度是十足简单的，可以用三角几……唉，那是什么鬼？我想说的是，
:ref:`atan2() <class_@GDScript_atan2>` 函数。

Godot中的向量类型
~~~~~~~~~~~~~~~~

为了方便举例子，这里有必要解释一下GDScript中向量是如何实现的。GDScript既有
:ref:`Vector2 <class_Vector2>` 类型又有 :ref:`Vector3 <class_Vector3>`，分别对应2D数学和3D数学。Godot使用Vector类既作为位置又作为方向。他们也包含x和y(2D中)以及x、y和z(3D中)成员变量(Member Variables)。

::

    # 创建一个坐标为(2,5)的向量
    var a = Vector2(2,5)
    # 创建一个向量然后手动分配x和y
    var b = Vector2()
    b.x = 7
    b.y = 8

当执行向量运算时，我们没必要去直接操作成员变量(事实上，这更慢)。向量支持常规的算术运算符：

::

    # 向量a和向量b叠加
    var c = a + b
    # 将会产生一个向量c，值为(9,13)

除了前者是更有效且更具有可读性以外，这等效于：

::

    var c = Vector2()
    c.x = a.x + b.x
    c.y = a.y + b.y

常规的算术运算符如加(Addition)、减(Subtraction)、乘(Multiplication)、除(Division)都是支持的

向量的相乘和相除也可以结合单一的数字，这个数字也被叫做 **标量(Scalar)**。(也被称为向量的数乘运算，结果为一个向量)

::

    # 用标量乘以向量
    var c = a*2.0
    # 将产生一个向量c，值为(4,10)

还是，除了前者更加的高效且具有可读性以外，等效于：

::

    var c = Vector2()
    c.x = a.x*2.0
    c.y = a.y*2.0

正交向量(Perpendicular Vectors，即相互垂直的向量)
~~~~~~~~~~~~~~~~~~~~~

将一个2D向量向左右任意一边旋转90°，是相当简单的，只需要交换x和y，然后为x或y中的一个取相反数即可(方向取决于谁变负的了)

.. image:: /img/tutovec15.png

举例：

::

    var v = Vector2(0,1)
    # 向右旋转 (顺时针)
    var v_right = Vector2(-v.y, v.x)
    # 向左旋转 (逆时针)
    var v_right = Vector2(v.y, -v.x)

这是一个很常用的手边技巧。但是这对于3D是不可能的，因为有无穷多个正交向量。

单位向量(Unit Vectors，即模量为1的向量)
~~~~~~~~~~~~

好的，那么我们知道了向量是什么。它有 **方向** 和 **模** 。我们还知道如何在Godot中使用它们。下一步就是了解 **单位向量** 了。任意一个 **模**为1的向量都被认为是一个 **单位向量**。在2D中，试想画一个半径为1的圆(被称作单位圆)。这个圆包含了在二维中存在的所有单位向量

.. image:: /img/tutovec3.png

那么，单位向量的特殊之处在哪呢？单位向量很厉害。换句话说，单位有 **一些很有用的属性**。

我们迫不及待要去了解关于单位向量的优良属性的更多内容了，但是还是要一步一步来。那么如何由一个常规向量创建一个单位向量呢？

归一化向量(Normalization)
-------------

取得任何一个向量然后把 **模量**削减为1.0而保持它的 **方向** 的过程被称之为 **向量的归一化**。归一化通过用一个向量的x和y(3D中还有z)分量(Component)除以向量的模：

::

    var a = Vector2(2,4)
    var m = sqrt(a.x*a.x + a.y*a.y)
    a.x /= m
    a.y /= m

(注意：前方官方文档严重卖萌，与翻译组无关)
正如你所猜到的那样，如果一个向量的模量为0时(意味着不是一个向量而是 **原点**或者也叫做 *零向量(Null Vector)*)，一个除以0的除法式将发生，然后宇宙将经历又一次大爆炸(译注：没这么危险，作者只不过是在玩(mài)笑(méng)，意在说明这种错误对于程序运行是灾难性的)，除非在倒转极性下它又回来了。结果人类还健在但Godot将会输出一个错误。记住！向量(0,0)不能被归一化！

当然，Vector2和Vector3已经提供了一个方法(Method)来做这件事：

::

    a = a.normalized()

点积运算(Dot Production，又称数量积运算、点乘运算)
~~~~~~~~~~~

好了， **点积**是向量数学中最重要的部分。没有点积的话，雷神之锤(Quake)就不可能被做出来。这是本教程最重要的一节，所以确保能够适当地掌握它。绝大多数尝试去理解向量数学的人都在此放弃了，因为无论它有多简单，他们从中也做不出个头尾。为什么呢？因为……

点积取两个向量进行运算并返回一个 **标量** ：

::

    var s = a.x*b.x + a.y*b.y

是的，基本就是这样。用 **a**向量的 **x**乘以 **b**向量的 **x**。对y再进行一次然后相加。在3D中基本还是这样：

::

    var s = a.x*b.x + a.y*b.y + a.z*b.z

我知道，这一点意义都没有，你甚至都可以用内置函数来完成：

::

    var s = a.dot(b)

两个向量的顺序 **没有**影响(因为点积遵循交换律)， ``a.dot(b)``和 ``b.dot(a)``返回相同的值。

这正是绝望的开始，教科书和教程都会给你下面这个公式：

.. image:: /img/tutovec4.png

然后你就意识到你该放弃制作3D或者复杂的2D游戏了。那么为什么会有这么个既简单又复杂的东西呢？别人将不得不去做塞尔达(Zelda)或者使命召唤(Call of Duty)。顶视角RPG(Top Down RPG,TDRPG)毕竟看起来不那么糟糕。是的，我听到有人
And you realize it's time to give up making 3D games or complex 2D
games. How can something so simple be so complex? Someone else will have
to make the next Zelda or Call of Duty. Top down RPGs don't look so bad
after all. Yeah I hear someone did pretty will with one of those on
Steam...

所以这是属于你的时刻，这是你闪耀的时间。 **不要怂，就是上！**
在这一问题上，这篇教程将会来一个大转弯然后关注什么使得点积这么的有用。也就是， **为什么**它很有用。我们将会逐一关注点积的使用情形，以及现实中的应用。世上没有毫无意义的公式。 *一旦你了解了* 它们用于什么，公式们将会有意义。

Siding
------

点积第一个有用的也是最重要的性质就是去检测旁边事物在看什么。我们试想一下有任意两个向量 **a**和 **b**。任意的 **方向**或 **模**(不能是 **原点**)。。这些并不会影响它们，但是让我们试想我们对它们实施点积运算。

::

    var s = a.dot(b)

运算将会返回一个单精度浮点型的数(但是既然我们在向量的世界中，我们叫它们 **标量**，从现在起我们将持续沿用这个概念)。这个数(译者吐槽：说好的从现在起持续沿用呢！！)将会告诉我们以下内容：

-  如果这个数大于0，则两者皆面向同一方向(两者夹角小于90°，为锐角)。
-  如果这个数小于0，两者面向相反的方向(两者夹角大于90°，为钝角)。
-  如果这个数就是0，向量将会按L形垂直排列(两者夹角为90°，为直角)。

.. image:: /img/tutovec5.png

那么，让我们想象一个真实的使用案例。想象一条蛇正在穿过一个森林，然后附近有一个敌人。我们如何快速的辨别敌人是否已经发现了蛇呢？为了发现他，敌人必须能够 *看到*蛇。然后我们说：

-  蛇在位置 **A**。
-  敌人在位置 **B**。
-  敌人正 *面向*向量 **F**的方向。

.. image:: /img/tutovec6.png

那么，我们就来创建新向量 **BA**，从守卫( **B**)指向蛇( **A**)，通过两者坐标相减(末减初)：

::

    var BA = A - B

.. image:: /img/tutovec7.png

理想地，如果守卫正好直视着蛇，为了发生眼神接触，它将会以和向量BA同向方向做这件事
(译者注：最后一句it would do it没看懂，暂留原文以备修改)Ideally, if the guard was looking straight towards snake, to make eye to
eye contact, it would do it in the same direction as vector BA.

如果 **F**和 **BA**的数量积大于0，那么蛇就被发现了。这发生了因为我们将可以判断这个正面向他：

::

    if (BA.dot(F) > 0):
        print("!")

目前来看，蛇似乎还很安全。

支持单位向量
~~~~~~~~~~~~~~~~~~~~~~~~

好了，那么我们现在知道了两个向量的点积将会告诉我们它们看向了同侧、异侧还是干脆彼此垂直。

这对于所有向量都适用，和模量无关，因此 **单位向量** 也不例外。然而，对单位向量使用相同的属性会产生一个更有趣的结果，因为多了一个附加属性：

-  如果两个向量都面向了完全相同的方向（彼此平行(Parallel，在向量中也被称为共线)，夹角是0°(同向)），标量结果为 **1** 。

-  如果两个向量都面向了完全相同的方向（彼此平行，夹角却是180°(反向)），标量结果为 **-1** 。

这也就意味着，单位向量的点积结果将总在范围[-1,1]之间。那么又……

-  如果夹角为 **0°** 点积为 **1** 。

-  如果夹角为 **90°** 点积为 **0** 。

-  如果夹角为 **180°** 点积为 **-1** 。

额……这有点莫名的熟悉……好像在哪见过……哪呢？

我们来引入两个单位向量，第一个向上指，第二个也一样但是我们将会全程让它从上(0°)到下(180°)旋转……

.. image:: /img/tutovec8.png

当测算标量结果时！

.. image:: /img/tutovec9.png

啊哈！一切都明朗了，这是 `余弦 <http://mathworld.wolfram.com/Cosine.html>`__ 函数！

我们于是就能说，作为一个准则……

两个 **单位向量** 的 **点积** 是两个向量 **夹角** 的 **余弦值** 。因此，欲获取两个向量的夹角，我们必须要：

::

    var angle_in_radians = acos( a.dot(b) )

这对什么有用呢？直接获取向量的夹角可能不那么有用，
What is this useful for? Well obtaining the angle directly is probably
not as useful, but just being able to tell the angle is useful for
reference. One example is in the `Kinematic
Character <https://github.com/godotengine/godot/blob/master/demos/2d/kinematic_char/player.gd#L879>`__
demo, when the character moves in a certain direction then we hit an
object. How to tell if what we hit is the floor?

By comparing the normal of the collision point with a previously
computed angle.

The beauty of this is that the same code works exactly the same and
without modification in
`3D <https://github.com/godotengine/godot/blob/master/demos/3d/kinematic_char/cubio.gd#L57>`__.
Vector math is, in a great deal, dimension-amount-independent, so adding
or removing an axis only adds very little complexity.

平面
~~~~~~

The dot product has another interesting property with unit vectors.
Imagine that perpendicular to that vector (and through the origin)
passes a plane. Planes divide the entire space into positive
(over the plane) and negative (under the plane), and (contrary to
popular belief) you can also use their math in 2D:

.. image:: /img/tutovec10.png

Unit vectors that are perpendicular to a surface (so, they describe the
orientation of the surface) are called **unit normal vectors**. Though,
usually they are just abbreviated as \*normals. Normals appear in
planes, 3D geometry (to determine where each face or vertex is siding),
etc. A **normal** *is* a **unit vector**, but it's called *normal*
because of it's usage. (Just like we call Origin to (0,0)!).

It's as simple as it looks. The plane passes by the origin and the
surface of it is perpendicular to the unit vector (or *normal*). The
side towards the vector points to is the positive half-space, while the
other side is the negative half-space. In 3D this is exactly the same,
except that the plane is an infinite surface (imagine an infinite, flat
sheet of paper that you can orient and is pinned to the origin) instead
of a line.

到平面的距离
-----------------

Now that it's clear what a plane is, let's go back to the dot product.
The dot product between a **unit vector** and any **point in space**
(yes, this time we do dot product between vector and position), returns
the **distance from the point to the plane**:

::

    var distance = normal.dot(point)

But not just the absolute distance, if the point is in the negative half
space the distance will be negative, too:

.. image:: /img/tutovec11.png

This allows us to tell which side of the plane a point is.

离开原点
--------------------

I know what you are thinking! So far this is nice, but *real* planes are
everywhere in space, not only passing through the origin. You want real
*plane* action and you want it *now*.

Remember that planes not only split space in two, but they also have
*polarity*. This means that it is possible to have perfectly overlapping
planes, but their negative and positive half-spaces are swapped.

With this in mind, let's describe a full plane as a **normal** *N* and a
**distance from the origin** scalar *D*. Thus, our plane is represented
by N and D. For example:

.. image:: /img/tutovec12.png

For 3D math, Godot provides a :ref:`Plane <class_Plane>`
built-in type that handles this.

Basically, N and D can represent any plane in space, be it for 2D or 3D
(depending on the amount of dimensions of N) and the math is the same
for both. It's the same as before, but D is the distance from the origin
to the plane, travelling in N direction. As an example, imagine you want
to reach a point in the plane, you will just do:

::

    var point_in_plane = N*D

This will stretch (resize) the normal vector and make it touch the
plane. This math might seem confusing, but it's actually much simpler
than it seems. If we want to tell, again, the distance from the point to
the plane, we do the same but adjusting for distance:

::

    var distance = N.dot(point) - D

The same thing, using a built-in function:

::

    var distance = plane.distance_to(point)

This will, again, return either a positive or negative distance.

Flipping the polarity of the plane is also very simple, just negate both
N and D. This will result in a plane in the same position, but with
inverted negative and positive half spaces:

::

    N = -N
    D = -D

Of course, Godot also implements this operator in :ref:`Plane <class_Plane>`,
so doing:

::

    var inverted_plane = -plane

Will work as expected.

So, remember, a plane is just that and it's main practical use is
calculating the distance to it. So, why is it useful to calculate the
distance from a point to a plane? It's extremely useful! Let's see some
simple examples..

在2D中构建平面
--------------------------

Planes clearly don't come out of nowhere, so they must be built.
Constructing them in 2D is easy, this can be done from either a normal
(unit vector) and a point, or from two points in space.

In the case of a normal and a point, most of the work is done, as the
normal is already computed, so just calculate D from the dot product of
the normal and the point.

::

    var N = normal
    var D = normal.dot(point)

For two points in space, there are actually two planes that pass through
them, sharing the same space but with normal pointing to the opposite
directions. To compute the normal from the two points, the direction
vector must be obtained first, and then it needs to be rotated 90°
degrees to either side:

::

    # calculate vector from a to b
    var dvec = (point_b - point_a).normalized()
    # rotate 90 degrees
    var normal = Vector2(dvec.y,-dev.x)
    # or alternatively
    # var normal = Vector2(-dvec.y,dev.x)
    # depending the desired side of the normal

The rest is the same as the previous example, either point_a or
point_b will work since they are in the same plane:

::

    var N = normal
    var D = normal.dot(point_a)
    # this works the same
    # var D = normal.dot(point_b)

Doing the same in 3D is a little more complex and will be explained
further down.

平面的使用举例
-----------------------

Here is a simple example of what planes are useful for. Imagine you have
a `convex <http://www.mathsisfun.com/definitions/convex.html>`__
polygon. For example, a rectangle, a trapezoid, a triangle, or just any
polygon where faces that don't bend inwards.

For every segment of the polygon, we compute the plane that passes by
that segment. Once we have the list of planes, we can do neat things,
for example checking if a point is inside the polygon.

We go through all planes, if we can find a plane where the distance to
the point is positive, then the point is outside the polygon. If we
can't, then the point is inside.

.. image:: /img/tutovec13.png

Code should be something like this:

::

    var inside = true
    for p in planes:
        # check if distance to plane is positive
        if (N.dot(point) - D > 0):
            inside = false
            break # with one that fails, it's enough

Pretty cool, huh? But this gets much better! With a little more effort,
similar logic will let us know when two convex polygons are overlapping
too. This is called the Separating Axis Theorem (or SAT) and most
physics engines use this to detect collision.

The idea is really simple! With a point, just checking if a plane
returns a positive distance is enough to tell if the point is outside.
With another polygon, we must find a plane where *all the **other**
polygon points* return a positive distance to it. This check is
performed with the planes of A against the points of B, and then with
the planes of B against the points of A:

.. image:: /img/tutovec14.png

Code should be something like this:

::

    var overlapping = true

    for p in planes_of_A:
        var all_out = true
        for v in points_of_B:
            if (p.distance_to(v) < 0):
                all_out = false
                break

        if (all_out):
            # a separating plane was found
            # do not continue testing
            overlapping = false
            break

    if (overlapping):
        # only do this check if no separating plane
        # was found in planes of A
        for p in planes_of_B:
            var all_out = true
            for v in points_of_A:
                if (p.distance_to(v) < 0):
                    all_out = false
                    break

            if (all_out):
                overlapping = false
                break

    if (overlapping):
        print("Polygons Collided!")

As you can see, planes are quite useful, and this is the tip of the
iceberg. You might be wondering what happens with non convex polygons.
This is usually just handled by splitting the concave polygon into
smaller convex polygons, or using a technique such as BSP (which is not
used much nowadays).

叉积(Cross Product，又称向量的向量积、叉乘运算)
-------------

Quite a lot can be done with the dot product! But the party would not be
complete without the cross product. Remember back at the beginning of
this tutorial? Specifically how to obtain a perpendicular (rotated 90
degrees) vector by swapping x and y, then negating either of them for
right (clockwise) or left (counter-clockwise) rotation? That ended up
being useful for calculating a 2D plane normal from two points.

As mentioned before, no such thing exists in 3D because a 3D vector has
infinite perpendicular vectors. It would also not make sense to obtain a
3D plane from 2 points, as 3 points are needed instead.

To aid in this kind stuff, the brightest minds of humanity's top
mathematicians brought us the **cross product**.

The cross product takes two vectors and returns another vector. The
returned third vector is always perpendicular to the first two. The
source vectors, of course, must not be the same, and must not be
parallel or opposite, else the resulting vector will be (0,0,0):

.. image:: /img/tutovec16.png

The formula for the cross product is:

::

    var c = Vector3()
    c.x = (a.y + b.z) - (a.z + b.y)
    c.y = (a.z + b.x) - (a.x + b.z)
    c.z = (a.x + b.y) - (a.y + b.x)

This can be simplified, in Godot, to:

::

    var c = a.cross(b)

However, unlike the dot product, doing ``a.cross(b)`` and ``b.cross(a)``
will yield different results. Specifically, the returned vector will be
negated in the second case. As you might have realized, this coincides
with creating perpendicular vectors in 2D. In 3D, there are also two
possible perpendicular vectors to a pair of 2D vectors.

Also, the resulting cross product of two unit vectors is *not* a unit
vector. Result will need to be renormalized.

三角形区域
~~~~~~~~~~~~~~~~~~

Cross product can be used to obtain the surface area of a triangle in
3D. Given a triangle consisting of 3 points, **A**, **B** and **C**:

.. image:: /img/tutovec17.png

Take any of them as a pivot and compute the adjacent vectors to the
other two points. As example, we will use B as a pivot:

::

    var BA = A - B
    var BC = C - B

.. image:: /img/tutovec18.png

Compute the cross product between **BA** and **BC** to obtain the
perpendicular vector **P**:

::

    var P = BA.cross(BC)

.. image:: /img/tutovec19.png

The length (magnitude) of **P** is the surface area of the parallelogram
built by the two vectors **BA** and **BC**, therefore the surface area
of the triangle is half of it.

::

    var area = P.length()/2

三角形所在平面
~~~~~~~~~~~~~~~~~~~~~

With **P** computed from the previous step, normalize it to get the
normal of the plane.

::

    var N = P.normalized()

And obtain the distance by doing the dot product of P with any of the 3
points of the **ABC** triangle:

::

    var D = P.dot(A)

Fantastic! You computed the plane from a triangle!

Here's some useful info (that you can find in Godot source code anyway).
Computing a plane from a triangle can result in 2 planes, so a sort of
convention needs to be set. This usually depends (in video games and 3D
visualization) to use the front-facing side of the triangle.

In Godot, front-facing triangles are those that, when looking at the
camera, are in clockwise order. Triangles that look Counter-clockwise
when looking at the camera are not drawn (this helps to draw less, so
the back-part of the objects is not drawn).

To make it a little clearer, in the image below, the triangle **ABC**
appears clock-wise when looked at from the *Front Camera*, but to the
*Rear Camera* it appears counter-clockwise so it will not be drawn.

.. image:: /img/tutovec20.png

Normals of triangles often are sided towards the direction they can be
viewed from, so in this case, the normal of triangle ABC would point
towards the front camera:

.. image:: /img/tutovec21.png

So, to obtain N, the correct formula is:

::

    # clockwise normal from triangle formula
    var N = (A-C).cross(A-B).normalized()
    # for counter-clockwise:
    # var N = (A-B).cross(A-C).normalized()
    var D = N.dot(A)

3D中的碰撞检测
~~~~~~~~~~~~~~~~~~~~~~~~~

This is another bonus bit, a reward for being patient and keeping up
with this long tutorial. Here is another piece of wisdom. This might
not be something with a direct use case (Godot already does collision
detection pretty well) but It's a really cool algorithm to understand
anyway, because it's used by almost all physics engines and collision
detection libraries :)

Remember that converting a convex shape in 2D to an array of 2D planes
was useful for collision detection? You could detect if a point was
inside any convex shape, or if two 2D convex shapes were overlapping.

Well, this works in 3D too, if two 3D polyhedral shapes are colliding,
you won't be able to find a separating plane. If a separating plane is
found, then the shapes are definitely not colliding.

To refresh a bit a separating plane means that all vertices of polygon A
are in one side of the plane, and all vertices of polygon B are in the
other side. This plane is always one of the face-planes of either
polygon A or polygon B.

In 3D though, there is a problem to this approach, because it is
possible that, in some cases a separating plane can't be found. This is
an example of such situation:

.. image:: /img/tutovec22.png

To avoid it, some extra planes need to be tested as separators, these
planes are the cross product between the edges of polygon A and the
edges of polygon B

.. image:: /img/tutovec23.png

So the final algorithm is something like:

::

    var overlapping = true

    for p in planes_of_A:
        var all_out = true
        for v in points_of_B:
            if (p.distance_to(v) < 0):
                all_out = false
                break

        if (all_out):
            # a separating plane was found
            # do not continue testing
            overlapping = false
            break

    if (overlapping):
        # only do this check if no separating plane
        # was found in planes of A
        for p in planes_of_B:
            var all_out = true
            for v in points_of_A:
                if (p.distance_to(v) < 0):
                    all_out = false
                    break

            if (all_out):
                overlapping = false
                break

    if (overlapping):
        for ea in edges_of_A:
            for eb in edges_of_B:
                var n = ea.cross(eb)
                if (n.length() == 0):
                    continue

                var max_A = -1e20 # tiny number
                var min_A = 1e20 # huge number

                # we are using the dot product directly
                # so we can map a maximum and minimum range
                # for each polygon, then check if they
                # overlap.

                for v in points_of_A:
                    var d = n.dot(v)
                    if (d > max_A):
                        max_A = d
                    if (d < min_A):
                        min_A = d

                var max_B = -1e20 # tiny number
                var min_B = 1e20 # huge number

                for v in points_of_B:
                    var d = n.dot(v)
                    if (d > max_B):
                        max_B = d
                    if (d < min_B):
                        min_B = d

                if (min_A > max_B or min_B > max_A):
                    # not overlapping!
                    overlapping = false
                    break

            if (not overlapping):
                break

    if (overlapping):
       print("Polygons collided!")

This was all! Hope it was helpful, and please give feedback and let know
if something in this tutorial is not clear! You should be now ready for
the next challenge... :ref:`doc_matrices_and_transforms`!



