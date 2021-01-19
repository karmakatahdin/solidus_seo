# Solidus SEO

Successful stores keep SEO as a top priority. This Solidus extension adds common-sense defaults for structured data, meta tags, Open Graph protocol, and image optimization.

Please note that we are still striving to improve this extension and we warmly welcome community contribution, engagement, and support.

Let us know what you'd like to see added next; we promise to respond to any issues as soon as possible.

## Installation

1. Add `solidus_seo` to your Gemfile:

    ```ruby
    gem 'solidus_seo'
    ```

2. Bundle your dependencies and run the installation generator):

    NOTE: *During this step, you will be prompted to decide whether or not you'd like to generate the overrides that are included in solidus_seo. These overrides require 'deface' and are intended to be used with solidus_frontend. If you are not using solidus_frontend, you'll have to figure out where is best to manually insert the solidus_seo helpers into your custom views. Continue reading for more information.*

    ```shell
    bundle

    bundle exec rails g solidus_seo:install
    ```

3. Make sure you've added your store metadata from the Solidus store administration page, like SEO title, store URL and meta description.

4. (Optional) Override the stubbed methods and/or default helpers provided by this gem to provide extended functionality. [This is further explained below in the Usage section.]


## Usage

### Views

As mentioned in the above section, we use [Deface](https://github.com/spree/deface) to insert some helpers that generate the meta and structured data. This, of course, only works if you're using/overriding the default Solidus views from [solidus_frontend](https://github.com/solidusio/solidus/tree/master/frontend).

Otherwise, if you're using custom non-Solidus views, we assume you're smart enough to figure out for yourself where to put these helpers ;)

Here are the changes we make, via deface, in the default Solidus views as part of the minimal installation:

- In `spree/shared/_head.html.erb`:
  - Replace the `<%== meta_data_tags %>` line for `<%= display_meta_tags %>`.
  - Remove the `<title>` tag (`display_meta_tags` generates a new title tag).

- In `spree/layouts/spree_application.html.erb`
  - Insert `<%= render 'solidus_seo/analytics' %>` just before `</head>`.
  - Insert `<%= dump_jsonld %>` just before the `</body>` closing tag.
  - Replace `<%= taxon_breadcrumbs(@taxon) %>` with (`<%= taxon_breadcrumbs_jsonld(@taxon) %>`) which does the same as the original plus prints a JSON-LD tag.

- In `spree/products/show.html.erb`:
  - Insert `<%= jsonld @product %>` anywhere inside the `cache` block.

- In `spree/shared/_products.html.erb`:
  - Insert `<% jsonld_list(products) %>` at the bottom of the file. (Notice this helper doesn't generate any output, as instead it simply adds to the data that's later outputted by `dump_jsonld`)

At this point, assuming you're using the default Solidus views and this extension's deface overrides, the features you've gained are:

  - Default meta tags including open graph tags, describing a product on the PDP pages, and describing the store/site in all other pages.
  - Store JSON-LD markup on all your pages.
  - Product JSON-LD markup in your PDP pages.
  - Breadcrumb JSON-LD markup in your taxon pages.
  - ItemList JSON-LD markup in your paginated product pages.
  - Site-wide default paperclip image optimization (through image_optim)
  - Page view and eCommerce conversion tracking (completed checkouts) enabled via presence of `GOOGLE_TAG_MANAGER_ID`, `GOOGLE_ANALYTICS_ID`, `FACEBOOK_PIXEL_ID`, `PINTEREST_TAG_ID` environment variables (only one Google integration should be enabled at a time).

### Models

This gem is intended to provide a progressive implementation approach. To begin with, it defines some methods in your models to be used as an interface/source of your meta data. Moreover, it already provides some useful defaults that can be easily extended and customized, all inside your Spree models, via decorators.

Practically speaking, what this means is that simply by setting your store's metadata from the admin and calling the display_meta_tags helper in your layout, you'll get basic JSON-LD data included for your store. The output would be similar to the following:

```json
{
  "@context": "http://schema.org",
  "@type": "Store",
  "name": "Your Store Name",
  "logo": "https://yourstore.com/store_logo.jpg",
  "image": "https://yourstore.com/store_logo.jpg",
  "url": "https://yourstore.com",
  "@id": "https://yourstore.com",
}
```

Likewise, with no additional customization, overrides, or decorators, a call to `jsonld @product` will produce the following example output:

```json
{
  "@context": "http://schema.org/",
  "@type": "Product",
  "name": "Ruby on Rails Tote",
  "url": "http://example.com/products/ruby-on-rails-tote",
  "image": [
    "http://example.com/spree/products/21/large/ror_tote.jpeg?1538529540"
  ],
  "description": "Ruby on Rails Tote",
  "sku": "ROR-00011",
  "offers": {
    "@type": "Offer",
    "priceCurrency": "USD",
    "price": "15.99",
    "itemCondition": "http://schema.org/NewCondition",
    "availability": "http://schema.org/InStock"
  }
}
```

Beyond this initial behavior, you can override any of these **base methods** with your own data source. We recommend you [take a look at the source](https://github.com/karmakatahdin/solidus_seo/blob/master/lib/solidus_seo/jsonld/builder/data_methods.rb) to know which properties are available for easy overriding.

The basic requirements for the return values of your methods are straight-forward:
  - `seo_data` must return a hash with the same structure expected by  [`set_meta_tags`](https://github.com/kpumuk/meta-tags#allowed-options-for-display_meta_tags-and-set_meta_tags-methods)

      and

  - `jsonld_data` must return a hash, holding a [JSON-LD definition](https://en.wikipedia.org/wiki/JSON-LD).

For the purpose of illustration, a simple example could be adding a new file to your Solidus app, `app/models/spree/order_decorator.rb`, to implement the `jsonld_data` interface for `Spree::Order`; the override for the seo_data interface would be placed and implemented similarly. NOTE: To be clear, this extension provides no default implementation for `Spree::Order.jsonld_data` - the code below is meant solely as an example override for those new to Solidus and who, accordingly, might be unfamiliar with its override mechanics (decorators).

```ruby
# app/models/spree/order_decorator.rb

Spree::Order.class_eval do
  include SolidusSeo::Model

  def jsonld_data
    {
      "@context": "http://schema.org/",
      "@type": "Order",
      "seller": Spree::Store.default.jsonld_data,
      "customer": {
        "@type": "Person",
        "name": billing_address.full_name,
        ...
      },
      "orderedItem": [
        {
          "@type": "OrderItem",
          "orderItemNumber": line_items.first.sku,
          "orderQuantity": line_items.first.quantity,
          "orderedItem": line_items.first.product.jsonld_data,
          "orderItemStatus": "http://schema.org/OrderDelivered",
          "orderDelivery": {
            "@type": "ParcelDelivery",
            "expectedArrivalFrom": ...
          }
        }
      ]
    }
  end
end
```

After adding the new decorator, all that's left would be adding a call to `jsonld` helper on the object, such as:

```erb
<%= jsonld(@order) %>
```

In short, `jsonld` parses any object that implements the `to_jsonld` method (added by `SolidusSeo::Model` module), which in turn makes use of the `jsonld_data` method, and returns a script tag.

Besides these base methods, there are some model-specific ones for `Spree::Store` and `Spree::Product` which are explained in the following sections. These are intended to provide you with some additional common and useful data.

#### Spree::Store

Again, even without any additional work beyond the initial installation, you get a solid/basic JSON-LD definition for your `Spree::Store` model. By default:

```json
{
  "@context": "http://schema.org",
  "@type": "Store",
  "name": "Your Store Name",
  "logo": "https://yourstore.com/store_logo.jpg",
  "image": "https://yourstore.com/store_logo.jpg",
  "url": "https://yourstore.com",
  "@id": "https://yourstore.com",
}
```

Beyond this, there are properties you'll probably want to add to your store definition, like [address](https://schema.org/PostalAddress) and [profile](https://schema.org/sameAs).

We provide some data-source methods for these common properties without having to redefine the `jsonld_data` method. You can therefore easily override any of them from within your Solidus app (inside `app/models/spree/store_decorator.rb`). For example:

```ruby
# app/models/spree/store_decorator.rb

Spree::Store.class_eval do
  def address_prop
    {
      "streetAddress": "123 Custom Address St",
      "addressLocality": "Cityville",
      "addressRegion": "New Vermont",
      "postalCode": "05001",
      "addressCountry": "US"
    }
  end
end
```

The `*_prop` stubbed methods are listed below:

##### Address [ [schema] ](https://schema.org/PostalAddress)

```ruby
def address_prop
  {
    "streetAddress": "1600 Pennsylvania Avenue",
    "addressLocality": "Washington",
    "addressRegion": "District of Columbia",
    "postalCode": "20500",
    "addressCountry": "US"
  }
end
```

##### Contact points [ [schema] ](https://schema.org/ContactPoint)

```ruby
def contact_points_prop
  [
    {
      "telephone": "+11111111111",
      "contactType": "customer service",
    },
    # ...
  ]
end
```

##### Opening hours specification [ [schema] ](https://schema.org/OpeningHoursSpecification)

```ruby
def opening_hours_specification_prop
  [
    {
      "dayOfWeek": [
        "Monday",
        "Wednesday",
        "Friday"
      ],
      "opens": "12:00",
      "closes": "22:00"
    },
    # ...
  ]
end
```

##### Geo Coordinates [ [schema] ](https://schema.org/GeoCoordinates)

```ruby
def geo_prop
  {
    "latitude": -37.3,
    "longitude": -12.68
  }
end
```

##### Same as (Social profile) [ [schema] ](https://schema.org/sameAs)

```ruby
def same_as_prop
  [
    'https://facebook.com/mystore',
    'https://twitter.com/mystore',
    # ...
  ]
end
```

---

Using the sample data above, the final output would look like this :

```json
{
  "@context": "http://schema.org",
  "@type": "Store",
  "name": "Your Store Name",
  "logo": "https://yourstore.com/store_logo.jpg",
  "image": "https://yourstore.com/store_logo.jpg",
  "url": "https://yourstore.com",
  "@id": "https://yourstore.com",
  "contactPoint": [
    {
      "@type": "ContactPoint",
      "contactType": "customer service",
      "telephone": "+11111111111"
    }
  ],
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "1600 Pennsylvania Avenue",
    "addressLocality": "Washington",
    "addressRegion": "District of Columbia",
    "postalCode": "20500",
    "addressCountry": "US"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": -37.3,
    "longitude": -12.68
  },
  "sameAs": [
    "https://facebook.com/mystore",
    "https://twitter.com/mystore"
  ],
  "openingHoursSpecification": [
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": [
        "Monday",
        "Wednesday",
        "Friday"
      ],
      "opens": "12:00",
      "closes": "22:00"
    }
  ]
}
```

Finally, there are other methods that centralize common data used in multiple places in both the `seo_data` and `jsonld_data` default definitions: `seo_image`, `seo_description` and `seo_tagline`. (`seo_tagline` is a general phrase that will be shown as part of the page title on the homepage.) Again, these provide sensible default behavior and can be overridden if required.

And if you're wondering where the `seo_keywords` helper is, well, it doesn't exist - and honestly, [you should no longer care about your meta keywords at all](https://www.youtube.com/watch?v=jsuMTvc_5wE&t=21m14s).

#### Spree::Product

Beside the [`seo_data` and `jsonld_data` methods](#models), there are also some common convenience methods for this particular model, namely:
  - `seo_name`
  - `seo_url`
  - `seo_images`: An array of -at least- one absolute image url. The recommendation is to use 3 images, each with one of the following proportions: 1x1, 19:6, 4:3.
  - `seo_description`: By default, it fallbacks to the `meta_description` field or if empty, to `description`.
  - `seo_brand`: By default, it uses the name of any assigned taxon that belongs to a taxonomy named 'Brand' or 'Brands'.
  - `seo_currency`
  - `seo_price`

(NOTE: Unlike `Spree::Store` model, there are no `*_prop` methods for `Spree::Product`.)

### Image optimization

In order to enable image optimization, just tell paperclip to use `:paperclip_optimizer` processor as described in [Paperclip Optimizer's usage guide](https://github.com/wa0x6e/paperclip-optimizer#usage). We already provide a paperclip optimizer initializer and configuration file (created at `config/image_optim.yml`) with sensible defaults for a quick start and to save you some hassle. We recommend that you also optimize your pipeline assets by using `config.assets.image_optim = true` in `production.rb` (not recommended for development and test).


## Testing

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs, and [Rubocop](https://github.com/bbatsov/rubocop) static code analysis. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rake
```

When testing your application's integration with this extension you may use its factories.
Simply add this require statement to your spec_helper:

```ruby
require 'solidus_seo/factories'
```

Copyright (c) 2018 [Karma Creative LLC](https://KarmaCreative.io), released under the New BSD License
