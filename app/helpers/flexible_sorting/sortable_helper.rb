# frozen_string_literal: true

module FlexibleSorting::SortableHelper
  def sortable(column, default: false, direction: :asc, scope: nil, **options, &block)
    current = column.to_s == params[:sort] || params[:sort].blank? && default
    current_direction = (params[:direction] || direction).to_s

    new_direction = direction.to_s
    if current
      new_direction = current_direction.to_s == "asc" ? "desc" : "asc"
    end

    url = url_for params.permit!.merge(sort: column, direction: new_direction)

    link_to(url, options) do
      label = block_given? ? capture(&block) : column
      sortable_label_for(label, current, current_direction, scope)
    end
  end

  def sortable_label_for(label, active, direction, scope)
    render "flexible_sorting/label", label: label, active: active, direction: direction, scope: scope
  end
end
