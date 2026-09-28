//
//  NotificationSettingsView.swift
//  Mova
//
//  Created by Elchın on 22.09.26.
//


import SwiftUI
import UIKit

struct NotificationSettingsView: View {
    @StateObject private var notificationManager = NotificationManager()

    var body: some View {
        List {
            Section {
                Toggle("Bildirişlərə icazə ver", isOn: Binding(
                    get: { notificationManager.isAuthorized },
                    set: { newValue in
                        if newValue {
                            Task { await notificationManager.requestAuthorization() }
                        } else {
                            openSystemSettings()
                        }
                    }
                ))
            } footer: {
                Text("Bildirişləri söndürmək üçün cihazın Tənzimləmələr bölməsinə keçməlisən — iOS bunu tətbiqin özündən söndürməyə icazə vermir.")
            }

            Section {
                Button("Test bildirişi göndər (5 saniyə sonra)") {
                    notificationManager.scheduleTestNotification()
                }
                .disabled(!notificationManager.isAuthorized)
            }
        }
        .navigationTitle("Notification")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await notificationManager.checkAuthorizationStatus()
        }
    }

    private func openSystemSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationStack {
        NotificationSettingsView()
    }
}