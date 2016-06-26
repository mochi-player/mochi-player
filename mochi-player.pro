TEMPLATE = subdirs

SUBDIRS += \
  lib \
  platform \
  src \
  app \
  test

src.depends = platform lib
app.depends = src
test.depends = src
