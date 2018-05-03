Spree::Sample.load_sample("taxonomies")
Spree::Sample.load_sample("products")

categories = Spree::Taxonomy.find_by!(name: I18n.t('spree.taxonomy_categories_name'))
brands = Spree::Taxonomy.find_by!(name: I18n.t('spree.taxonomy_brands_name'))

products = {
  ror_tote: "保养鞋",
  ror_bag: "喷磨砂",
  ror_mug: "干洗鞋",
  ror_stein: "清洗鞋",
  ror_baseball_jersey: "翻新鞋",
  ror_jr_spaghetti: "修复鞋",
  spree_bag: "清洗上色保养",
  spree_stein: "清洗特级保养",
  spree_mug: "封边油",
  spree_ringer: "维修类",

}

products.each do |key, name|
  products[key] = Spree::Product.find_by!(name: name)
end

taxons = [
  {
    name: I18n.t('spree.taxonomy_categories_name'),
    taxonomy: categories,
    position: 0
  },
  {
    name: "鞋",
    taxonomy: categories,
    parent: I18n.t('spree.taxonomy_categories_name'),
    position: 1,
    products: [
      products[:ror_tote],
      products[:ror_bag],
      products[:ror_mug],
      products[:ror_stein],
      products[:ror_baseball_jersey],
      products[:ror_jr_spaghetti]
    ]
  },
  {
    name: "包",
    taxonomy: categories,
    parent: I18n.t('spree.taxonomy_categories_name'),
    position: 2,
    products: [
      products[:spree_bag],
      products[:spree_stein],
      products[:spree_mug],
      products[:spree_ringer]
    ]
  }
]

taxons.each do |taxon_attrs|
  parent = Spree::Taxon.where(name: taxon_attrs[:parent]).first
  taxonomy = taxon_attrs[:taxonomy]

  taxon = Spree::Taxon.where(name: taxon_attrs[:name]).first_or_create!
  taxon.parent = parent
  taxon.taxonomy = taxonomy
  taxon.save
  taxon.products = taxon_attrs[:products] if taxon_attrs[:products]
end
