//
//  AvatarView.swift
//  Proovit

import SwiftUI

struct AvatarView: View {
    let initials: String
    var size: CGFloat = 44

    var body: some View {
        Text(initials)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: size, height: size)
            .background(.green)
            .clipShape(Circle())
    }
}

#Preview {
    AvatarView(initials: "RK", size: 64)
}
