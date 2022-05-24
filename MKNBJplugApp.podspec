#
# Be sure to run `pod lib lint MKNBJplugApp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKNBJplugApp'
  s.version          = '0.0.1'
  s.summary          = 'A short description of MKNBJplugApp.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/aadyx2007@163.com/MKNBJplugApp'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aadyx2007@163.com' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/aadyx2007@163.com/MKNBJplugApp.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  
  s.resource_bundles = {
    'MKNBJplugApp' => ['MKNBJplugApp/Assets/*.png']
  }

  s.subspec 'Target' do |ss|
    
    ss.source_files = 'MKNBJplugApp/Classes/Target/**'
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKNBJplugApp/Functions'
  
  end
  
  s.subspec 'SDK' do |ss|
    
    ss.subspec 'BLE' do |sss|
      sss.source_files = 'MKNBJplugApp/Classes/SDK/BLE/**'
      
      sss.dependency 'MKBaseBleModule'
    end
    
    ss.subspec 'MQTT' do |sss|
      sss.source_files = 'MKNBJplugApp/Classes/SDK/MQTT/**'
      
      ss.dependency 'MKBaseModuleLibrary'
      ss.dependency 'MKBaseMQTTModule'
    end
  
  end
  
  s.subspec 'Expand' do |ss|
    ss.subspec 'BaseController' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Expand/BaseController/Controller/**'
        
        ssss.dependency 'MKNBJplugApp/Expand/BaseController/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Expand/BaseController/Model/**'
        
        ssss.dependency 'MKNBJplugApp/Expand/DeviceModel'
      end
    end
    
    ss.subspec 'DeviceModel' do |sss|
      sss.subspec 'Manager' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Expand/DeviceModel/Manager/**'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Expand/DeviceModel/Model/**'
      end
    end
    
    ss.subspec 'Manager' do |sss|
      sss.subspec 'DatabaseManager' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Expand/Manager/DatabaseManager/**'
        
        ssss.dependency 'MKNBJplugApp/Expand/DeviceModel/Model'
        ssss.dependency 'FMDB'
      end
      
      sss.subspec 'ExcelManager' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Expand/Manager/ExcelManager/**'
        
        ssss.dependency 'libxlsxwriter'
        ssss.dependency 'SSZipArchive'
      end
    end
    
    ss.subspec 'View' do |sss|
      sss.subspec 'UserCredentialsView' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Expand/View/UserCredentialsView/**'
      end
    end
    
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKNBJplugApp/SDK/MQTT'
    ss.dependency 'MKCustomUIModule'
    
  end
  
  s.subspec 'Functions' do |ss|
    
    ss.subspec 'AddDevicePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/AddDevicePage/Controller/**'
        
        ssss.dependency 'MKNBJplugApp/Functions/AddDevicePage/View'
        
        ssss.dependency 'MKNBJplugApp/Functions/ServerForDevice/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/UpdatePage/Controller'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/AddDevicePage/View/**'
      end
    end
    
    ss.subspec 'ConnectSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ConnectSettingPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/ConnectSettingPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ConnectSettingPage/Model/**'
      end
    end
    
    ss.subspec 'ConnectSuccessPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ConnectSuccessPage/Controller/**'
      end
    end
    
    ss.subspec 'DebuggerPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/DebuggerPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/DebuggerPage/View'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/DebuggerPage/View/**'
      end
    end
    
    ss.subspec 'DeviceInfoPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/DeviceInfoPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/DeviceInfoPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/DeviceInfoPage/Model/**'
      end
    end
    
    ss.subspec 'DeviceListPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/DeviceListPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/DeviceListPage/View'
      
        ssss.dependency 'MKNBJplugApp/Functions/ServerForApp/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/ScanPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/SwitchStatePage/Controller'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/DeviceListPage/View/**'
      end
    end
    
    ss.subspec 'ElectricityPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ElectricityPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/ElectricityPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ElectricityPage/Model/**'
      end
    end
    
    ss.subspec 'EnergyPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/EnergyPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/EnergyPage/Model'
        ssss.dependency 'MKNBJplugApp/Functions/EnergyPage/View'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/EnergyPage/Model/**'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/EnergyPage/View/**'
      end
    end
    
    ss.subspec 'EnergyParamPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/EnergyParamPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/EnergyParamPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/EnergyParamPage/Model/**'
      end
    end
    
    ss.subspec 'ImportServerPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ImportServerPage/Controller/**'
      end
    end
    
    ss.subspec 'IndicatorColorPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/IndicatorColorPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/IndicatorColorPage/Model'
        ssss.dependency 'MKNBJplugApp/Functions/IndicatorColorPage/View'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/IndicatorColorPage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/IndicatorColorPage/View/**'
      end
    end
    
    ss.subspec 'IndicatorSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/IndicatorSettingPage/Controller/**'
        
        ssss.dependency 'MKNBJplugApp/Functions/IndicatorSettingPage/Model'
        
        ssss.dependency 'MKNBJplugApp/Functions/IndicatorColorPage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/IndicatorSettingPage/Model/**'
      end
    end
    
    ss.subspec 'ModifyMQTTServerPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ModifyMQTTServerPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/ModifyMQTTServerPage/Model'
        ssss.dependency 'MKNBJplugApp/Functions/ModifyMQTTServerPage/View'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ModifyMQTTServerPage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ModifyMQTTServerPage/View/**'
      end
    end
    
    ss.subspec 'MQTTSettingInfoPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/MQTTSettingInfoPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/MQTTSettingInfoPage/Model'
        ssss.dependency 'MKNBJplugApp/Functions/MQTTSettingInfoPage/View'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/MQTTSettingInfoPage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/MQTTSettingInfoPage/View/**'
      end
    end
    
    ss.subspec 'NotificationSwitchPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/NotificationSwitchPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/NotificationSwitchPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/NotificationSwitchPage/Model/**'
      end
    end
    
    ss.subspec 'NTPServerPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/NTPServerPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/NTPServerPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/NTPServerPage/Model/**'
      end
    end
    
    ss.subspec 'OTAPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/OTAPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/OTAPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/OTAPage/Model/**'
      end
    end
    
    ss.subspec 'PeriodicalReportPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/PeriodicalReportPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/PeriodicalReportPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/PeriodicalReportPage/Model/**'
      end
    end
    
    ss.subspec 'PowerOnModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/PowerOnModePage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/PowerOnModePage/Model'
        ssss.dependency 'MKNBJplugApp/Functions/PowerOnModePage/View'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/PowerOnModePage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/PowerOnModePage/View/**'
      end
    end
    
    ss.subspec 'PowerReportPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/PowerReportPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/PowerReportPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/PowerReportPage/Model/**'
      end
    end
    
    ss.subspec 'ProtectionConfigPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ProtectionConfigPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/ProtectionConfigPage/Model'
        ssss.dependency 'MKNBJplugApp/Functions/ProtectionConfigPage/Header'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ProtectionConfigPage/Model/**'
        
        ssss.dependency 'MKNBJplugApp/Functions/ProtectionConfigPage/Header'
      end
      
      sss.subspec 'Header' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ProtectionConfigPage/Header/**'
      end
    end
    
    ss.subspec 'ProtectionSwitchPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ProtectionSwitchPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/ProtectionConfigPage/Controller'
      end
    end
    
    ss.subspec 'ScanPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ScanPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/ScanPage/Model'
        ssss.dependency 'MKNBJplugApp/Functions/ScanPage/View'
        
        ssss.dependency 'MKNBJplugApp/Functions/AddDevicePage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/DebuggerPage/Controller'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ScanPage/View/**'
        
        ssss.dependency 'MKNBJplugApp/Functions/ScanPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ScanPage/Model/**'
      end
    end
    
    ss.subspec 'ServerForApp' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ServerForApp/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/ServerForApp/Model'
        ssss.dependency 'MKNBJplugApp/Functions/ServerForApp/View'
        
        ssss.dependency 'MKNBJplugApp/Functions/ImportServerPage/Controller'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ServerForApp/View/**'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ServerForApp/Model/**'
      end
    end
    
    ss.subspec 'ServerForDevice' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ServerForDevice/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/ServerForDevice/Model'
        ssss.dependency 'MKNBJplugApp/Functions/ServerForDevice/View'
        
        ssss.dependency 'MKNBJplugApp/Functions/ImportServerPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/ConnectSuccessPage/Controller'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ServerForDevice/View/**'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/ServerForDevice/Model/**'
      end
    end
    
    ss.subspec 'SettingsPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/SettingsPage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/SettingsPage/Model'
        
        ssss.dependency 'MKNBJplugApp/Functions/PowerOnModePage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/PeriodicalReportPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/PowerReportPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/EnergyParamPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/ConnectSettingPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/SystemTimePage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/ProtectionSwitchPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/NotificationSwitchPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/IndicatorSettingPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/ModifyMQTTServerPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/OTAPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/MQTTSettingInfoPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/DeviceInfoPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/DebuggerPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/SettingsPage/Model/**'
      end
    end
        
    ss.subspec 'SwitchStatePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/SwitchStatePage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/SwitchStatePage/Model'
        ssss.dependency 'MKNBJplugApp/Functions/SwitchStatePage/View'
        
        ssss.dependency 'MKNBJplugApp/Functions/ElectricityPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/EnergyPage/Controller'
        ssss.dependency 'MKNBJplugApp/Functions/SettingsPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/SwitchStatePage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/SwitchStatePage/View/**'
      end
    end
    
    ss.subspec 'SystemTimePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/SystemTimePage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/SystemTimePage/Model'
        ssss.dependency 'MKNBJplugApp/Functions/SystemTimePage/View'
        
        ssss.dependency 'MKNBJplugApp/Functions/NTPServerPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/SystemTimePage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/SystemTimePage/View/**'
      end
    end
    
    ss.subspec 'UpdatePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/UpdatePage/Controller/**'
      
        ssss.dependency 'MKNBJplugApp/Functions/UpdatePage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNBJplugApp/Classes/Functions/UpdatePage/Model/**'
      end
    
      sss.dependency 'iOSDFULibrary'
    end
    
    ss.dependency 'MKNBJplugApp/SDK'
    ss.dependency 'MKNBJplugApp/Expand'
  
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
    ss.dependency 'HHTransition'
    ss.dependency 'MLInputDodger'
    ss.dependency 'CTMediator'
    
  end
  
end
