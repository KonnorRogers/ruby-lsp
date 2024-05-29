# typed: strict
# frozen_string_literal: true

module RubyLsp
  module Requests
    # ![Type hierarchy supertypes demo](../../type_hierarchy_supertypes.gif)
    #
    # The [type hierarchy supertypes
    # request](https://microsoft.github.io/language-server-protocol/specification#typeHierarchy_supertypes)
    # displays the list of ancestors (supertypes) for the selected type.
    #
    # # Example
    #
    # ```ruby
    # class Foo; end
    # class Bar < Foo; end
    #
    # puts Bar # <-- right click on `Bar` and select "Show Type Hierarchy"
    # ```
    class TypeHierarchySupertypes < Request
      extend T::Sig

      include Support::Common

      sig { params(index: RubyIndexer::Index, item: T::Hash[Symbol, T.untyped]).void }
      def initialize(index, item)
        super()

        @index = index
        @item = item
      end

      sig { override.returns(T.nilable(T::Array[Interface::TypeHierarchyItem])) }
      def perform
        name = @item[:name]
        super_types = @index.linearized_ancestors_of(name)

        super_types.filter_map do |super_type_name|
          next if super_type_name == name

          entries = @index[super_type_name]
          next unless entries

          entries.map do |entry|
            range = range_from_location(entry.location)

            Interface::TypeHierarchyItem.new(
              name: entry.name,
              kind: kind_for_entry(entry),
              uri: URI::Generic.from_path(path: entry.file_path).to_s,
              range: range,
              selection_range: range,
            )
          end
        end.flatten
      rescue RubyIndexer::Index::NonExistingNamespaceError
        nil
      end
    end
  end
end
