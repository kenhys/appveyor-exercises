#!/usr/bin/env ruby

require "rbconfig"
require "pathname"
require "fileutils"

source_base_dir_path = Pathname(__dir__).expand_path
source_top_dir_path = source_base_dir_path.parent.parent
if ENV["BUILD_DIR"]
  build_base_dir_path = Pathname(ENV["BUILD_DIR"]).expand_path
else
  build_base_dir_path  = Pathname($0).expand_path.dirname
end
build_top_dir_path = build_base_dir_path.parent.parent

ENV["BASE_DIR"] ||= build_base_dir_path.to_s

groonga_install_prefix = nil
if (ARGV[0] || "").start_with?("--groonga-install-prefix=")
  groonga_install_prefix = ARGV.shift.gsub(/\A--groonga-install-prefix=/, "")
end

p groonga_install_prefix
p groonga_install_prefix.encoding
p groonga_install_prefix.encode("UTF-8")
if groonga_install_prefix
  unescaped = groonga_install_prefix.gsub(/\\u[\dafA-F]{4}/) { [$1].pack('H*').unpack('n*').pack('U*') }
  p unescaped
  ENV["PATH"] = [
    [groonga_install_prefix, "bin"].join(File::ALT_SEPARATOR || File::SEPARATOR),
    [unescaped, "bin"].join(File::ALT_SEPARATOR || File::SEPARATOR),
    ENV["PATH"],
  ].join(File::PATH_SEPARATOR)
else
  Dir.chdir(build_top_dir_path.to_s) do
    system("make -j8 > /dev/null") or exit(false)
  end

  ENV["PATH"] = [
    (build_top_dir_path + "src").to_s,
    ENV["PATH"],
  ].join(File::PATH_SEPARATOR)
  if build_top_dir_path != source_top_dir_path
    Dir.glob(source_top_dir_path + "plugins/**/*.rb") do |source_rb|
      relative_path = Pathname(source_rb).relative_path_from(source_top_dir_path)
      build_rb = build_top_dir_path + relative_path
      FileUtils.mkdir_p(build_rb.dirname)
      FileUtils.cp(source_rb, build_rb)
    end
  end
  ENV["GRN_PLUGINS_DIR"]      = (build_top_dir_path + "plugins").to_s
  ENV["GRN_RUBY_SCRIPTS_DIR"] = (source_top_dir_path + "lib/mrb/scripts").to_s
  ENV["GRN_RUBY_LOAD_PATH"] = [
    (source_top_dir_path + "vendor/groonga-log-source/lib").to_s,
    ENV["GRN_RUBY_LOAD_PATH"],
  ].compact.join(File::PATH_SEPARATOR)
end
p ENV["PATH"]

$VERBOSE = true

require_relative "helper"

ARGV.unshift("--max-diff-target-string-size=5000")

p "CHECK PATH"
p "glob */groonga.exe"
p Dir.glob("*/groonga.exe")
p "glob *"
p Dir.glob("*")
path = "c:\\projects\\appveyor-exercises"
p Dir.glob("#{path}\\*")
path = "c:/projects/appveyor-exercises"
p Dir.glob("#{path}\\*")
path = "c:\\projects\\appveyor-exercises\\\u7E67\uFF64\u7E5D\uFF73\u7E67\uFF79\u7E5D\u533B\u30FB\u7E5D\uFF6B\\groonga-9.0.1-x64\\bin\\groonga"
p path
p "glob #{path}\\*"
p Dir.glob("#{path}\\*")
p File.exist?(path)
path = "c:\\projects\\appveyor-exercises\\\u7E67\uFF64\u7E5D\uFF73\u7E67\uFF79\u7E5D\u533B\u30FB\u7E5D\uFF6B\\groonga-9.0.1-x64\\bin\\groonga.exe"
p path
p File.exist?(path)
path = "c:\\projects\\appveyor-exercises\\\u7E67\uFF64\u7E5D\uFF73\u7E67\uFF79\u7E5D\u533B\u30FB\u7E5D\uFF6B\\groonga-9.0.1-x64/bin/groonga.exe"
p path
p File.exist?(path)
path = "c:/projects/appveyor-exercises/\u7E67\uFF64\u7E5D\uFF73\u7E67\uFF79\u7E5D\u533B\u30FB\u7E5D\uFF6B/groonga-9.0.1-x64/bin/groonga.exe"
p path
p File.exist?(path)
path = "c:/projects/appveyor-exercises/\u7E67\uFF64\u7E5D\uFF73\u7E67\uFF79\u7E5D\u533B\u30FB\u7E5D\uFF6B/bin/groonga.exe"
p path
p File.exist?(path)
p "groonga_install_prefix"
path = "#{groonga_install_prefix}/bin/groonga.exe"
p path
p File.exist?(path)
p "groonga_install_prefix unescape escape"
unescaped = groonga_install_prefix.gsub(/\\u[\dafA-F]{4}/) { [$1].pack('H*').unpack('n*').pack('U*') }
p unescaped
path = "#{unescaped}/bin/groonga.exe"
p path
p File.exist?(path)

exit(Test::Unit::AutoRunner.run(true, (source_base_dir_path + "suite").to_s))
