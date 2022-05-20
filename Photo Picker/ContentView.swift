import SwiftUI

struct ToastModifier: ViewModifier{
    @Binding var isShowing: Bool
    let duration: TimeInterval
    
    func body(content: Content) -> some View {
        ZStack{
            content
            if isShowing{
                toast
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration){
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
            }
        }
    }
    var toast: some View{
        VStack{
            Spacer()
            HStack{
                Text("Post saved successfully!")
                    .font(.footnote)
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .shadow(radius: 5)
            
        }
        .padding()
        
    }
}
extension View{
    func toast(isShowing: Binding<Bool>, duration: TimeInterval = 3) -> some
        View{
        modifier(ToastModifier(isShowing: isShowing, duration: duration))
    }
}
