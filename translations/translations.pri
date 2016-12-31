TRANSLATIONS *= \
    $$PWD/en_US.ts

for(f, TRANSLATIONS) {
  bf = $$basename(f)
  fc = $$replace(bf, .ts, .gm)
  TRANSLATIONS_COMPILED += $$OUT_PWD/$$fc
  # for translations.pro
  TRANSLATIONS_RC += <file>$$fc</file>
}

CONFIG(embed) {
  RESOURCES += $$PWD/translations.qrc
} else {
  translation_files.path = /usr/share/mochi-player/translations/
  translation_files.files = $$TRANSLATIONS_COMPILED
  INSTALLS += translation_files
}
