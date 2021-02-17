# Adding Animation to an App

## In this chapter, you'll learn how to add animation to an app to convey action, which can improve the user experience (UX) if appropriately used. Too many animations without conveying the appropriate action can make the UX worse. Flutter has two types of animation: physics‐based and Tween. This chapter will focus on Tween animations.

## Physics‐based animation is used to mimic real‐world behavior. For example, when an object is dropped and hits the ground, it will bounce and continue to move forward, but with each bounce, it continues to slow down with smaller rebounds and eventually stop. As the object gets closer to the ground with each bounce, the velocity increases, but the height of the bounce decreases.

## Tween is short for “in‐between,” meaning that the animation has beginning and ending points, a timeline, and a curve that specifies the timing and speed of the transition. The beauty is that the framework automatically calculates the transition from the beginning to end point.

## WHAT YOU WILL LEARN IN THIS CHAPTER

### How to use AnimatedContainer to gradually change values over time
### How to use AnimatedCrossFade to cross‐fade between two children widgets
### How to use AnimatedOpacity to show or hide widget visibility by animated fading over time
### How to use the AnimationController to create custom animations
### How to use the AnimationController to control staggered animations