SKSwiftTest
===========

Sample project showing how to implement the SessionM SDK into a SpriteKit based Swift language project.

Main sections to pay attention to are application:DidFinishLaunchingWithOptions in the AppDelegate.swift class. 
Here you will see how the SessionM SDK is dropped into the project and started.

SessionM.sharedInstance().delegete = self;
SessionM.sharedInstance().startSessionWithAppID("YOU_APP_ID");

GameScene.swift update function shows how to log actions and display achievements.

GameViewController.swift contains code to display a SessionM Portal button. 

For more help see http://www.sessionm.com/documentation/index.php
