//
//  KingRuleView.swift
//  King
//
//  Created by Dylan Elliott on 27/10/20.
//

import SwiftUI

struct KingRuleView: View {
    @State var detailRule: CardRule?
    
    var showDetail: Bool {
        get { return detailRule != nil }
        set { detailRule = nil }
    }
    
    @Binding var showRules: Bool
    
    let rules: [CardRule]
    var body: some View {
        ZStack {
            VStack {
            ScrollView {
                VStack(spacing: 10) {

                    ForEach(rules.sorted(by: { $0 < $1 })) { rule in
                        Button(action: {
                            detailRule = rule
                        }) {
                            HStack {
                                Spacer()
                                Text(rule.card.title)
                                    .font(.headline)
                                Text(rule.rule.title)
                                Spacer()
                            }
                            .padding()
                        }
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
            }
            Button(action: { showRules = false }) {
                HStack {
                Spacer()
                Text("Cards")
                Spacer()
                }
                    .padding()
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding()
            }

            if let detailRule = detailRule {
                ZStack{
                    VStack(spacing: 20) {
                        Text(detailRule.rule.title)
                            .font(.largeTitle)
                        Text(detailRule.rule.ruleDescription)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .ignoresSafeArea()
                }
                .onTapGesture {
                    self.detailRule = nil
                }
            }
        }
    }
}
//
//struct KingRuleView_Previews: PreviewProvider {
//    static var previews: some View {
//        KingRuleView()
//    }
//}
