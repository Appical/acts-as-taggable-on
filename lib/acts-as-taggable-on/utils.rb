# frozen_string_literal: true

# This module is deprecated and will be removed in the incoming versions

module ActsAsTaggableOn
  module Utils
    class << self
      # Use ActsAsTaggableOn::Tag connection
      #
      # Rails 7.2 deprecated the model-level `.connection` in favour of
      # `lease_connection` (rails/rails#51230). Prefer it when available and
      # fall back to `connection` for ActiveRecord < 7.2.
      def connection
        if ActsAsTaggableOn::Tag.respond_to?(:lease_connection)
          ActsAsTaggableOn::Tag.lease_connection
        else
          ActsAsTaggableOn::Tag.connection
        end
      end

      def using_postgresql?
        connection && %w[PostgreSQL PostGIS].include?(connection.adapter_name)
      end

      def using_mysql?
        connection && connection.adapter_name == 'Mysql2'
      end

      def sha_prefix(string)
        Digest::SHA1.hexdigest(string)[0..6]
      end

      def like_operator
        using_postgresql? ? 'ILIKE' : 'LIKE'
      end

      # escape _ and % characters in strings, since these are wildcards in SQL.
      def escape_like(str)
        str.gsub(/[!%_]/) { |x| "!#{x}" }
      end
    end
  end
end
