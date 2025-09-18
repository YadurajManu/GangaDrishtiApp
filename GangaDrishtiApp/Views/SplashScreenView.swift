import SwiftUI

struct SplashScreenView: View {
    @State private var opacity = 0.0
    @State private var scale = 0.9
    @State private var isActive = false
    @State private var dotOpacity1 = 0.3
    @State private var dotOpacity2 = 0.3
    @State private var dotOpacity3 = 0.3
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                // Background
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Logo with simple animation
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240, height: 240)
                        .opacity(opacity)
                        .scaleEffect(scale)
                    
                    // Elegant loading dots
                    HStack(spacing: 12) {
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(.gray)
                            .opacity(dotOpacity1)
                        
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(.gray)
                            .opacity(dotOpacity2)
                        
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(.gray)
                            .opacity(dotOpacity3)
                    }
                    .padding(.top, 10)
                }
            }
            .onAppear {
                // Simple fade in and subtle scale animation
                withAnimation(.easeOut(duration: 1.2)) {
                    self.opacity = 1.0
                    self.scale = 1.0
                }
                
                // Animated loading dots
                animateDots()
                
                // Navigate to main content
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    withAnimation(.easeInOut(duration: 0.7)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
    
    // Function to animate the loading dots
    func animateDots() {
        let animation = Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: true)
        
        withAnimation(animation.delay(0.0)) {
            self.dotOpacity1 = 1.0
        }
        
        withAnimation(animation.delay(0.2)) {
            self.dotOpacity2 = 1.0
        }
        
        withAnimation(animation.delay(0.4)) {
            self.dotOpacity3 = 1.0
        }
    }
}

#Preview {
    SplashScreenView()
}
