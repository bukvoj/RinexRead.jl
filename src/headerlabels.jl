
abstract type HeaderLabels end

abstract type RinexVersionType <: HeaderLabels end
abstract type PgmRunbyDate <: HeaderLabels end
abstract type Comment <: HeaderLabels end
abstract type MarkerName <: HeaderLabels end
abstract type MarkerNumber <: HeaderLabels end
abstract type MarkerType <: HeaderLabels end
abstract type Observer <: HeaderLabels end
abstract type RecNumberTypeVers <: HeaderLabels end
abstract type AntNumberType <: HeaderLabels end
abstract type ApproxPositionXYZ <: HeaderLabels end
abstract type AntennaDeltaHEN <: HeaderLabels end
abstract type AntennaDeltaXYZ <: HeaderLabels end
abstract type AntennaPhaseCenter <: HeaderLabels end
abstract type AntennaBsight <: HeaderLabels end
abstract type AntennaZerodirXYZ <: HeaderLabels end
abstract type AntennaZerodirAzi <: HeaderLabels end
abstract type AntennaCenterOfMass <: HeaderLabels end
abstract type SystemObsType <: HeaderLabels end
abstract type SignalStrengthUnit <: HeaderLabels end
abstract type Interval <: HeaderLabels end
abstract type TimeOfFirstObs <: HeaderLabels end
abstract type TimeOfLastObs <: HeaderLabels end
abstract type RcvClockOffsAppl <: HeaderLabels end
abstract type SysDcbsApplied <: HeaderLabels end
abstract type SysPcvsApplied <: HeaderLabels end
# abstract type SysScaleFactor <: HeaderLabels end
# abstract type SysPhaseShift <: HeaderLabels end
abstract type GlonassSlotFrqNum <: HeaderLabels end
# abstract type GlonassCodPhsBis <: HeaderLabels end
# abstract type LeapSeconds <: HeaderLabels end
abstract type NumSatellites <: HeaderLabels end
abstract type PrnObsTypes <: HeaderLabels end
abstract type EndOfHeader <: HeaderLabels end




const HEADER_LABELS = Dict("RINEX VERSION / TYPE" => RinexVersionType,
                     "PGM / RUN BY / DATE" => PgmRunbyDate,
                     "COMMENT" => Comment,
                     "MARKER NAME" => MarkerName,
                     "MARKER NUMBER" => MarkerNumber,
                     "MARKER TYPE" => MarkerType,
                     "OBSERVER / AGENCY" => Observer,
                     "REC # / TYPE / VERS" => RecNumberTypeVers,
                     "ANT # / TYPE" => AntNumberType,
                     "APPROX POSITION XYZ" => ApproxPositionXYZ,
                     "ANTENNA: DELTA H/E/N" => AntennaDeltaHEN,
                     "ANTENNA: DELTA X/Y/Z" => AntennaDeltaXYZ,
                     "ANTENNA: PHASECENTER" => AntennaPhaseCenter,
                     "ANTENNA: B.SIGHT XYZ" => AntennaBsight,
                     "ANTENNA: ZERODIR AZI" => AntennaZerodirAzi,
                     "ANTENNA: ZERODIR XYZ" => AntennaZerodirXYZ,
                     "CENTER OF MASS: XYZ" => AntennaCenterOfMass,
                     "SYS / # / OBS TYPES" => SystemObsType,
                     "SIGNAL STRENGTH UNIT" => SignalStrengthUnit,
                     "INTERVAL" => Interval,
                     "TIME OF FIRST OBS" => TimeOfFirstObs,
                     "TIME OF LAST OBS" => TimeOfLastObs,
                     "RCV CLOCK OFFS APPL" => RcvClockOffsAppl,
                     "SYS / DCBS APPLIED" => SysDcbsApplied,
                     "SYS / PCVS APPLIED" => SysPcvsApplied,
                     "SYS / SCALE FACTOR" => SysScaleFactor,
                     "SYS / PHASE SHIFT" => SysPhaseShift,
                     "GLONASS SLOT / FRQ #" => GlonassSlotFrqNum,
                     "GLONASS COD/PHS/BIS" => GlonassCodPhsBis,
                     "LEAP SECONDS" => LeapSeconds,
                    "# OF SATELLITES" => NumSatellites,
                    "PRN / # OF OBS" => PrnObsTypes,
                    "END OF HEADER" => EndOfHeader)
