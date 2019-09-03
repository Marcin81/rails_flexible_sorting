# frozen_string_literal: true

require "active_support/concern"
module FlexibleSorting
  module Model
    extend ActiveSupport::Concern

    class_methods do
      def sortable(*args)
        @sortable ||= []
        @sortable << args unless args.empty?
        @sortable
      end

      def sorting(column, direction = :asc, args = [])
        FlexibleSorting::Sort.new(self, column, direction, args).all
      end
    end
  end

  class Column
    attr_reader :name, :column, :scope, :virtual, :as_instance_method, :method_args
    def initialize(name, scope = nil, column: name, virtual: false, as_instance_method: false)
      @name = name
      @column = column
      @scope = scope
      @virtual = virtual
      @as_instance_method = as_instance_method
    end
  end

  class Sort
    attr_reader :scope

    def initialize(scope, column, direction, args = [])
      @scope = scope
      @column = column
      @direction = direction
      @args = args
    end

    def columns
      @columns = create_columns
    end

    def all
      all = scope.all

      if column
        if column.scope.is_a?(Proc) && column.virtual && column.as_instance_method
          all = all.sort_by { |e| column.scope.call(*[e, *args]) }
        elsif column.scope.present?
          all = all.merge(column.scope)
        end

        if column.virtual
          all.reverse! if direction == "desc"
        else
          all = all.order("#{column.column} #{direction}")
        end
      end

      all
    end

    def direction
      @direction.to_s == "desc" ? "desc" : "asc"
    end

    def column
      columns[@column.to_s]&.first
    end

    def create_columns
      scope.sortable.flat_map do |columns|
        columns = [columns] unless columns.all? { |column| column.is_a?(Symbol) }
        columns.map { |column| Column.new(*column) }
      end.group_by { |column| column.name.to_s }
    end

    private

    attr_reader :args
  end
end
