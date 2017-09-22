//
//  ViewController.swift
//  osx_ping
//
//  Created by leslie on 11/5/16.
//  Copyright © 2016 tienon. All rights reserved.
//

import Cocoa

class MainWindow: NSWindow {
	override init(contentRect: NSRect, styleMask style: NSWindowStyleMask,
		backing bufferingType: NSBackingStoreType, defer flag: Bool) {
		super.init(contentRect: contentRect, styleMask: style,
		           backing: bufferingType, defer: flag)
		self.isMovableByWindowBackground = true
		self.backgroundColor = NSColor.white
		/*
		self.contentView?.wantsLayer = true
		self.contentView?.layer?.masksToBounds = true
		self.contentView?.layer?.cornerRadius = 5
		*/
		//self.center()
	}
}

class CustomView: NSView {
	/*
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.wantsLayer = true
		self.layer?.masksToBounds = true
		self.layer?.cornerRadius = 5
		self.layer?.borderWidth = 5
		self.layer?.borderColor = CGColor(red:
			180, green: 180, blue: 180, alpha: 1)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	*/
}

class MainViewController: NSViewController {
	@IBOutlet weak var server_label_1: NSTextField!// server ip
	@IBOutlet weak var server_label_2: NSTextField!
	@IBOutlet weak var server_label_3: NSTextField!
	@IBOutlet weak var server_label_4: NSTextField!
	@IBOutlet weak var server_label_5: NSTextField!
	@IBOutlet weak var server_label_6: NSTextField!
	@IBOutlet weak var line_label_1: NSTextField!// Line
	@IBOutlet weak var line_label_2: NSTextField!
	@IBOutlet weak var line_label_3: NSTextField!
	@IBOutlet weak var line_label_4: NSTextField!
	@IBOutlet weak var line_label_5: NSTextField!
	@IBOutlet weak var line_label_6: NSTextField!
	@IBOutlet weak var textField_1: NSTextField!// Delay
	@IBOutlet weak var textField_2: NSTextField!
	@IBOutlet weak var textField_3: NSTextField!
	@IBOutlet weak var textField_4: NSTextField!
	@IBOutlet weak var textField_5: NSTextField!
	@IBOutlet weak var textField_6: NSTextField!
	@IBOutlet weak var count_1_label: NSTextField!// Loss
	@IBOutlet weak var count_2_label: NSTextField!
	@IBOutlet weak var count_3_label: NSTextField!
	@IBOutlet weak var count_4_label: NSTextField!
	@IBOutlet weak var count_5_label: NSTextField!
	@IBOutlet weak var count_6_label: NSTextField!
	@IBOutlet weak var count_count_1_label: NSTextField!// Loss/All
	@IBOutlet weak var count_count_2_label: NSTextField!
	@IBOutlet weak var count_count_3_label: NSTextField!
	@IBOutlet weak var count_count_4_label: NSTextField!
	@IBOutlet weak var count_count_5_label: NSTextField!
	@IBOutlet weak var count_count_6_label: NSTextField!
	
	let version_string = "Version 0.12   leslie"
	
	var count_1:Double = 0
	var count_2:Double = 0
	var count_3:Double = 0
	var count_4:Double = 0
	var count_5:Double = 0
	var count_6:Double = 0
	var count_ping:Double = 0
	
	var timer:Timer = Timer()
	var refreshTimer:Timer = Timer()
	var clearTimer:Timer = Timer()
	var clearTime = Int(Date().timeIntervalSince1970)
	
	/*
	"13.78.123.28"   azure
	"104.44.226.254" 加速群里给的一个韩国ip
	"23.94.228.141 "#折扣# virMach $14/年 KVM1核512M15G1T1Gbps洛杉矶
	"45.32.255.81" fastss.ml vultr
	"103.68.223.97" 新加坡机器, 丢包太高已启用
	"104.224.139.55" 原先搬瓦工的机器, 资源太少
	"104.156.231.39" vultr 硅谷节点
	"103.88.46.1" bbtec
	"37.252.228.11" JP bbtec
	*/
	
	let server_ip_1 = "103.42.212.162"
	let server_ip_2 = "47.89.38.47"
	let server_ip_3 = "103.88.45.1"
	let server_ip_4 = "45.76.70.196"
	let server_ip_5 = "103.82.5.171"
	let server_ip_6 = "185.199.225.67"
	
	let line_ip_1 = "pccw HK"
	let line_ip_2 = "CN2  HK"
	let line_ip_3 = "bbtec JP"
	let line_ip_4 = "vultr L.A."
	let line_ip_5 = "CN2 L.A."
	let line_ip_6 = "Chicago"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configUI()
		//模拟点击(启动/清空)
		click_all(NSButton())
	}
	
	
	func configUI() {
		
		/* 设置边框没搞定 对view属性的修改没产生作用
		self.view.wantsLayer = true
		self.view.layer?.masksToBounds = true
		self.view.layer?.cornerRadius = 5
		*/
		self.view.removeFromSuperview()
		
		server_label_1.stringValue = server_ip_1
		server_label_2.stringValue = server_ip_2
		server_label_3.stringValue = server_ip_3
		server_label_4.stringValue = server_ip_4
		server_label_5.stringValue = server_ip_5
		server_label_6.stringValue = server_ip_6
		
		line_label_1.stringValue = line_ip_1
		line_label_2.stringValue = line_ip_2
		line_label_3.stringValue = line_ip_3
		line_label_4.stringValue = line_ip_4
		line_label_5.stringValue = line_ip_5
		line_label_6.stringValue = line_ip_6
	}

	override var representedObject: Any? {
		didSet {
		}
	}
	
	@IBAction func close(_ sender: NSButton) {
		NSApplication.shared().hide(self)
	}
	
	@IBAction func miniaturize(_ sender: NSButton) {
		self.view.window?.miniaturize(self)
	}
	
	@IBAction func zoom(_ sender: NSButton) {
	}
	
	@IBAction func click_all(_ sender: NSButton) {
		if self.timer.isValid {
			self.count_1 = 0
			self.count_2 = 0
			self.count_3 = 0
			self.count_4 = 0
			self.count_5 = 0
			self.count_6 = 0
			self.count_ping = 0
			self.count_1_label.stringValue = "__"
			self.count_2_label.stringValue = "__"
			self.count_3_label.stringValue = "__"
			self.count_4_label.stringValue = "__"
			self.count_5_label.stringValue = "__"
			self.count_6_label.stringValue = "__"
			self.count_count_1_label.stringValue = "__"
			self.count_count_2_label.stringValue = "__"
			self.count_count_3_label.stringValue = "__"
			self.count_count_4_label.stringValue = "__"
			self.count_count_5_label.stringValue = "__"
			self.count_count_6_label.stringValue = "__"
			
			//修复定时器与清空label时间不一致的问题
			self.timer.invalidate()
			self.refreshTimer.invalidate()
			self.clearTimer.invalidate()
			if !self.timer.isValid {
				print("timer invalidate.")
			}
		}
		weak var me = self
		self.timer = Timer.scheduledTimer(withTimeInterval:
			1.0, repeats: true, block: {timer in
			if me != nil {
				DispatchQueue.main.async(execute: {
					me!.count_ping += 1
				})
				DispatchQueue.global().async(execute: {
					me!.click_1(NSButton())
				})
				DispatchQueue.global().async(execute: {
					me!.click_2(NSButton())
				})
				DispatchQueue.global().async(execute: {
					me!.click_3(NSButton())
				})
				DispatchQueue.global().async(execute: {
					me!.click_4(NSButton())
				})
				DispatchQueue.global().async(execute: {
					me!.click_5(NSButton())
				})
				DispatchQueue.global().async(execute: {
					me!.click_6(NSButton())
				})
			}
		})
		self.refreshTimer = Timer.scheduledTimer(withTimeInterval:
			10.0, repeats: true, block: {timer in
			if me != nil {
				DispatchQueue.global().async(execute: {
					if me!.count_ping == 0 {
						return
					}
					let localClearTime = Int(Date().timeIntervalSince1970)
					if (localClearTime - me!.clearTime) >= 1800 {
						DispatchQueue.main.async {
							me!.click_all(NSButton())
							return
						}}
					me!.clearTime = localClearTime
					
					let lost1 = Int(me!.count_1/me!.count_ping*100)
					let lost2 = Int(me!.count_2/me!.count_ping*100)
					let lost3 = Int(me!.count_3/me!.count_ping*100)
					let lost4 = Int(me!.count_4/me!.count_ping*100)
					let lost5 = Int(me!.count_5/me!.count_ping*100)
					let lost6 = Int(me!.count_6/me!.count_ping*100)
					
					DispatchQueue.main.async {
					me!.count_1_label.stringValue = "\(lost1)%"
					me!.count_2_label.stringValue = "\(lost2)%"
					me!.count_3_label.stringValue = "\(lost3)%"
					me!.count_4_label.stringValue = "\(lost4)%"
					me!.count_5_label.stringValue = "\(lost5)%"
					me!.count_6_label.stringValue = "\(lost6)%"
					
					me!.count_count_1_label.stringValue =
					"\(Int(me!.count_1))/\(Int(me!.count_ping))"
					me!.count_count_2_label.stringValue =
					"\(Int(me!.count_2))/\(Int(me!.count_ping))"
					me!.count_count_3_label.stringValue =
					"\(Int(me!.count_3))/\(Int(me!.count_ping))"
					me!.count_count_4_label.stringValue =
					"\(Int(me!.count_4))/\(Int(me!.count_ping))"
					me!.count_count_5_label.stringValue =
					"\(Int(me!.count_5))/\(Int(me!.count_ping))"
					me!.count_count_6_label.stringValue =
					"\(Int(me!.count_6))/\(Int(me!.count_ping))"
					
					//let array = [me!.count_1, me!.count_2, me!.count_3,
					//             me!.count_4, me!.count_5]
					let array = [lost1,lost2,lost3,lost4,lost5,lost6]
					let sortedArray = array.sorted()
					print(sortedArray)
					if let first = sortedArray.first {
						if let last = sortedArray.last {
							if first == lost1 {
								me!.count_1_label.textColor = NSColor.black
								me!.count_count_1_label.textColor = NSColor.black
							} else if last == lost1 {
								me!.count_1_label.textColor = NSColor.red
								me!.count_count_1_label.textColor = NSColor.red
							} else {
								me!.count_1_label.textColor = NSColor.lightGray
								me!.count_count_1_label.textColor = NSColor.lightGray
							}
							
							if first == lost2 {
								me!.count_2_label.textColor = NSColor.black
								me!.count_count_2_label.textColor = NSColor.black
							} else if last == lost2 {
								me!.count_2_label.textColor = NSColor.red
								me!.count_count_2_label.textColor = NSColor.red
							} else {
								me!.count_2_label.textColor = NSColor.lightGray
								me!.count_count_2_label.textColor = NSColor.lightGray
							}
							
							if first == lost3 {
								me!.count_3_label.textColor = NSColor.black
								me!.count_count_3_label.textColor = NSColor.black
							} else if last == lost3 {
								me!.count_3_label.textColor = NSColor.red
								me!.count_count_3_label.textColor = NSColor.red
							} else {
								me!.count_3_label.textColor = NSColor.lightGray
								me!.count_count_3_label.textColor = NSColor.lightGray
							}
							
							if first == lost4 {
								me!.count_4_label.textColor = NSColor.black
								me!.count_count_4_label.textColor = NSColor.black
							} else if last == lost4 {
								me!.count_4_label.textColor = NSColor.red
								me!.count_count_4_label.textColor = NSColor.red
							} else {
								me!.count_4_label.textColor = NSColor.lightGray
								me!.count_count_4_label.textColor = NSColor.lightGray
							}
							
							if first == lost5 {
								me!.count_5_label.textColor = NSColor.black
								me!.count_count_5_label.textColor = NSColor.black
							} else if last == lost5 {
								me!.count_5_label.textColor = NSColor.red
								me!.count_count_5_label.textColor = NSColor.red
							} else {
								me!.count_5_label.textColor = NSColor.lightGray
								me!.count_count_5_label.textColor = NSColor.lightGray
							}
							
							if first == lost6 {
								me!.count_6_label.textColor = NSColor.black
								me!.count_count_6_label.textColor = NSColor.black
							} else if last == lost6 {
								me!.count_6_label.textColor = NSColor.red
								me!.count_count_6_label.textColor = NSColor.red
							} else {
								me!.count_6_label.textColor = NSColor.lightGray
								me!.count_count_6_label.textColor = NSColor.lightGray
							}
						}
					}}
				})
			}
		})
		self.clearTimer = Timer.scheduledTimer(withTimeInterval:
			60.0*60, repeats: true, block: {timer in
			if me != nil {
				DispatchQueue.main.async(execute: {
					me!.click_all(NSButton())
				})
			}
		})
	}
	
	@IBAction func cancel_click(_ sender: NSButton) {
	}

	@IBAction func click_1(_ sender: NSButton) {
		let task = Process()
		let pipe = Pipe()
		task.standardOutput = pipe
		task.launchPath = "/bin/sh"
		task.arguments = ["-c","ping -c 1 \(server_ip_1)|grep time|awk -F '=' '{print $4}'"]
		
		let file = pipe.fileHandleForReading
		task.launch()
		DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()
			+ DispatchTimeInterval.milliseconds(500) , execute: DispatchWorkItem {
			if task.isRunning { task.terminate() } })
		task.waitUntilExit()
		
		let data = file.readDataToEndOfFile()
		let output = NSString(data: data, encoding:
			String.Encoding.utf8.rawValue) as! String
		weak var me = self
		DispatchQueue.main.async {
			if me != nil {
				if output == "" {
					me!.count_1 += 1
					if me!.count_ping != 0 {
						let lost = Int(me!.count_1/me!.count_ping*100)
						me!.count_1_label.stringValue = "\(lost)%"
						me!.textField_1.textColor = NSColor.red
					}
				} else {
					me!.textField_1.textColor = NSColor.black
					me!.textField_1.stringValue = output
				}
			}
		}
	}
	
	@IBAction func click_2(_ sender: NSButton) {
		let task = Process()
		let pipe = Pipe()
		task.standardOutput = pipe
		task.launchPath = "/bin/sh"
		task.arguments = ["-c","ping -c 1 \(server_ip_2)|grep time|awk -F '=' '{print $4}'"]
		
		let file = pipe.fileHandleForReading
		task.launch()
		DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()
			+ DispatchTimeInterval.milliseconds(500) , execute: DispatchWorkItem {
			if task.isRunning { task.terminate() } })
		task.waitUntilExit()
		
		let data = file.readDataToEndOfFile()
		let output = NSString(data: data, encoding:
			String.Encoding.utf8.rawValue) as! String
		weak var me = self
		DispatchQueue.main.async {
			if me != nil {
				if output == "" {
					me!.count_2 += 1
					if me!.count_ping != 0 {
						let lost = Int(me!.count_2/me!.count_ping*100)
						me!.count_2_label.stringValue = "\(lost)%"
						me!.textField_2.textColor = NSColor.red
					}
				} else {
					me!.textField_2.textColor = NSColor.black
					me!.textField_2.stringValue = output
				}
			}
		}
	}
	
	@IBAction func click_3(_ sender: NSButton) {
		let task = Process()
		let pipe = Pipe()
		task.standardOutput = pipe
		task.launchPath = "/bin/sh"
		task.arguments = ["-c","ping -c 1 \(server_ip_3)|grep time|awk -F '=' '{print $4}'"]
		
		let file = pipe.fileHandleForReading
		task.launch()
		DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()
			+ DispatchTimeInterval.milliseconds(500) , execute: DispatchWorkItem {
			if task.isRunning { task.terminate() } })
		task.waitUntilExit()
		
		let data = file.readDataToEndOfFile()
		let output = NSString(data: data, encoding:
			String.Encoding.utf8.rawValue) as! String
		weak var me = self
		DispatchQueue.main.async {
			if me != nil {
				if output == "" {
					me!.count_3 += 1
					if me!.count_ping != 0 {
						let lost = Int(me!.count_3/me!.count_ping*100)
						me!.count_3_label.stringValue = "\(lost)%"
						me!.textField_3.textColor = NSColor.red
					}
				} else {
					me!.textField_3.textColor = NSColor.black
					me!.textField_3.stringValue = output
				}
			}
		}
	}
	
	@IBAction func click_4(_ sender: NSButton) {
		let task = Process()
		let pipe = Pipe()
		task.standardOutput = pipe
		task.launchPath = "/bin/sh"
		task.arguments = ["-c","ping -c 1 \(server_ip_4)|grep time|awk -F '=' '{print $4}'"]
		
		let file = pipe.fileHandleForReading
		task.launch()
		DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()
			+ DispatchTimeInterval.milliseconds(500) , execute: DispatchWorkItem {
			if task.isRunning { task.terminate() } })
		task.waitUntilExit()
		
		let data = file.readDataToEndOfFile()
		let output = NSString(data: data, encoding: String.Encoding
			.utf8.rawValue) as! String
		weak var me = self
		DispatchQueue.main.async {
			if me != nil {
				if output == "" {
					me!.count_4 += 1
					if me!.count_ping != 0 {
						let lost = Int(me!.count_4/me!.count_ping*100)
						me!.count_4_label.stringValue = "\(lost)%"
						me!.textField_4.textColor = NSColor.red
					}
				} else {
					me!.textField_4.textColor = NSColor.black
					me!.textField_4.stringValue = output
				}
			}
		}
	}
	
	@IBAction func click_5(_ sender: NSButton) {
		let task = Process()
		let pipe = Pipe()
		task.standardOutput = pipe
		task.launchPath = "/bin/sh"
		task.arguments = ["-c","ping -c 1 \(server_ip_5)|grep time|awk -F '=' '{print $4}'"]
		
		let file = pipe.fileHandleForReading
		task.launch()
		DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()
			+ DispatchTimeInterval.milliseconds(500) , execute: DispatchWorkItem {
			if task.isRunning { task.terminate() } })
		task.waitUntilExit()
		
		let data = file.readDataToEndOfFile()
		let output = NSString(data: data, encoding: String.Encoding
			.utf8.rawValue) as! String
		weak var me = self
		DispatchQueue.main.async {
			if me != nil {
				if output == "" {
					me!.count_5 += 1
					if me!.count_ping != 0 {
						let lost = Int(me!.count_5/me!.count_ping*100)
						me!.count_5_label.stringValue = "\(lost)%"
						me!.textField_5.textColor = NSColor.red
					}
				} else {
					me!.textField_5.textColor = NSColor.black
					me!.textField_5.stringValue = output
				}
			}
		}
	}
	
	@IBAction func click_6(_ sender: NSButton) {
		let task = Process()
		let pipe = Pipe()
		task.standardOutput = pipe
		task.launchPath = "/bin/sh"
		task.arguments = ["-c","ping -c 1 \(server_ip_6)|grep time|awk -F '=' '{print $4}'"]
		
		let file = pipe.fileHandleForReading
		task.launch()
		DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()
			+ DispatchTimeInterval.milliseconds(500) , execute: DispatchWorkItem {
				if task.isRunning { task.terminate() } })
		task.waitUntilExit()
		
		let data = file.readDataToEndOfFile()
		let output = NSString(data: data, encoding: String.Encoding
			.utf8.rawValue) as! String
		weak var me = self
		DispatchQueue.main.async {
			if me != nil {
				if output == "" {
					me!.count_6 += 1
					if me!.count_ping != 0 {
						let lost = Int(me!.count_6/me!.count_ping*100)
						me!.count_6_label.stringValue = "\(lost)%"
						me!.textField_6.textColor = NSColor.red
					}
				} else {
					me!.textField_6.textColor = NSColor.black
					me!.textField_6.stringValue = output
				}
			}
		}
	}

}





