# FlexibleSorting

## Description
Simple gem for sorting data in HTML tables

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rails_flexible_sorting"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_flexible_sorting

## Usage

```
class User < ApplicationRecord
  include FlexibleSorting::Model
  
  belongs_to :service
  scope :sorted_by_service, -> { all.sort_by { |service| service.method } }

  sortable :id, :updated_at, :email
  sortable :profile_name, -> { joins(:profile) }, column: "profiles.name"
  sortable :network, -> { sorted_by_service }, virtual: true
  sortable :company, -> (obj, name) { obj.company_label_for(name) }, virtual: true, as_instance_method: true
  sortable :state, -> (obj) { obj.state_label }, virtual: true, as_instance_method: true

  def company_label_for(name)
    # do something and return value
  end

  def state_label
    # do something and return value
  end  
end
```

In Views

```
<th><%= sortable :email, default: true %></th>
<th><%= sortable :updated_at, direction: :desc %></th>
<th>
  <%= sortable :profile_name do %>
    Custom label
  <% end %>
</th>
```
If you want customize how arrows are generated copy `views/lexible_sorting/_label.html.erb`
and change how you want.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Marcin81/rails_flexible_sorting. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SortableForRails project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/madmax/sortable-for-rails/blob/master/CODE_OF_CONDUCT.md).