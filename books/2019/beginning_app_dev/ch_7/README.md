# Navigation and Routing

## All apps have the concept of moving from one screen to another. The user clicks the cart button, and we go to the card screen. The user clicks “continue shopping” button, and we get to browse for more products to buy. Some app developers call it routing. Others call it navigation. Whatever you want to call it, this is one area that Flutter makes really easy because there are only four ways of navigating:

## Stacks – Each widget is full screen. The user taps a button to go through a predefined workflow. History is maintained, and they can travel back one level by hitting a back button.

## Drawers – Most of the screen shows a widget, but on the left edge, a drawer is peeking out at the user. When they press it or swipe it right, it slides out revealing a menu of choices. Pressing one changes the widget in the main part of the screen.

## Tabs – Some room is reserved for a set of tabs at the top or the bottom of the screen. When you press on a tab, we show the widget that corresponds to that tab.

## Dialogs – While these aren’t technically part of navigation, they are a way to see another widget, so we’ll allow it. Dialogs are modal (aka pop-up windows) that stay until the user dismisses them.

## Each of these methods depends on your app having a MaterialWidget as its ancestor. Let’s drill into them starting with stack navigation.