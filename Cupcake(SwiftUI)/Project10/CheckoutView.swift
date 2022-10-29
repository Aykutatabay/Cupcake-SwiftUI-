//
//  CheckoutView.swift
//  Project10
//
//  Created by Aykut ATABAY on 17.10.2022.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation: Bool = false
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { img in
                    img
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 233)
                
                Text("Your total cost is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                Button("Place order", action: {
                    Task {
                        await placeOrder()
                    }
                    
                    // button senkron calısıyor ondan dolayı async hata veriyor awaitise senkron calısına kadar bekletiyor fonksiyonu
                    
                })
                    .padding()
            }
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you", isPresented: $showingConfirmation) {
            Button("Ok") { }
        } message: {
            Text(confirmationMessage)
        }
    }
    
    
    func placeOrder() async {
        
        //create url (1)
        //fetch the data(2)
        // decode the data (3)
        
        
        // hey if this process take time, continue rest of the job dont wait the this func
        // here we convert our Order object into json data that can be sent over the network
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        // we are saying ı wan to write post information, information has type(content - type) of application/json
        //burada ben objemi json formatında encode ettim ve api üzerinden post ettim post ettiğim seyi do catch içerisinde geri getireceğim
        // do catch içerisinde de bu apiden aldıgım cevabı işliyorum ve decode ediyorum
        // internet uzerinden yurtulen islemlerde do try catch kullan intenret kesintisi vb durumlarda crash olmaması için
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded) // burada datayı istedik
            // handle the result
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            // burada da yukarıda upload olan response(datayı) json formatında decode ediyoruz
            confirmationMessage = "Your order for \(decodedOrder.quantity)x\(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way"
            
            showingConfirmation = true
            
        } catch {
            print("checkout failed")
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckoutView(order: Order())
        }
        
    }
}
