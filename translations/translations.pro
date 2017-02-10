TEMPLATE=aux

include($$PWD/../app/app.pri)

# Note: Unfortunately there seems to be no sane way to get environment
# variable overrides. Because of this, I leave the challenge of getting
# lupdate/lrelease into the PATH to whoever compiles this until another
# method is thought out.

# lupdate build target
lupdate.commands += lupdate -no-obsolete -locations none $$_PRO_FILE_
QMAKE_EXTRA_TARGETS += lupdate
PRE_TARGETDEPS += lupdate

# lrelease compiler
lrelease.input = TRANSLATIONS
lrelease.output = ${QMAKE_FILE_BASE}.qm
lrelease.commands = lrelease ${QMAKE_FILE_NAME} -qm ${QMAKE_FILE_OUT}
lrelease.CONFIG = target_predeps no_link
lrelease.depends = lupdate
QMAKE_EXTRA_COMPILERS += lrelease

# translation_rc build target
translation_rc.commands = "echo \"<RCC><qresource prefix=\\\"/translations/\\\">$${TRANSLATIONS_RC}</qresource></RCC>\" > $$OUT_PWD/translations.qrc"
QMAKE_EXTRA_TARGETS += translation_rc
PRE_TARGETDEPS += translation_rc
