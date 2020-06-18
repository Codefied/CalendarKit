#if os(iOS)
import Foundation
import UIKit

public final class EventLayoutAttributes: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self.descriptor))
  }

  public static func == (lhs: EventLayoutAttributes, rhs: EventLayoutAttributes) -> Bool {
    return lhs.descriptor === rhs.descriptor
  }
  
  public let descriptor: EventDescriptor
  public var frame = CGRect.zero

  public init(_ descriptor: EventDescriptor) {
    self.descriptor = descriptor
  }
}
#endif
