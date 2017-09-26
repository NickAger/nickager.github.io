---
title: "Typesafe storyboards"
date: 2017-09-20
tags: [Swift, C++]
layout: post
---

Give motivating example eg if let as? blah blah 


enum MainStoryboard: String {
    static let instance = UIStoryboard(name: "Main", bundle: nil)
    private var instance: UIStoryboard {
        return type(of: self).instance
    }
    
    func instantiateViewController<VC: UIViewController>() -> VC {
        let vc = instance.instantiateViewController(withIdentifier: self.rawValue)
        guard let typedVC = vc as? VC else {
            fatalError("View controller for identifier '\(self.rawValue)' is wrong type - expected: \(VC.self), actual: \(type(of: vc))")
        }
        return typedVC
    }
    
    case mainMenuNav = "mainMenuNav"
    case pickResultsSetTableViewController = "PickResultsSetTableViewController"
}