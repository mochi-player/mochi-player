TEMPLATE = subdirs

SUBDIRS += \
  app \
  lib \
  platform \
  src \
  test \
  translations

# depends
src.depends = platform lib
app.depends = src translations
test.depends = src

# no duplication with lupdate commands
lupdate_only {
  SUBDIRS = translations
}
