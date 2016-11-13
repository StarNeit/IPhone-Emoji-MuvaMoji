//
//  TurtleBezierPath.swift
//  votemoji
//
//  Created by Borys on 1/6/16.
//  Copyright © 2016 Boryse. All rights reserved.
//

import UIKit
import ObjectiveC

private var bearingAssociatedKey: UInt8 = 0

extension UIBezierPath {
  var bearing: CGFloat {
    get { return objc_getAssociatedObject(self, &bearingAssociatedKey) as! CGFloat }
    set { objc_setAssociatedObject(self, &bearingAssociatedKey, newValue, (objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)) }
  }

  func home() {
    moveToPoint(CGPointZero)
    bearing = 0
  }

  func forward(distance: CGFloat) {
    addLineToPoint(toCartesian(distance, bearing: bearing, origin: currentPoint))
  }

  func leftArc(radius: CGFloat, turn angle: CGFloat) {
    arc(radius, turn: angle, clockwise: false)
  }

  func rightArc(radius: CGFloat, turn angle: CGFloat) {
    arc(radius, turn: angle, clockwise: true)
  }

  /// MARK: - Maths
  private func arc(radius: CGFloat, var turn angle: CGFloat, clockwise: Bool) {
    let radiusTurn: CGFloat = clockwise ? 90 : -90
    let cgAngleBias: CGFloat = clockwise ? 180 : 0
    angle = clockwise ? angle : -angle

    let center = toCartesian(radius, bearing: bearing + radiusTurn, origin: currentPoint)

    let cgStartAngle = cgAngleBias + bearing
    let cgEndAngle = cgAngleBias + (bearing + angle)

    bearing += angle

    addArcWithCenter(center, radius: radius, startAngle: radians(cgStartAngle), endAngle: radians(cgEndAngle), clockwise: clockwise)
  }

  private func radians(degrees: CGFloat) -> CGFloat {
    return degrees * CGFloat(M_PI) / 180
  }

  private func toCartesian(radius: CGFloat, bearing: CGFloat, origin: CGPoint) -> CGPoint {
    let bearingInRadians = radians(bearing)
    let vector = CGPoint(x: radius * CGFloat(sinf(Float(bearingInRadians))), y: -radius * CGFloat(cosf(Float(bearingInRadians))))
    return CGPoint(x: origin.x + vector.x, y: origin.y + vector.y)
  }
}
