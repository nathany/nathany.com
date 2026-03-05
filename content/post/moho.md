+++
title = "💔 Animating with Moho 14.4"
description = "The animation software I wanted to love."
date = "2026-03-04"
keywords = ["Moho", "animation", "rigging", "Spine", "Krita", "frame-by-frame", "onion skinning"]
+++

To provide some context, I have a long-term goal of becoming a solo game dev, but I'm new to animation. I haven't even read The Animator's Survival Kit yet! 🙀 

Still, I'm interested in the tools that are available.

## Moho ❤️

So what attracted me to [Moho](https://moho.lostmarble.com/) in particular? Was it the fact that Cartoon Saloon used it for films like The Secret of Kells and Wolfwalkers? Or maybe the recent addition of glTF export to support game engines?

What really sold me can be seen at 38 seconds into this [short video](https://www.youtube.com/watch?v=xkCXdvC8X3U) by Víctor Paredes:

{{< youtube xkCXdvC8X3U >}}

By using vector brushes, Moho makes it's possible to adjust the points that make up the knee joint as the leg moves. The vector brushes may not be as sophisticated as raster brushes in other software, but they are still able to stamp out bitmaps to provide some texture to a character made up of points.

### Reality Strikes

So I decided to download the trial version and just *try it out.* That didn't go over so well.

I clicked the freehand tool and started drawing. But wait, why is their a style panel with various settings, and then two other style drop-downs? That's odd. 

I decided to select my points and try to change the style of the lines. It didn't do anything. I played around a bit, but never got it to work.

Alright, so the drawing tools weren't very intuitive. If simple things were hard, it was pretty clear that I was going to need some help to learn this software, but I left that for another day.

### Properly Learning

The obvious solution was to go through the [six hours of official tutorials](https://www.youtube.com/playlist?list=PLynyD-7entJ2giKWS9ReviR-exwJ3UJ3T) on YouTube. I loaded up the Moho trial to follow along, trying out everything demonstrated, with plenty of rewinding.

The first day I got through the first 12 tutorials. They centered around a fox named Copper provided in a Photoshop file (PSD). Though I was more interested in vector animation than bitmap puppets, I decided to work through the tutorials in order. And besides, Copper has stubby legs, which may help avoid the issue of knee joints looking weird.

It was easy enough to follow along. The fox puppet was split into layers, separating out each limb from the body, and parts of the head and face.

*Bones* could be added and adjusted to rotate or translate the layers linked to them. The power is in the hiearchy: moving the shoulder will also move the elbow and wrist. Target bones provide inverse kinematics (IK), so you could tug on a hand and have it move the rest of the arm and body, though that wasn't really described in the tutorials.

The tutorials also went over *meshes* to deform the bitmaps. The curver mesh was used to elongate the fox's tail in a way that looked pretty reasonable. But for the most part, none of the meshes seemed very appealing due to the pace of the tutorial, which didn't show the deformations in their best light.

*Switch layers* allow a set of layers to be grouped, with only one shown at a time. For example, the Copper PSD file had layers for several mouth shapes, which could then be picked while animating.

*Actions* provide a way to reuse little animations in the mainline animation.

Sometimes the tutorials skipped steps. Lesson 9 covers adding some jiggle to the fox's ears when he moves, but it started with a jump animation that was made off camera. But overall the tutorials were pretty good.

### Problems Ensue

The next day I was excited to get into vector drawing, but first I had a few more tutorials with Copper.

As I was wrapping those up, I ran into an odd problem where moving Copper's left hand was also skewing his tail. Based on the YouTube comments, other people had some problems on that tutorial too. So maybe the tutorial skipped some steps or went back to an older version of a file.

I think it brings up a larger issue with Moho though, and that is debugging user errors.

Moho uses progressive disclosure on the timeline. The timeline indicates that *something* changed in white, and gets more specific in red when you click on one or more bones, meshes, or switch layers. Focusing like this is probably a good idea, because there can be a lot going on.

But when something strange is happening, due to a mistake or otherwise, it can be bit difficult to figure out the source. Trying to understand a bunch of tiny red icons while clicking around on different bones just isn't a great experience.

I'm not sure what the solution is. The closest thing I've seen to a *debugging* tool is clicking on reparent bone. That adds some arrows to the entire skeleton, indicating how the bones are connected. Even those can be hard to read though, because the arrows use the same color as the actual bones.

I decided not to worry about my slightly broken fox and just move on to vector drawing. That went reasonably well, and I was starting to understand the tools, but then I came to lesson 20.

The plan was to make a flame 🔥 by starting with a circle, modify its points a little, and then draw some star shapes with subtract shape to further modify the original circle. But at least for me, subtract shape wasn't working at all. The subtracted shape would just disappear, without cutting anything out of the circle.

Maybe I was doing something wrong or maybe the software is just buggy. Just before this, I was having trouble drawing a red circle. I'd pick red, but it kept reverting back to a blue color I used previously.

At this point I was half-way through the tutorial series and a little stuck.

The point of the trial and the tutorials was to learn and evaluate the software to see if I'd be willing to part with a fair chunk of money to use it in my projects. Taking into consideration the problems I had encountered combined with the limitations of the relatively new glTF export feature, I felt like I had my answer. So I threw in the towel.

## Alternatives 

While I hope to give Moho another try in a future release, I did spend some time briefly looking into other options. I haven't had a chance to properly evaluate these, but I thought I'd share some alternatives that I may look into down the road.

### Spine

For 2D animation in games, the most obvious option appears to be [Spine](https://esotericsoftware.com/). My understanding is that it's not a drawing program, but it works with existing raster assets much like the Copper PSD I used with Moho.

It doesn't have the vector animation features that I got all excited about with Moho. What it does have is direct runtime support for rendering animation in game engines, as well as exports to sprite sheets and texture packing.

### Blender

Using 3D tools for prerendered 2D assets is nothing new, though often with 3DS Max. Heroes of Might and Magic III, Dead Cells, Ori and the Blind Forest, to name a few. In an old [GDC talk](https://www.youtube.com/watch?v=m8lOwrWNbEY), James Benson shows how the 3D models for Ori were designed to only be viewed from the camera angles they needed.

Of course, all this does beg the question, why not just use 3D? I mean, if we're already rigging characters in the same way 3D characters are, and if we're leaning on a game engine that can do 3D, would it make more sense to go all-in with 3D (possibly low-poly)? Maybe.

### Onion Skinning

Going in the other direction, animating without bones and rigging can be accomplished with far simpler tools. All you need is:

* A timeline with transport controls to preview the animation and hot keys to move between frames
* Onion skinning to see the previous and next frame(s) at a lower opacity
* Image sequence export to export the keyframes

I learned that Anime has a well-defined process:

* Roughs to establish weight and movement
* Tie-down to ensure volumes and proportions are correct, while also determining areas requiring shading
* Clean up for the final line work and colouring

I can see the appeal of getting in the zone and just drawing. But it is labour intensive, and I don't have an inbetweener to draw some of the frames for me.

[Krita](https://krita.org/en/) is a digital painting tool that has these animation features built-in. For pixel art, [Aseprite](https://www.aseprite.org/) also has onion skinning.

What about using [Rebelle](/rebelle)'s fabulous paint engine to create animated sprites? Rebelle doesn't have a timeline or onion skinning, but it might be possible. The roughs and tie-down phase could be done in Krita and then exported for use as reference images for the final paintings in Rebelle. Creative use of filter layers and keyboard shortcuts may even be able to simulate onion skinning in Rebelle, though in a far less reliable way. All the extra complexity wouldn't make much sense for cel-shaded characters, but perhaps for animating portions of a watercolour background and the like.

### Manual Puppets

We talked about how Copper was a Photoshop file with layers for each body part.

Between rigging with bones and manually drawing every frame is the option of moving each of those parts around manually for each keyframe.

In an [old GDC talk](https://www.youtube.com/watch?v=8_KBjd0iaCU) from Klei, you can see the animator manually positioning the various body parts to get the animation looking just right. If they needed a new variant of a hand, they would just draw it on the fly and add it to their library.

Back in the day they were using Flash. Symbols allowed a part to be modified later without redoing the entire animation. The same thing should be possible in Krita with File Layers and Transform Masks, but if later modification isn't necessary, any program with layers should work.

During the Q&A of that talk, someone asked how they handle wonky joints. The response was that they hide them with long clothing.

### That's All For Now 

This concludes my exploration of animation tools for now. I'm probably still years away from being able to design a character I'm happy with, so I'm going to focus on art fundamentals first. That, and play around in [Rebelle](/rebelle). Thanks for reading.
