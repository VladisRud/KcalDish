//
//  CopyToClipboard.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 17.10.2024.
//

import SwiftUI

struct CopyToClipboard: View {
    @State private var copied = false {
            didSet {
                if copied == true {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            copied = false
                        }
                    }
                }
            }
        }
        var body: some View {
            GeometryReader { geo in
                ZStack {
                    if copied {
                        Text("Copied to clipboard")
                            .padding()
                            .background(Color.myColorMain.cornerRadius(20))
                            .position(x: geo.frame(in: .local).width/2)
                            .position(y: geo.frame(in: .local).width/2)
                            .transition(.move(edge: .bottom))
                            .padding(.bottom)
                            .animation(Animation.easeInOut, value: 1)
                    }
                    
                    VStack {
                        Text("Copy")
                            .onTapGesture(count: 1) {
                                withAnimation {
                                    copied = true
                            }
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
}

#Preview {
    CopyToClipboard()
}
