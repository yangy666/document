from enum import Enum


class Values():
    values = {'B': 1}

    @staticmethod
    def getValues():
        if len(Values.values) <= 1:
            kbunits = ['KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB', 'BB', 'NB', 'DB']
            kibunits = ['KiBi', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB', 'BiB', 'NiB', 'DiB']
            for index, unit in enumerate(kibunits):
                Values.values[unit] = 1 << (index + 1) * 10
            for index, unit in enumerate(kbunits):
                Values.values[unit] = 10 ** ((index + 1) * 3)
        return Values.values

    @staticmethod
    def get(key):
        return Values.getValues().get(key)


class Units(Enum):

    def __new__(cls, name):
        obj = object.__new__(cls)
        #print(name)
        obj._value_ = Values.get(name)
        return obj

    B = ('B')
    KB = ('KB')
    KiB = ('KiBi')
    MB = ('MB')
    MiB = ('MiB')
    GB = ('GB')
    GiB = ('GiB')
    TB = ('TB')
    TiB = ('TiB')
    PB = ('PB')
    PiB = ('PiB')
    EB = ('EB')
    EiB = ('EiB')
    ZB = ('ZB')
    ZiB = ('ZiB')
    YB = ('YB')
    YiB = ('YiB')
    BB = ('BB')
    BiB = ('BiB')
    NB = ('NB')
    NiB = ('NiB')
    DB = ('DB')
    DiB = ('DiB')


class Byte():
    __defaultformat = "%.5f"

    @staticmethod
    def convert(value, unit=Units.B, format=__defaultformat):
        if (unit == Units.B):
            return str(value).split(".", 2)[0] + unit.name
        else:
            return (format % (value / unit.value)) + unit.name


if __name__ == "__main__":
    print(Byte.convert(12313213453, Units.MB, "%.2f"))
