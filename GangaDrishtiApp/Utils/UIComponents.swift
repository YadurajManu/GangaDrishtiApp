//
//  UIComponents.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import SwiftUI

// MARK: - Custom Text Field
struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var showPassword: Bool = false
    var onTogglePassword: (() -> Void)?
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
            
            HStack {
                if isSecure && !showPassword {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 16))
                        .keyboardType(keyboardType)
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 16))
                        .keyboardType(keyboardType)
                }
                
                if isSecure {
                    Button(action: {
                        onTogglePassword?()
                    }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

// MARK: - Custom Button
struct CustomButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isEnabled: Bool = true
    var backgroundColor: Color = Color.blue
    var foregroundColor: Color = .white
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.8)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isEnabled ? backgroundColor : Color.gray.opacity(0.3))
            .foregroundColor(isEnabled ? foregroundColor : .gray)
            .cornerRadius(8)
        }
        .disabled(!isEnabled || isLoading)
    }
}

// MARK: - Social Login Button
struct SocialLoginButton: View {
    let title: String
    let iconName: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.system(size: 18, weight: .medium))
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

// MARK: - Google Sign-In Button (Following Google Guidelines)
struct GoogleSignInButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Google Logo
                Image("Google_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text("Continue with Google")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Toggle Button
struct ToggleButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(isSelected ? Color.blue : Color.clear)
                .cornerRadius(20)
        }
    }
}

// MARK: - Checkbox
struct Checkbox: View {
    @Binding var isChecked: Bool
    let title: String
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            HStack(spacing: 8) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? .blue : .gray)
                    .font(.system(size: 16))
                
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
            }
        }
    }
}

// MARK: - Error Message View
struct ErrorMessageView: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(.system(size: 14))
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.red)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Modern Role Selector
struct ModernRoleSelector: View {
    @Binding var selectedRole: UserRole
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Role")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
            
            VStack(spacing: 0) {
                // Selected Role Button
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text(selectedRole.displayName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Dropdown Options
                if isExpanded {
                    VStack(spacing: 0) {
                        ForEach(UserRole.allCases, id: \.self) { role in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedRole = role
                                    isExpanded = false
                                }
                            }) {
                                HStack {
                                    Text(role.displayName)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(selectedRole == role ? .blue : .black)
                                    
                                    Spacer()
                                    
                                    if selectedRole == role {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(selectedRole == role ? Color.blue.opacity(0.1) : Color.clear)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.95)),
                        removal: .opacity.combined(with: .scale(scale: 0.95))
                    ))
                }
            }
        }
    }
}
