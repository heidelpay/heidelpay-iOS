Pod::Spec.new do |s|  
    s.name              = 'HeidelPaySDK'
    s.version           = '1.0.0'
    s.summary           = 'HeidelPay SDK for mobile payment'
    s.homepage          = 'http://heidelpay.com/'

    s.author            = { 'Name' => 'info@heidelpay.com' }
    s.license           = { :file => 'LICENSE' }

    s.platform          = :ios
    s.source            = { :git => 'https://github.com/heidelpay/heidelpay-iOS.git' }

    s.ios.deployment_target = '10.3'
    s.ios.vendored_frameworks = 'HeidelPaySDK.framework'
end  