//
//  RoundActionSheet.swift
//  MusicPlayer
//
//  Created by Vladyslav Yakovlev on 08.04.2018.
//  Copyright © 2018 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class RoundActionSheet: ActionSheet {
    
    override init() {
        super.init()
        cornerRadius = 12
        corners = [.topLeft, .topRight]
        actionCellHeight = UIProperties.actionSheetCellHeight
        font = Fonts.actionSheetFont
        addAction(Action(title: "Cancel", type: .cancel))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
