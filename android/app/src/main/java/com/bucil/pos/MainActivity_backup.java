// package com.PesenSayur.pos;

// import android.bluetooth.BluetoothAdapter;
// import android.bluetooth.BluetoothDevice;
// import android.bluetooth.BluetoothSocket;
// import android.content.Intent;
// import android.os.Handler;
// import android.util.Log;

// import androidx.annotation.NonNull;

// import org.json.JSONObject;

// import java.io.IOException;
// import java.io.InputStream;
// import java.io.OutputStream;
// import java.nio.charset.StandardCharsets;
// import java.util.HashMap;
// import java.util.Map;
// import java.util.Set;
// import java.util.UUID;

// import io.flutter.embedding.android.FlutterActivity;
// import io.flutter.embedding.engine.FlutterEngine;
// import io.flutter.plugins.GeneratedPluginRegistrant;
// import io.flutter.plugin.common.MethodChannel;

// public class MainActivity extends FlutterActivity {
//     private String CHANNEL = "printer";

//     private BluetoothDevice bluetoothDevice = null;
//     private BluetoothDevice currentDevice = null;
//     private OutputStream outputStream = null;
//     private InputStream inputStream = null;
//     private BluetoothSocket bluetoothSocket = null;
//     private boolean stopWorker = false;
//     private String msg = "";
//     private String msgKitchen = "";

//     @Override
//     public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//     GeneratedPluginRegistrant.registerWith(flutterEngine);
//      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
//          if(call.method.equals("isBluetoothEnabled")){
//              try {
//                  if(isBluetoothEnabled()){
//                      result.success(true);
//                  }else{
//                      result.success(false);
//                  }
//              }catch (Exception ex){
//                  result.error("UNAVAILABLE", "Bluetooth is off", false);
//              }
//          }else if(call.method.equals("get_paired_devices")){
//              BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
//              Set<BluetoothDevice> pairedDevices = bluetoothAdapter.getBondedDevices();
//              Map<String, String> devices = new HashMap<>();
//     //             val devices : MutableMap<String, String> = mutableMapOf();
//              if(pairedDevices.size() > 0){
//                  for(BluetoothDevice pairedDev : pairedDevices){
//                      devices.put(pairedDev.getAddress(),pairedDev.getName());
//                  }
//                  result.success(devices);
//              }else{
//                  result.error("NO DEVICE", "No Paired Device", false);
//              }
//          }else if(call.method.equals("bluetooth_settings")) {
//              Intent intentOpenBluetoothSettings = new Intent();
//              intentOpenBluetoothSettings.setAction(android.provider.Settings.ACTION_BLUETOOTH_SETTINGS);
//              startActivity(intentOpenBluetoothSettings);
//              result.success(true);
//          } else if(call.method.equals("beginPrint")){
//              msg = call.argument("data");
//              result.success(findBluetoothDevice(call.argument("device_address")));
//          } else if(call.method.equals("beginPrintMultiple")){
//              msg = call.argument("data_invoice");
//              msgKitchen = call.argument("data_kitchen");
//              result.success(findBluetoothDeviceMultiple(call.argument("device_addresses")));
//          }else{
//              result.notImplemented();
//          }
//      });
//     }

//     private boolean isBluetoothEnabled(){
//         try {
//             BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
//             if (bluetoothAdapter == null) {
//                 Log.d("Kotlin", "No Bluetooth Adapter found");
//             }else{
//                 if (bluetoothAdapter.isEnabled()) {
//                     Intent enableBT = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
//                     startActivityForResult(enableBT, 0);
//                 }else{
//                     Log.d("Kotlin", "Bluetooth is off");
//                     return false;
//                 }
//             }
//             return true;
//         } catch (Exception ex) {
//             ex.printStackTrace();
//             return false;
//         }
//     }

//     private boolean findBluetoothDevice(String device_address){
//         try {
//             BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
//             if(!isBluetoothEnabled()){
//                 Log.d("Kotlin", "Bluetooth adapter not found or is not enabled");
//                 return false;
//             }
//             Set<BluetoothDevice> pairedDevice = bluetoothAdapter.getBondedDevices();
//             if (pairedDevice.size() > 0) {
//                 for (BluetoothDevice pairedDev : pairedDevice) {
//                     if(pairedDev.getAddress().equals(device_address)){
//                         this.bluetoothDevice = pairedDev;
// //                        this.currentDevice = pairedDev;
// //                        if(currentDevice == null){
// //                            this.currentDevice = pairedDev;
// //                        }
//                         Log.d("Kotlin", "Bluetooth Printer Attached: " + pairedDev.getName());
//                         break;
//                     }
//                 }
//             }
//             Log.d("Kotlin", "Bluetooth Printer Attached");
//             if (!openBluetoothPrinter()){
//                 return false;
//             }
//             printData(msg + "\n");
// //            disconnectBT()
//             Log.d("Kotlin", "Success print");
//             return true;
//         } catch (Exception ex) {
//             ex.printStackTrace();
//             Log.d("Kotlin", "Bluetooth device not found");
//             return false;
//         }
//     }

//     private boolean findBluetoothDeviceMultiple(String device_addresses){
//         try {
//             BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
//             if(!isBluetoothEnabled()){
//                 Log.d("Java", "Bluetooth adapter not found or is not enabled");
//                 return false;
//             }
//             Set<BluetoothDevice> pairedDevice = bluetoothAdapter.getBondedDevices();
//             if (pairedDevice.size() > 0) {
//                 JSONObject jsonObject = new JSONObject(device_addresses);
//                 JSONObject newJSON = jsonObject.getJSONObject("printerId");
//                 System.out.println(newJSON.toString());
// //                jsonObject = new JSONObject(newJSON.toString());
// //                System.out.println(jsonObject.getString("rcv"));
// //                for (BluetoothDevice pairedDev : pairedDevice) {
// //                    if(pairedDev.getAddress().equals(device_addresses)){
// //                        this.bluetoothDevice = pairedDev;
// //                        Log.d("Java", "Bluetooth Device Name: " + pairedDev.getName());
// //                        if (!openBluetoothPrinter()){
// //                            return false;
// //                        }
// //                    }
// //                }
//             }
// //            if (!openBluetoothPrinter()){
// //                return false;
// //            }
//             printData(msg + "\n");
//             Log.d("Java", "Success print");
//             return true;
//         } catch (Exception ex) {
//             ex.printStackTrace();
//             Log.d("Java", "Bluetooth device not found");
//             return false;
//         }
//     }
// //    @Throws(IOException::class)
//     private boolean openBluetoothPrinter() {
//         boolean success = false;
//         try
//         {
//             //Standard uuid from string //
//             Log.d("Kotlin", "Opening bluetooth");
//             UUID uuidString = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb"); //Standard SerialPortService ID
//             if(currentDevice == null || currentDevice != bluetoothDevice){
//                 if(bluetoothSocket != null && bluetoothSocket.isConnected()){
//                     bluetoothSocket.close();
//                 }
//                 bluetoothSocket = null;
//                 currentDevice = bluetoothDevice;
//             }
//             if(bluetoothSocket == null || !bluetoothSocket.isConnected()) {
//                 try{
//                     Log.d("Java", "socket is not yet connected");
//                     Log.d("Java", "is socket null: " + (bluetoothSocket == null));
// //                    Log.d("Java", "is socket connected: " + bluetoothSocket.isConnected());
//                     bluetoothSocket = currentDevice.createRfcommSocketToServiceRecord(uuidString);
//                     bluetoothSocket.connect();
//                 }catch(IOException e){
// //                    bluetoothSocket = new FallbackBluetoothSocket(bluetoothSocket.getUnderlyingSocket());
// //                    Thread.sleep(500);
// //                    bluetoothSocket.connect();
// //                    success = true;
//                     try {
//                         Log.e("","trying fallback...");
//                         bluetoothSocket =(BluetoothSocket) currentDevice.getClass().getMethod("createRfcommSocket", int.class).invoke(currentDevice,1);
//                         bluetoothSocket.connect();
//                         Log.e("","Connected");
//                     }
//                     catch (Exception e2) {
//                         Log.e("", "Couldn't establish Bluetooth connection!");
//                         return false;
//                     }
//                 }
//             }
//             outputStream = bluetoothSocket.getOutputStream();
//             Log.d("Kotlin", "outputstream is assigned");
//             inputStream = bluetoothSocket.getInputStream();
//             Log.d("Kotlin", "inputstream is assigned");
//             beginListenData();
//             return true;
//         }
//         catch (Exception ex) {
//             ex.printStackTrace();
//             Log.d("Kotlin", "Open bluetooth failed " + ex.getMessage());
//             return false;
//         }
//     }

//     int readBufferPosition = 0;
//     private void beginListenData() {
//         try
//         {
//             Log.d("Kotlin", "listening data...");
//             Handler handler = new Handler();
//             byte delimiter = 10;
//             stopWorker = false;
// //            int readBufferPosition = 0;
//             byte[] readBuffer = new byte[1024];
//             Thread thread = new Thread(() -> {
//                 while (!Thread.currentThread().isInterrupted() && !stopWorker) {
//                     try {
//                         int byteAvailable = inputStream.available();
//                         if (byteAvailable > 0) {
//                             byte[] packetByte = new byte[byteAvailable];
//                             inputStream.read(packetByte);
//                             for (int i = 0; i < byteAvailable;i++) {
//                                 byte b = packetByte[i];
//                                 if (b == delimiter) {
//                                     byte[] encodedByte = new byte[readBufferPosition];
//                                     System.arraycopy(
//                                             readBuffer, 0,
//                                             encodedByte, 0,
//                                             encodedByte.length
//                                     );
// //                                    val data = String(encodedByte, "US-ASCII")
//                                     String data = new String(encodedByte, StandardCharsets.US_ASCII);
//                                     readBufferPosition = 0;
//                                     handler.post(() -> {
//                                         Log.d("Kotlin", "Data: " + data);
//                                     });
//                                 } else {
//                                     readBuffer[readBufferPosition++] = b;
//                                 }
//                             }
//                         }
//                     } catch (Exception ex) {
//                         stopWorker = true;
//                     }
//                 }
//             });
// //            Thread thread = Thread(Runnable {
// //            while (!Thread.currentThread().isInterrupted && !stopWorker) {
// //                try {
// //                    val byteAvailable = inputStream?.available()
// //                    if (byteAvailable!! > 0) {
// //                        val packetByte = ByteArray(byteAvailable)
// //                        inputStream?.read(packetByte)
// //                        for (i in 0 until byteAvailable) {
// //                            val b = packetByte[i]
// //                            if (b == delimiter) {
// //                                byte[] encodedByte = readBufferPosition.getBytes();
// //                                System.arraycopy(
// //                                        readBuffer, 0,
// //                                        encodedByte, 0,
// //                                        encodedByte.size
// //                                )
// ////                                    val data = String(encodedByte, "US-ASCII")
// //                                val data = String(encodedByte, Charset.forName("us-ascii"))
// //                                readBufferPosition = 0
// //                                handler.post { Log.d("Kotlin", "Data: $data") }
// //                            } else {
// //                                readBuffer[readBufferPosition++] = b
// //                            }
// //                        }
// //                    }
// //                } catch (ex:Exception) {
// //                    stopWorker = true
// //                }
// //            }
// //        })
//             thread.start();
//         }
//         catch (Exception ex) {
//             ex.printStackTrace();
//             Log.d("Kotlin", "Listen data failed");
//         }
//     }

// //    @Throws(IOException::class)
//     void printData(String msg) {
//         try
//         {
// //            msg = "test print"
// //            msg += "\n"
//             outputStream.write(msg.getBytes());
//             Log.d("Kotlin", "Printing text...");
// //            disconnectBT();
//         }
//         catch (Exception ex) {
//             ex.printStackTrace();
//             Log.d("Java", "Print data failed");
//             Log.d("Java", msg);
//         }
//     }
//     // Disconnect Printer //
// //    @Throws(IOException::class)
//     private void disconnectBT() {
//         try
//         {
//             stopWorker = true;
//             outputStream.close();
//             inputStream.close();
//             // bluetoothSocket?.close()
//             Log.d("Kotlin", "Printer disconnected");
//         }
//         catch (Exception ex) {
//             ex.printStackTrace();
//             Log.d("Kotlin", "Disconnecting failed");
//         }
//     }
// }