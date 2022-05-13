//
// File:       AppController.m
//
// Abstract:   The window controller that manages user events and sets up the window
//
// Version:    1.0
//
// Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc. ("Apple")
//             in consideration of your agreement to the following terms, and your use,
//             installation, modification or redistribution of this Apple software
//             constitutes acceptance of these terms.  If you do not agree with these
//             terms, please do not use, install, modify or redistribute this Apple
//             software.
//
//             In consideration of your agreement to abide by the following terms, and
//             subject to these terms, Apple grants you a personal, non - exclusive
//             license, under Apple's copyrights in this original Apple software ( the
//             "Apple Software" ), to use, reproduce, modify and redistribute the Apple
//             Software, with or without modifications, in source and / or binary forms;
//             provided that if you redistribute the Apple Software in its entirety and
//             without modifications, you must retain this notice and the following text
//             and disclaimers in all such redistributions of the Apple Software. Neither
//             the name, trademarks, service marks or logos of Apple Inc. may be used to
//             endorse or promote products derived from the Apple Software without specific
//             prior written permission from Apple.  Except as expressly stated in this
//             notice, no other rights or licenses, express or implied, are granted by
//             Apple herein, including but not limited to any patent rights that may be
//             infringed by your derivative works or by other works in which the Apple
//             Software may be incorporated.
//
//             The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
//             WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
//             WARRANTIES OF NON - INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
//             PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION
//             ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
//
//             IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
//             CONSEQUENTIAL DAMAGES ( INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//             SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//             INTERRUPTION ) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION
//             AND / OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER
//             UNDER THEORY OF CONTRACT, TORT ( INCLUDING NEGLIGENCE ), STRICT LIABILITY OR
//             OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Copyright ( C ) 2008 Apple Inc. All Rights Reserved.
//

#import <Quartz/Quartz.h>

#import "AppController.h"
#import "ExampleCALayerDelegate.h"
#import "ExampleCAOpenGLLayer.h"
#import "ExampleCATiledLayerDelegate.h"

@interface AppController()
-(void)setupCALayer;
-(void)setupCAOpenGLLayer;
@end

@implementation AppController

// Constants used by the Scroll layer to setup its contents and to scroll.
#define kScrollContentRect CGRectMake(  0.0,   0.0, 300.0, 300.0)

-(void)awakeFromNib
{
	// Setup the delegates that are used by setupCALayer, setupCAScrollLayer and setupCATiledLayer
	delegateCALayer = [[ExampleCALayerDelegate alloc] init];
	
	[self setupCALayer];
	[self setupCAOpenGLLayer];
}

-(void)dealloc
{
	[delegateCALayer release];
	[super dealloc];
}

-(void)setupCALayer
{
	exampleCALayer = [CALayer layer];
	
	// Set the layer delegate so that we have some content drawn
	exampleCALayer.delegate = delegateCALayer;
	
	// Layers start life validated (unlike views).
	// We request that the layer have its contents drawn so that it can display something.
	[exampleCALayer setNeedsDisplay];
	
	// Set the view to host the layer!
	hostCALayer.layer = exampleCALayer;
}

-(void)setupCAOpenGLLayer
{
	exampleCAOpenGLLayer = [ExampleCAOpenGLLayer layer];
	
	// Layers start life validated (unlike views).
	// We request that the layer have its contents drawn so that it can display something.
	[exampleCAOpenGLLayer setNeedsDisplay];
	
	hostCAOpenGLLayer.layer = exampleCAOpenGLLayer;
}

-(IBAction)redrawLayerContent:(id)sender
{
	// Just tell the layer to display itself and it will redraw
	[exampleCALayer setNeedsDisplay];
}

-(IBAction)toggleGLAsync:(id)sender
{
	// By turning on Async, the layer will update on its own.
	exampleCAOpenGLLayer.asynchronous = [sender state] == NSOnState;
}

-(IBAction)toggleGLDisplayOnResize:(id)sender
{
	// By turning on needsDisplayOnBoundsChange, the GLLayer will get redisplayed when it is resized, forcing the content
	// to be resized to the layer's current size automatically. With this off, the content will be resized when -display is called.
	exampleCAOpenGLLayer.needsDisplayOnBoundsChange = [sender state] == NSOnState;
}

-(IBAction)redrawGLContent:(id)sender
{
	// Just tell the layer to display itself and it will redraw
	[hostCAOpenGLLayer.layer setNeedsDisplay];
}

@end
