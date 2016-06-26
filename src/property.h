#ifndef PROPERTY_H
#define PROPERTY_H

// Custom macro for quicker property creation,
//  sets Q_PROPERTY, creates member and notify signal
//  note that a extra can be nothing, just leave a trailing comma
#define M_PROPERTY(type, name, extra) \
  Q_PROPERTY(type name MEMBER name NOTIFY name##Changed extra) \
  public: \
    Q_SIGNAL void name##Changed(type); \
  private: \
    type name;

#endif // PROPERTY_H
