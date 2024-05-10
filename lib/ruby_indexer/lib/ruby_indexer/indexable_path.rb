# typed: strict
# frozen_string_literal: true

module RubyIndexer
  class IndexablePath
    extend T::Sig

    sig { returns(T.nilable(String)) }
    attr_reader :require_path, :cache_key

    sig { returns(String) }
    attr_reader :full_path

    # An IndexablePath is instantiated with a load_path_entry and a full_path. The load_path_entry is where the file can
    # be found in the $LOAD_PATH, which we use to determine the require_path. The load_path_entry may be `nil` if the
    # indexer is configured to go through files that do not belong in the $LOAD_PATH. For example,
    # `sorbet/tapioca/require.rb` ends up being a part of the paths to be indexed because it's a Ruby file inside the
    # project, but the `sorbet` folder is not a part of the $LOAD_PATH. That means that both its load_path_entry and
    # require_path will be `nil`, since it cannot be required by the project
    sig { params(load_path_entry: T.nilable(String), full_path: String, cache_key: T.nilable(String)).void }
    def initialize(load_path_entry, full_path, cache_key: nil)
      @full_path = full_path
      @require_path = T.let(
        load_path_entry ? full_path.delete_prefix("#{load_path_entry}/").delete_suffix(".rb") : nil,
        T.nilable(String),
      )
      @cache_key = cache_key
    end
  end
end
