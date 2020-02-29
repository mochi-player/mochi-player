# Fit Window

See how fit window expands the window preserving the aspect ratio but not exceeding the bounds of the current screen. Press 1-0 to try different scale factors. Tweak `qmlmain.player.video_params.{w,h}` to see how it behaves with different screen aspect ratios--or with the `qmlmain.player.anchors.*Margin` to see how it behaves given extra padding.

## Discussion

Originally developed for baka; fit-window was ported here but re-implemented to be more mathematically sound and without QtWidgets. I discuss here how I arrived at the code that is being used in `FitWindow.py`.

Goal: re-size the window such that the player display is sized proportionately to the original video aspect ratio. But ensure that the size of the window is constrained by the screen and truncated to the screen size (though still preserving the aspect ratio of the display).

For this discussion we are using shorthand
da => display aspect; sh => screen height; ww => window width; etc...

Constraints:  
(1) $va = \frac{vw}{vh}$ (Video aspect ratio computed from width / height)
(2) $ww \le sw$ (The window width should not exceed the screen width)
(3) $wh \le sh$ (The window height should not exceed the screen height)
(4) $\frac{dw}{dh} = va$ (The aspect ratio of the display should be the same as the video)
(5) $ww = dw + ew$ (The window width is the our display width with some "extra" padding)
(6) $wh = dh + eh$ (The window height is the our display height with some "extra" padding)

Known: sw, sh, va, ew, eh  
Unknown dw, dh, ww, wh

From (5) & (6) we get:  
(7) $dw = ww - ew$
(8) $dh = wh - eh$
  
From (4) = (7) / (8) we get:  
(9) $va = \frac{ww - ew}{wh - eh}$

Known: va, ew, eh  
Unknown: ww, wh

We have a "desired" value for ww and wh--we can limit it by sw and sh resulting two possibilities if it's too big for the screen, otherwise
only one.

From (9),  
given $wh_0 = \min(wh_{desired}, sh)$, we get $ww_0 = (wh_0 - eh) * va + ew$  
given $ww_1 = \min(ww_{desired}, sw)$, we get $wh_1 = \frac{ww_1 - ew}{va} + eh$

We can choose whichever set satisfies (2) and (3).
