import SwiftUI

struct LoginView: View {
    @State var showingSignUpSheet = false
    @State var showingLoginSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        // Fixed Header
                        Section(header: NewspaperHeader(
                            title: "THE SODA GAZETTE",
                            subtitle: "ESTABLISHED 2025 • VOL. I",
                            topSafeArea: geometry.safeAreaInsets.top
                        )) {
                            VStack(spacing: 20) {
                                // Hero Section
                                VStack(spacing: 8) {
                                    Text("A RETURN TO REASON")
                                        .font(.newspaperHeadlineXL)
                                        .foregroundColor(Color.ink.primary)
                                        .multilineTextAlignment(.center)
                                    
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("I")
                                            .font(.system(size: 80, weight: .black, design: .serif))
                                            .foregroundColor(Color.ink.primary)
                                            .frame(height: 60) // Adjust to align visually
                                            .padding(.top, -10) // Fine tune top alignment
                                        
                                        VStack(alignment: .leading, spacing: 16) {
                                            Text("t has come to the attention of this Publication that a profound shift is occurring in the manner of professional discourse. The clamour of the modern marketplace has drowned out the voice of Reason. We hereby propose a Return to First Principles. By establishing a direct line of correspondence between the Scholar and the Inquirer, we restore the dignity of Consultation.")
                                                .font(.newspaperBody)
                                                .foregroundColor(Color.ink.secondary)
                                                .multilineTextAlignment(.leading)
                                                .lineSpacing(4)
                                            
                                            Text("In an age where speed is often mistaken for efficiency, we choose to walk a different path. We believe that the most enduring solutions are born of patience, contemplation, and a deep respect for the accumulated wisdom of the ages. This Gazette stands as a bulwark against the ephemeral, a testament to the enduring power of the written word and the considered thought.")
                                                .font(.newspaperBody)
                                                .foregroundColor(Color.ink.secondary)
                                                .multilineTextAlignment(.leading)
                                                .lineSpacing(4)
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                }
                                .padding(.top, 12)
                                
                                Divider()
                                    .background(Color.ink.primary)
                                
                                // Spacer for bottom bar clearance
                                Color.clear.frame(height: 140)
                            }
                        }
                    }
                }
                .ignoresSafeArea(.container, edges: .top)
                
                // Fixed Bottom Action Bar
                VStack {
                    Spacer()
                    VStack(spacing: 0) {
                        Divider()
                            .background(Color.ink.tertiary)
                        
                        VStack(spacing: 16) {
                            HStack(spacing: 24) {
                                // Signup Button (Left)
                                Button("APPLY") {
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                    showingSignUpSheet = true
                                }
                                .buttonStyle(NewspaperButtonStyle(isUrgent: true))
                                .frame(maxWidth: .infinity)
                                
                                // Login Button (Right)
                                Button("ENTER") {
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                    showingLoginSheet = true
                                }
                                .buttonStyle(NewspaperButtonStyle(isUrgent: false))
                                .frame(maxWidth: .infinity)
                            }
                            
                            Text("LONDON • NEW YORK • TOKYO")
                                .font(.newspaperFinePrint)
                                .foregroundColor(Color.ink.secondary)
                        }
                        .padding(24)
                        .background(Color.paper.light)
                    }
                }
            }
        }
        .sheet(isPresented: $showingSignUpSheet) {
            SignUpView(isPresented: $showingSignUpSheet)
        }
        .sheet(isPresented: $showingLoginSheet) {
            LoginSheetView(isPresented: $showingLoginSheet)
        }
    }
}

#Preview {
    LoginView()
}
