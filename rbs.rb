# typed: strict
# frozen_string_literal: true

require "rbs"

loader = RBS::EnvironmentLoader.new
env = RBS::Environment.from_loader(loader).resolve_type_names
# loader.add(library: "pathname")

loader.each_signature do |source, pathname, buffer, declarations, directives|
  binding.irb
end

builder = RBS::DefinitionBuilder.new(env: env)

# r = RBS::Parser.parse_signature(<<~RBS)
#   class Hello
#     def foo: (String) -> void
#   end
# RBS

# core + stdlib
