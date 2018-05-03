Spree::Sample.load_sample("option_values")
Spree::Sample.load_sample("products")

p1 = Spree::Product.find_by!(name: "保养鞋")
p2 = Spree::Product.find_by!(name: "喷磨砂")
p3 = Spree::Product.find_by!(name: "干洗鞋")
p4 = Spree::Product.find_by!(name: "清洗鞋")
p5 = Spree::Product.find_by!(name: "翻新鞋")
p6 = Spree::Product.find_by!(name: "修复鞋")

p11 = Spree::Product.find_by!(name: "清洗上色保养")
p12 = Spree::Product.find_by!(name: "清洗特级保养")
p13 = Spree::Product.find_by!(name: "封边油")
p14 = Spree::Product.find_by!(name: "维修类")



small = Spree::OptionValue.where(name: "低规").first
medium = Spree::OptionValue.where(name: "中规").first
large = Spree::OptionValue.where(name: "高规").first

products = [p1,p2,p3,p4,p5,p6, p11,p12,p13,p14]
options = [small, medium, large]
variants = []
products.each_with_index{|pn,i|
  options.each_with_index{|o,j|
    variant = { product: pn, option_values: [o], sku: "YF-00#{i}#{j}", cost_price: rand(100) }
    variants.push variant
  }
}


# masters = {
#   ror_baseball_jersey => {
#     sku: "ROR-001",
#     cost_price: 17,
#   },
#   ror_tote => {
#     sku: "ROR-00011",
#     cost_price: 17
#   },
#   ror_bag => {
#     sku: "ROR-00012",
#     cost_price: 21
#   },
#   ror_jr_spaghetti => {
#     sku: "ROR-00013",
#     cost_price: 17
#   },
#   ror_mug => {
#     sku: "ROR-00014",
#     cost_price: 11
#   },
#   ror_ringer => {
#     sku: "ROR-00015",
#     cost_price: 17
#   },
#   ror_stein => {
#     sku: "ROR-00016",
#     cost_price: 15
#   },
#   apache_baseball_jersey => {
#     sku: "APC-00001",
#     cost_price: 17
#   },
#   ruby_baseball_jersey => {
#     sku: "RUB-00001",
#     cost_price: 17
#   },
#   spree_baseball_jersey => {
#     sku: "SPR-00001",
#     cost_price: 17
#   },
#   spree_stein => {
#     sku: "SPR-00016",
#     cost_price: 15
#   },
#   spree_jr_spaghetti => {
#     sku: "SPR-00013",
#     cost_price: 17
#   },
#   spree_mug => {
#     sku: "SPR-00014",
#     cost_price: 11
#   },
#   spree_ringer => {
#     sku: "SPR-00015",
#     cost_price: 17
#   },
#   spree_tote => {
#     sku: "SPR-00011",
#     cost_price: 13
#   },
#   spree_bag => {
#     sku: "SPR-00012",
#     cost_price: 21
#   }
# }

variants.each do |attrs|
  if Spree::Variant.where(product_id: attrs[:product].id, sku: attrs[:sku]).none?
    Spree::Variant.create!(attrs)
  end
end

#masters.each do |product, variant_attrs|
#  product.master.update_attributes!(variant_attrs)
#end
