//
//  Node.swift
//  Vlow
//
//  Created by Joseph Constantakis on 12/28/14.
//
//

import Foundation

public class Node: Printable {
    
    public let name: String = "empty"
    public let outs: [Node] = []
    
    public convenience init() {
        self.init(name: "empty", outLinks: [])
    }
    
    public convenience init(_ n: String) {
        self.init(name: n, outLinks: Array<Node>())
    }
    
    public init(name n: String, outLinks: [Node]) {
        name = n
        outs = outLinks
    }
    
    public var description: String {
        return name + " outs: " + ", ".join(outs.map{$0.name})
    }
}

infix operator ~~> {associativity left precedence 200}
public func ~~> (left: Node, right: Node) -> Node {
    let outs = left.outs.map {(n: Node) -> Node in
        return (n.outs.count == 0) ? Node(name: n.name, outLinks: [right])
                                   : (n ~~> right)
    }
    return Node(name: left.name, outLinks: outs)
}

public func InputNode() -> Node {
    return Node("adc~")
}

public func OutputNode() -> Node {
    return Node("dac~")
}
