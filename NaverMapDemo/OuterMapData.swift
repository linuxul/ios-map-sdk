//
//  JinJuMapDataOuter.swift
//  NaverMapDemo
//
//  Created by jsseo on 9/25/24.
//  Copyright © 2024 NaverCorp. All rights reserved.
//

import Foundation

import Foundation
import NMapsMap

struct JinJuMapData {
    
    // 북한을 포함한 한반도의 대략적인 경계 좌표 (서쪽부터 시계방향으로)
    static let outerCoordinates = [
        (44.35, 122.37), // 북한 북서쪽 끝 (중국과의 국경)
        (44.35, 132), // 북한 북동쪽 끝 (러시아와의 국경)
        (31.43, 132), // 남한 남동쪽 끝 (동해)
        (31.43, 122.37), // 남한 남서쪽 끝 (서해)
        (44.35, 122.37)  // 북한 북서쪽 끝
    ]
    
}
