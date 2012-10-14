# YARD support
namespace :yard do

  # so that we can sort them
  class YARD::CodeObjects::MethodObject
    def <=>(other)
      self.path <=> other.path
    end
  end

  desc 'Force a rebuild of the documentation'
  YARD::Rake::YardocTask.new :doc do |yard|
    yard.options = ['--no-private',
                    '--protected',
                    '--readme=README.rdoc',
                    '--title', 'VGH Scripts'
    ]
    yard.files = ['-', 'LICENSE']
  end

  desc 'Outputs some information about the documentation'
  YARD::Rake::YardocTask.new :doc_info do |yard|
    yard.options = ['--no-output',
                    '--private',
                    '--protected',
                    '--use-cache'
    ]
  end

  def docd_method_percent(klass)
    total  = klass.meths.size.to_f
    undocd = klass.meths.select {|m| m.docstring.empty? }.size.to_f

    undocd.zero? ? 0.0 : (undocd / total)
  end

  desc 'Find undocumented methods'
  task :undocd => [ :doc_info ] do
    methods = YARD::Registry.load!.all(:method)
    meths = methods.select {|m| m.docstring.empty? }
    puts meths.sort
  end

  desc 'Find the classes with the highest percent on documented methods'
  task :percent_undocd => [ :doc ] do
    klasses = YARD::Registry.load!.all(:class)

    ks     = klasses.map {|k| [k, docd_method_percent(k)] }
    sorted = ks.sort {|(_, percent), (_, percent2)| percent <=> percent2 }
    sorted.each do |(k, p)|
      puts "#{k} => #{p * 100}%" unless p == 0.0
    end
  end

end # YARD

