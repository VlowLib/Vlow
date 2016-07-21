//  Copyright © 2016 Joseph Constantakis. All rights reserved.

import Foundation

public func VLO(name: String) -> VlowNode {
  return VlowNode(name)
}

public func VlowIn() -> VlowNode {
  return VLO("vlowin")
}

public func VlowOut() -> VlowNode {
  return VLO("vlowout")
}
