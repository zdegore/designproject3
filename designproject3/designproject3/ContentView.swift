//
//  ContentView.swift
//  designproject3
//
//  Created by Degore, Zachary on 11/14/22.
//

import SwiftUI
import CoreBluetooth

class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    @Published var peripheralNames: [String] = []
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
            self.peripheralNames.append(peripheral.name ?? "unnamed device")
        }
    }
}













struct ContentView: View {
    @State var selectedIndex = 0
    
    let icons = ["house","clock","pencil","lightbulb"]
    
    var body: some View {
        VStack {
            
            
            ZStack
            {
                switch selectedIndex
                {
                case 0:
                    HomeView()
                case 1:
                    ClockView()
                case 2:
                    DrawView()
                case 3:
                    LightView()
                default:
                    HomeView()
                    
                    
                }
            }
            
            Spacer()
            Divider()
            HStack
            {
                ForEach(0..<4, id: \.self)
                {
                    number in
                    Spacer()
                    Button(action: {
                        self.selectedIndex = number
                    }, label: {
                        
                        Image( systemName: icons[number])
                            .foregroundColor(selectedIndex == number ? .blue : Color(UIColor.label))
                            .font(.system(size: selectedIndex == number ? 35 : 25,
                                          weight: .regular,
                                          design: .default))
                            .padding(10)
                            
                    })
                    Spacer()
                    
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HomeView: View
{
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    var body: some View
    {
        NavigationView
        {
            VStack{
                HStack{
                    Text("Please select the bluetooth device for the display from the list below:")
                }
                ZStack
                {
                    Spacer();
                    List(bluetoothViewModel.peripheralNames, id: \.self) { peripheral in
                        Text(peripheral)
                    }
                }
                .navigationTitle("Home Screen")
            }
        }
    }
}

struct ClockView: View
{
    var body: some View
    {
        NavigationView
        {
            
            ZStack
            {
                Text("Clock")
            }
            .navigationTitle("Clock Customization")
        }
    }
}

struct DrawView: View
{
    var body: some View
    {
        NavigationView
        {
            
            ZStack
            {
                Text("Draw")
            }
            .navigationTitle("Draw Mode")
        }
    }
}

struct LightView: View
{
    var body: some View
    {
        NavigationView
        {
            
            ZStack
            {
                Text("Light")
            }
            .navigationTitle("Light Mode")
        }
    }
}
