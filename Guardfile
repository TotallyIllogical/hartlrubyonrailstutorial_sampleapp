# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, cmd: "spring rspec" do
  watch(%r{^spec/.+_spec\.rb$})

  # Rails example
  watch(%r{^app/(.+)\.rb$})                       { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})      { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^spec/support/\.rb$})                  { "spec" }
  watch(%r{^spec/support/pages/(.*)_page\.rb$})   { |m| "spec/features/#{m[1]}" if File.exist? "spec/features/#{m[1]}" }

  # views
  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$}) do |m|
    match = m[1].split('/')
    ["spec/features/#{match[0]}", "spec/features/#{match[1]}"].reject {|str| str == 'spec/features/'}
  end

  # controllers
  watch(%r{^app/controllers/(.+)_controller\.rb$}) do |m|
    match = m[1].split('/')
    ["spec/controllers/#{match[-2]}", "spec/controllers/#{match[-1]}"].reject {|str| str == 'spec/controllers/'}
  end

end