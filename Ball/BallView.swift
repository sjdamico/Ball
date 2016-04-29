//
//  BallView.swift
//  Ball
//
//  Created by Steve D'Amico on 4/28/16.
//  Copyright © 2016 Steve D'Amico. All rights reserved.
//
/* Imports Core Motion framework and adds the property that the controller passes with an acceleration value and five properties for class implementation */

import UIKit
import CoreMotion

class BallView: UIView {
    
    // Holds the most recent acceleration value
    var acceleration = CMAcceleration(x: 0, y: 0, z: 0)
    
    // Points to the sprite that is moved around the screen
    private let image = UIImage(named: "ball")!
    
    // Holds the current position of the ball
    private var currentPoint : CGPoint = CGPointZero {
        didSet {
            var newX = currentPoint.x
            var newY = currentPoint.y
            if newX < 0 {
                newX = 0
                ballXVelocity = -(ballXVelocity / 2.0)
                
            // Check whether ball has hit the edges of the screen, if so stop its motion
            } else if newX > bounds.size.width - image.size.width {
                newX = bounds.size.width - image.size.width
                ballXVelocity = -(ballXVelocity / 2.0)
            }
            if newY < 0 {
                newY = 0
                ballYVelocity = -(ballYVelocity / 2.0)
            }
                
            // Check whether ball has hit the edges of the screen, if so stop its motion
            else if newY > bounds.size.height - image.size.height {
                newY = bounds.size.height - image.size.height
                ballYVelocity = -(ballYVelocity / 2.0)
            }
            currentPoint = CGPointMake(newX, newY)
            
            // Rectangles ensure that the old ball is erased and the new one is drawn
            let currentRect = CGRectMake(newX, newY, newX + image.size.width, newY + image.size.height)
            let prevRect = CGRectMake(oldValue.x, oldValue.y, oldValue.x + image.size.width, oldValue.y + image.size.height)
            
            // Uses the union of the two rectangles to indicate part of display to be redrawn
            setNeedsDisplayInRect(CGRectUnion(currentRect, prevRect))
        }
    }
    // Keeps track of the ball's current velocity
    private var ballXVelocity = 0.0
    private var ballYVelocity = 0.0
    
    // Set each time ball is updated and used to calculate speed changes
    private var lastUpdateTime = NSDate()
    
    /* Code to draw and move the ball around the screen. initWithCoder and initWithFrame make it possible to create the view safely from code and from a nib file */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() -> Void {
        currentPoint = CGPointMake((bounds.size.width / 2.0) + (image.size.width / 2.0), (bounds.size.height / 2.0) + (image.size.height / 2.0))
    }
    
    // Draws the ball image at the currentPoint
    override func drawRect(rect: CGRect) {
        image.drawAtPoint(currentPoint)
    }
    
    // Used to figure out the correct location of the ball and is called from the accelerometer method
    func update() -> Void {
        let now = NSDate()
        let secondsSinceLastDraw = now.timeIntervalSinceDate(lastUpdateTime)
        ballXVelocity = ballXVelocity + (acceleration.x * secondsSinceLastDraw)
        ballYVelocity = ballYVelocity - (acceleration.y * secondsSinceLastDraw)
        
        // Determining actual change in pixels
        let xDelta = secondsSinceLastDraw * ballXVelocity * 500
        let yDelta = secondsSinceLastDraw * ballYVelocity * 500
        currentPoint = CGPointMake(currentPoint.x + CGFloat(xDelta), currentPoint.y + CGFloat(yDelta))
        
        lastUpdateTime = now
    }
}
