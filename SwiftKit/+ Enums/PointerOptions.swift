import Foundation

public enum PointerOptions: Int {
    case StrongMemory = 0
    case OpaqueMemory = 2
    case MallocMemory = 3
    case MachVirtualMemory = 4
    case WeakMemory = 5
    case OpaquePersonality = 256
    case ObjectPointerPersonality = 512
    case CStringPersonality = 768
    case StructPersonality = 1024
    case IntegerPersonality = 1280
    case CopyIn = 65536
}
