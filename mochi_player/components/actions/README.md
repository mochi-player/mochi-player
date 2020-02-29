# Actions

Start the demo and press a, b, c, and d to see the triggered actions.

## Discussion

Because retaining focus is a challenge--I'd like a mechanism for capturing keyboard shortcuts that works better. Actions are pretty ideal and have a few other perks:

- Can be labeled with text and an icon
- Can be added to menus in the application
- Have signals associated which can be connected to the application

I've extended them to support another property `action` which is an `eval` allowing javascript code to determine the trigger result.

`Actions` basically just aggregates a bunch of `Action` definitions together along with applying any user-specified overrides. This will enable us to specify Actions throughout our application where it makes sense, yet allow our users to alter them (shortcut, label, or otherwise) and have those alterations visible in menus and such.

## Caveat

A recent use case involves distinguishing between numpad and regular number keys. Qt apparently does not support this in QAction or QShortcuts... Thus we may want to consider the previous approach again and figure out focus issues.
