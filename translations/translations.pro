TEMPLATE=aux

include($$PWD/../app/app.pri)

# lupdate build target
#LUPDATE=$(LUPDATE)
isEmpty(LUPDATE):LUPDATE=lupdate
lupdate.commands += $$LUPDATE -no-obsolete -locations none $$_PRO_FILE_
QMAKE_EXTRA_TARGETS += lupdate
PRE_TARGETDEPS += lupdate

# lrelease compiler
#LUPDATE=$(LRELEASE)
isEmpty(LRELEASE):LRELEASE=lrelease
lrelease.input = TRANSLATIONS
lrelease.output = ${QMAKE_FILE_BASE}.qm
lrelease.commands = $$LRELEASE ${QMAKE_FILE_NAME} -qm ${QMAKE_FILE_OUT}
lrelease.CONFIG = target_predeps no_link
lrelease.depends = lupdate
QMAKE_EXTRA_COMPILERS += lrelease

# translation_rc build target
translation_rc.commands = "echo \"<RCC><qresource prefix=\\\"/translations/\\\">$${TRANSLATIONS_RC}</qresource></RCC>\" > $$OUT_PWD/translations.qrc"
QMAKE_EXTRA_TARGETS += translation_rc
PRE_TARGETDEPS += translation_rc
