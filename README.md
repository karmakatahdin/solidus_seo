# SolidusSeo

Successful stores keep SEO as a top priority. This Solidus extension adds common-sense defaults for structured data, meta tags, Open Graph protocol and image optimization.

## Installation

Add `solidus_seo` to your Gemfile:

```ruby
gem 'deface'
gem 'solidus_seo'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g solidus_seo:install
```

## Usage

### Views

We use [Deface](https://github.com/spree/deface) to insert some helpers that generate the meta data. This, of course, only works if you're using/overriding solidus views.

Otherwise, if you're using custom non-solidus views, we assume you're smart enough to figure out where to put those helpers ;)

These are the modifications we do, via deface, in solidus views as part of the minimal installation:

- In `spree/shared/_head.html.erb`:
  - Replace `<%== meta_data_tags %>` line for `<%= display_meta_tags %>`.
  - Remove `<title>` tag (`display_meta_tags` generates the title tag).


- In `spree/layouts/spree_application.html.erb`
  - Insert `<%= dump_jsonld %>` just before the `</body>` closing  tag.


- In `spree/products/show.html.erb`:
  - Insert `<%= jsonld @product %>` anywhere inside the `cache` block.


- In `spree/shared/_products.html.erb`:
  - Insert `<% jsonld_list(products) %>` at the bottom of file. (Notice this helper doesn't generate output)

Make sure you've added your store metadata from the Solidus store administration page, like SEO title, store URL and meta description.

At this point, the features you've gained are:

  - Default meta tags with and open graph tags, describing a product in PDP pages and store/site in all other pages.
  - Store jsonld markup on all your pages.
  - Product jsonld markup in PDP pages.
  - Breadcrumb jsonld markup in taxon pages.
  - Lists in your paginated product pages.

### Models

This gem defines some methods in your models to be used as an interface/source of your meta data. It already provides some useful defaults that can be easily extended and customized, all inside your Spree models, via decorators.

You can override any of these **base methods** with your own data source. We recommend you to look at the source (TODO: Add link) to base off your work.

  - `seo_data` must return a hash with the same structure expected by  [`set_meta_tags`](https://github.com/kpumuk/meta-tags#allowed-options-for-display_meta_tags-and-set_meta_tags-methods)
  - `jsonld_data` must return a hash, holding a [jsonld definition](https://en.wikipedia.org/wiki/JSON-LD).

Beside these methods, there are some model-specific ones that let you provide some common and useful data.

#### Spree::Store

This is the base jsonld definition for your Spree::Store model, by default:

```json
{
  "@context": "http://schema.org",
  "@type": "Organization",
  "name": "Your Store Name",
  "logo": "https://yourstore.com/store_logo.jpg",
  "image": "https://yourstore.com/store_logo.jpg",
  "url": "https://yourstore.com",
  "@id": "https://yourstore.com",
}
```

There are properties you'll want to add to your store definition, like [address](https://schema.org/PostalAddress) or [profile](https://schema.org/sameAs).

We provide some data-source methods for these common properties without having to redefine the `jsonld_data` method.


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
  "@type": "Organization",
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

Finally, there are other methods that centralize common data used in multiple places in both `seo_data` and `jsonld_data` default definitions: `seo_image`, `seo_description` and `seo_tagline`. `seo_tagline` is a general phrase that will be shown as part of the page title in the homepage.

If you're wondering where `seo_keywords` is, [you should no longer care about it](https://www.youtube.com/watch?v=jsuMTvc_5wE&t=21m14s).

#### Spree::Product

Beside the [`*_data` methods](#Models) for models, there are some common methods for this model, namely:
  - `seo_name`
  - `seo_url`
  - `seo_images`: An array of -at least- one absolute image url. Recommendation is to use 3 images, each with one of the following proportions: 1x1, 19:6, 4:3.
  - `seo_description`: By default, it fallbacks to `meta_description` field or if empty, to `description`.
  - `seo_brand`: By default, it uses the name of any taxon assigned that belongs to a 'Brands' taxonomy.
  - `seo_currency`
  - `seo_price`

Unlike `Spree::Store` model, there are no `*_prop` methods for `Spree::Product`.

### Image optimization

In order to enable image optimization, just tell paperclip to use `:paperclip_optimizer` processor as described in [Paperclip Optimizer's usage guide](https://github.com/wa0x6e/paperclip-optimizer#usage). We already provide a paperclip optimizer initializer and configuration file (created at `config/image_optim.yml`) with sensible defaults for a quick start and save you some hassle. We recommend you to also optimize your pipeline assets by using `config.assets.image_optim = true` in `production.rb` (not recommended for development and test).


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

Copyright (c) 2018 Karma Creative LLC, released under the New BSD License
