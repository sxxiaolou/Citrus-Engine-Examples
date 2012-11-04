[Get the full engine here](https://github.com/alamboley/Citrus-Engine)

![](http://aymericlamboley.fr/blog/wp-content/uploads/2012/11/citrus-logo-2D.png)

The [Citrus Engine](http://citrusengine.com/) is a professional-grade, scalable Flash game engine built for industry-quality games. It is built upon modern Flash programming practices, allowing you to focus on making your game awesome! It comes built-in with a "platformer" starter-kit, which you can use to easily make awesome 2D or 3D sidescrolling games.

The [Citrus Engine](http://citrusengine.com/) is not only made for platformer games, but for all type of games. It offers a nice way to separate logic/physics from art.

It offers many options, you may use :
- select between : the classic flash display list, blitting, [Starling](http://gamua.com/starling/) and [Away3D](http://away3d.com/).
- select between : [Box2D](http://www.box2d.org/manual.html), [Nape](http://deltaluca.me.uk/docnew/), [AwayPhysics](https://github.com/away3d/awayphysics-core-fp11) and a Simple math based collision detection.
- a simple way to manage object creation, and for advanced developers : an entity/component system and object pooling.
- a LevelManager and a LoadManager which may use Flash Pro as a level editor.
- a Console, Sound management class, Keyboard and input handler...

Games References
----------------
[![Escape From Nerd Factory](http://aymericlamboley.fr/blog/wp-content/uploads/2012/09/escape-from-nerd-factory.jpg)](http://www.newgrounds.com/portal/view/598677)
[![Kinessia](http://aymericlamboley.fr/blog/wp-content/uploads/2012/08/Kinessia.jpg)](http://kinessia.aymericlamboley.fr/)
[![MarcoPoloWeltrennen](http://aymericlamboley.fr/blog/wp-content/uploads/2012/08/MarcoPoloWeltrennen.png)](http://www.marcopoloweltrennen.de/)
[![Tibi](http://aymericlamboley.fr/blog/wp-content/uploads/2012/09/Tibi.png)](http://hellorepublic.com/client/tibi/platform/)

Project Setup
-------------
- bin : pictures, animations, levels, ... loaded at runtime.
- embed : embedded assets (e.g. fonts, pictures, texture atlas, ...).
- fla : two levels used in the box2dstarling demo, and two animate characters in two versions one for SpriteArt and one for StarlingArt thanks to the DynamicTextureAtlas class (loaded at runtime).
- src : different demos ready to use! You just need to copy & paste the Main from the package you want into the src/Main.as and the demo will run. Be careful with package & import.

[API](http://www.aymericlamboley.fr/ce-doc/)