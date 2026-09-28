//
//  DetailTab.swift
//  Mova
//
//  Created by Elchın on 25.09.26.
//


import SwiftUI

enum DetailTab: String, CaseIterable {
    case trailers = "Trailers"
    case moreLikeThis = "More Like This"
    case comments = "Comments"
}

struct DetailTabSelector: View {
    @Binding var selectedTab: DetailTab
    @Namespace private var underline

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(DetailTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 8) {
                            Text(tab.rawValue)
                                .font(.system(size: 14, weight: selectedTab == tab ? .semibold : .regular))
                                .foregroundColor(selectedTab == tab ? .red : .gray)

                            ZStack {
                                Color.clear.frame(height: 2)
                                if selectedTab == tab {
                                    Color.red
                                        .frame(height: 2)
                                        .matchedGeometryEffect(id: "underline", in: underline)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
        }
    }
}