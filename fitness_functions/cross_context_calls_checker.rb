require 'parser/current'

module FitnessFunctions
  class ParseFileDependencies
    def call(file_path)
      file = File.read("#{__dir__}/../#{file_path}")

      node = Parser::CurrentRuby.parse(file).loc.node
      find_dependencies(node.to_sexp_array)
    end

  private

    def select_include_nodes(sexp)
      sexp.select { |node| node[0] == :send && node[1] == nil && node[2] == :include }
    end

    def select_di_import_node(import_sexps)
      import_sexps.select { |node| Array(node[3][1])[2] == :Import }
    end

    def get_imported_dependencies(import_sexps)
      import_sexps.empty? ? [] : import_sexps.flat_map { |sexp| sexp[3][3][1..-1].map{ |n| n[2][1] } }
    end

    def find_dependencies(sexp)
      di_imports = []

      loop do
        sexp = sexp.pop

        if sexp[0] == :begin
          di_imports = get_imported_dependencies(
            select_di_import_node(
              select_include_nodes(sexp)
            )
          )
          break
        else
          next
        end
      end

      di_imports
    end
  end

  class CrossContextCallsChecker
    def call(file_path, whitelist: [])
      di_imports = ParseFileDependencies.new.call(file_path)

      puts "Checking: '#{file_path}'"
      puts "Dependencies for file: #{di_imports}"

      di_imports.each do |dependency|
        next if dependency.start_with?(*whitelist)

        raise "Invalid dependency '#{dependency}' for '#{file_path}'"
      end
    end
  end
end

# =========================================

puts
puts

whitelist = %w[persistance.accounting.repositories.account.rom persistance.toy_testing.repositories.cat_toy.rom]
file_path = 'contexts/accounting/commands/receive_info.rb'
FitnessFunctions::CrossContextCallsChecker.new.call(file_path, whitelist: whitelist)

puts
puts '****'
puts

whitelist = %w[persistance.toy_testing.repositories.account.rom]
file_path = 'contexts/toy_testing/commands/assign_toy.rb'
FitnessFunctions::CrossContextCallsChecker.new.call(file_path, whitelist: whitelist)

puts
puts '****'
puts

whitelist = %w[persistance.toy_testing.repositories.account.rom persistance.toy_testing.repositories.cat_toy.rom]
file_path = 'contexts/toy_testing/commands/send_result.rb'
FitnessFunctions::CrossContextCallsChecker.new.call(file_path, whitelist: whitelist)

puts
puts '****'
puts

whitelist = %w[hanami.action.configuration contexts.toy_testing.commands.assign_toy contexts.toy_testing.commands.send_result]
file_path = 'apps/http/actions/commands/assign_toy.rb'
FitnessFunctions::CrossContextCallsChecker.new.call(file_path, whitelist: whitelist)
file_path = 'apps/http/actions/commands/send_result.rb'
FitnessFunctions::CrossContextCallsChecker.new.call(file_path, whitelist: whitelist)

puts
puts '****'
puts

whitelist = %w[hanami.action.configuration contexts.toy_testing.queries.all_toys_for_testing_query]
file_path = 'apps/http/actions/queries/show_toys_for_testing.rb'
FitnessFunctions::CrossContextCallsChecker.new.call(file_path, whitelist: whitelist)


# [:send, [:const, nil, :Import],
# binding.irb
# :end