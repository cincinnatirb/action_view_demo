# ActionView Demo
In this demo we will:
* Learn about ActionView including:
    * templates, partials and layouts
    * response formats
    * helpers
* Modify default parameters to achieve specific behaviors

## 1. Prerequisites
* Ubuntu 20 LTS: https://www.youtube.com/watch?v=I8WhikkiiSI
* Ruby, Node and Yarn: https://www.youtube.com/watch?v=C_xhTo9bw0s
* Microsoft Visual Studio Code: https://www.youtube.com/watch?v=rizfyb1-u6Q

## 2. Starting from rails new
Let's create our Rails application and open the code in the Visual Source Code
IDE.

```sh
rails new action_view_demo
code action_view_demo
```
Let's open the integrated terminal using Ctrl-\` (backtick) and notice that this
places the prompt in the `action_view_demo` directory. So we can just commit
source code as follows:
```sh
git add .
git commit -m'rails new action_view_demo'
```

## 3. Generating a User
This time we're going to generate our `User` scaffold first:
```sh
rails generate scaffold user username:string first_name:string last_name:string bio:text bicycles:integer gpa:float birth_date:date account_expiration:datetime earthling:boolean
```
Then we'll set our root route by making the following change to `config/routes.rb`
```ruby
# config/routes.rb
Rails.application.routes.draw do
  root 'users#index' # ADD THIS LINE!
  resources :users
end
```
Finally, we'll migrate the database and push (commit) our code.
```sh
rails db:migrate
git add .
git commit -m'Generate a User scaffold, set the root route and migrate the database'
```

## 4. Templates, Partials and Layouts
Let's examine the `app/views/users/new.html.erb` template, which references a
`partial` that defines an HTML form in `app/views/users/_form.html.erb`.

If we start the Rails server (run: `rails server` in our console), visit the new
User view in a browser at http://localhost:3000/users/new and view the page
source we see more HTML than is contained in the template and partial combined.

The remainder of the HTML is generated as a default layout by the scaffold
generator and contained in `app/views/layouts/application.html.erb`. Together,
these files define the response sent back to your browser when a specific route
is requested.

## 5. Response Formats
Notice that several methods in `app/controllers/users_controller.rb` contain
`respond_to` blocks. Notice also the comments associated with each controller
method which the Rails scaffold generator produced. For example, the `create`
method is preceded by these two comment lines:
```ruby
# POST /users
# POST /users.json
```
The comments indicate that the scaffold generated the code needed to process
requests in both HTML and JSON formats. Let's add an XML format by adding a file
named `app/views/users/show.xml.builder` with these contents:
```ruby
# app/views/users/show.xml.builder
xml.user do
  @user.attributes.each { |k, v| xml.tag!(k, v) }
  xml.url(user_url(@user, format: :xml))
end
```
Now, with the server still running, let's add a `User` by completing the [New User form](http:localhost:3000/users/new)
if you haven't already added one, and view all three formats:
* HTML: [http:localhost:3000/users/1](http:localhost:3000/users/1)
* JSON: [http:localhost:3000/users/1.json](http:localhost:3000/users/1.json)
* XML: [http:localhost:3000/users/1.xml](http:localhost:3000/users/1.xml)

Let's make note via the comment above the show method in the `UsersController`
that we've added an XML formatted view for that route:
```ruby
# app/controllers/users_controller.rb
...
# GET /users/1
# GET /users/1.json
# GET /users/1.xml
def show
end
...
```
Finally, we'll commit our changes.
```sh
git add .
git commit -m'Add an XML format for users#show view'
```

## 6. Helpers
We noticed the `form_with` method in the Ruby embedded in the
`app/views/users/_form.html.erb` partial. [ActionView::Helpers](https://api.rubyonrails.org/v6.0.3.3/classes/ActionView/Helpers.html)
defines a myriad of helper methods available to assist in rendering valid
markup. For example:
* `form_with` and field specific helpers defined in `ActionView::Helpers::FormHelper`
* `pluralize` helper defined in `ActionView::Helpers::TextHelper`
* `date_select` and `datetime_select` helpers defined in `ActionView::Helpers::DateHelper`
* `javascript_pack_tag` and `stylesheet_link_tag` helpers from the `application`
layout defined in `ActionView::Helpers::AssetTagHelper`

## 7. Helping Helpers
The default markup produced by the generated scaffolding is fine for general
purposes but we'd like to tweak those a bit.

First, we defined the GPA field as a floating point (decimal or "float") value
but the scaffold produced a text field. We know FormHelper can produce a
`number_field` for integer values. We can use that for the GPA field and set a
step attribute to 0.1, a maximum value of 4.0, and a minimum of 0.0 to make it
easy for users to input reasonable values. To do so, we'll make this change to
the file `app/views/users/_form.html.erb`:
```ruby
# app/views/users/_form.html.erb
...
<div class="field">
  <%= form.label :gpa %>
  <%= form.number_field :gpa, max: 4.0, min: 0.0, step: 0.1 %>
</div>
...
```
Next, the generator does not understand that our `birth_date` field needs to
accommodate the oldest living human. So the 10 year range the helper includes by
default is not going to get the job done. I think I read that the oldest living
human is about 115 years old. Let's add a five year buffer just in case they
discover our app and what to sign up! We'll also add code to ensure that users
are at least 18 years old and will set the default value to equal to the birth
date of people turning 18 today. We can make the changes below to
accomplish that:
```ruby
# app/views/users/_form.html.erb
...
<div class="field">
  <%= form.label :birth_date %>
  <%= form.date_select :birth_date, start_year: 120.years.ago.localtime.year, end_year: 18.years.ago.localtime.year, selected: 18.years.ago.localtime %>
</div>
...
```
Finally, let's set the account expiration timestamp to be one year from now and
specify an AM/PM time format. Here's how we accomplish that:
```ruby
# app/views/users/_form.html.erb
...
<div class="field">
  <%= form.label :account_expiration %>
  <%= form.datetime_select :account_expiration, ampm: true, selected: 1.year.from_now.localtime %>
</div>
...
```
Looking good! Visit [the New User view](http:localhost:3000/users/new) and
notice the effect of the changes. This is a good place to commit the code!
```sh
git add .
git commit -m'Tweak gpa, birth_date and account_expiration input fields'
```

## Further Reading:
* The ActionView Gem: https://rubygems.org/gems/actionview
* The ActionView Rails guide: https://guides.rubyonrails.org/action_view_overview.html

Expanded from: https://gist.github.com/agilous/511d801f4240167d0e862a3a2b8275ad
