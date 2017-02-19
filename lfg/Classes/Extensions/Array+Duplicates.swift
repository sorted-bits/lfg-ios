//
//  Array+Duplicates.swift
//  lfg
//
//  Created by Wim Haanstra on 18/02/2017.
//  Copyright © 2017 Wim Haanstra. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

	public func uniq() -> [Element] {
		var arrayCopy = self
		arrayCopy.uniqInPlace()
		return arrayCopy
	}

	mutating public func uniqInPlace() {
		var seen = [Element]()
		var index = 0
		for element in self {
			if seen.contains(element) {
				remove(at: index)
			} else {
				seen.append(element)
				index += 1
			}
		}
	}
}
