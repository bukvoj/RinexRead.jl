# RinexRead

[![Build Status](https://github.com/bukvoj/RinexRead.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/bukvoj/RinexRead.jl/actions/workflows/CI.yml?query=branch%3Amaster)


This module allows the user to read rinex files contents. It was implemented
Implemented based of this:\
https://files.igs.org/pub/data/format/rinex303.pdf

Julia 1.10 or newer is needed to run the parser.

Currently, Rinex 3.x navigation and observation file parsing is supported.

To parse a Rinex file, simply run:

```
header, data = rinexread("rinexfilepath.rnx")
```
- ```header``` is a structure containing the header contents.
- ```data``` is a structure containing the contents of the data section.

### Data section
The structure of the data section was heavily inspired by the matlab counterpart ```rinexread()```: https://www.mathworks.com/help/nav/ref/rinexread.html

```data``` is a structure with the following fields
- ```GPS```
- ```GLONASS```
- ```GALILEO```
- ```BEIDOU```
- ```SBAS```
- ```QZSS```
- ```IRNSS```

Each field contains a dataframe (possibly empty, if no data from given constellation was present). The columns of the dataframe have names identical to those in the Matlab version. 