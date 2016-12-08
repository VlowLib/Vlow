Pod::Spec.new do |s|
  s.name         = "Vlow"
  s.version      = "0.0.1"
  s.summary      = "A high-level audio processing graph library on top of Pure Data"
  s.description  = "A high-level audio processing graph library on top of Pure Data"
  s.homepage     = "https://github.com/VlowLib/Vlow"
  s.license      = "MIT"

  s.authors             = { "Joseph Constantakis" => "jcon5294@gmail.com",
                            "Chelsea Pugh" => "chelpu@umich.edu" }

  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/VlowLib/Vlow.git" }
  s.source_files  = "Vlow", "PureData/Externals"

  s.resources = "PureData/Patches/*.pd"

  s.requires_arc = true

  s.dependency "libpd"

  s.compiler_flags = '-DPD -DHAVE_ALLOCA_H'

end
