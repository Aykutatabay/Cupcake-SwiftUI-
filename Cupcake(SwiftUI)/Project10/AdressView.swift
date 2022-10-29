//
//  AdressView.swift
//  Project10
//
//  Created by Aykut ATABAY on 17.10.2022.
//

import SwiftUI



// navigation link ile diger sayfaya veri atarken zaten initilize ediyorsun o sayfada sadece turu belirtmen gerek il init edildiginde @stateoject diger sayfalara veri yolluyorsan o sayfada(veriyi yolladıgım sayfa) da observableobject kullanacaksın

struct AdressView: View {
    @ObservedObject var order: Order
    var body: some View {
        Form {
            Section {
                TextField("name", text: $order.name)
                TextField("street adress", text: $order.streetAddress)
                TextField("city", text: $order.city)
                TextField("zip", text: $order.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(!order.hasValidAddress)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AdressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AdressView(order: Order())
        }
        
    }
}


