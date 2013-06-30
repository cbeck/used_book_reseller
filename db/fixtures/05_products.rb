Status.enumeration_model_updates_permitted = true
Status.destroy_all
avail = Status.create :name => 'Available'
unavailable = Status.create :name => 'Currently Unavailable'
pending = Status.create :name => 'Pending'
shipped = Status.create :name => 'Shipped'
completed = Status.create :name => 'Sale Completed'

# ItemFormat.enumeration_model_updates_permitted = true
ItemFormat.destroy_all
paperback = ItemFormat.create :name => 'Paperback'
hardcover = ItemFormat.create :name => 'Hardcover'
spiral = ItemFormat.create :name => 'Spiral Bound'
library = ItemFormat.create :name => 'Library Binding'
cd = ItemFormat.create :name => 'CD'
dvd = ItemFormat.create :name => 'DVD'
cassette = ItemFormat.create :name => 'Audio Cassette'
cd-rom = ItemFormat.create :name => 'CD-ROM'
other = ItemFormat.create :name => 'Other'

# PaymentType.enumeration_model_updates_permitted = true
PaymentType.destroy_all
paypal = PaymentType.create :name => 'PayPal'

Publisher.destroy_all
prag = Publisher.create :name => 'The Pragmatic Bookshelf', :url => 'http://www.pragprog.com/'

Category.destroy_all
religion =    Category.create :name => "Religion / Devotional"
math =        Category.create :name => "Math"
history =     Category.create :name => "History"
literature =  Category.create :name => "Literature"
langarts =    Category.create :name => "Language Arts"
grammar =     Category.create :name => "Grammar"
writing =     Category.create :name => "Writing"
spelling =    Category.create :name => "Spelling"
reading =     Category.create :name => "Reading"
foreign =     Category.create :name => "Foreign Languages"
science =     Category.create :name => "Science / Nature"
technology =  Category.create :name => "Technology"
games =       Category.create :name => "Games / Toys"
unitstudy =   Category.create :name => "Unit Studies"
complete =    Category.create :name => "Complete Curriculum"
teacher =     Category.create :name => "Teacher Resources / Encouragement"
misc =        Category.create :name => "Miscellaneous"
art =         Category.create :name => "Art"
music =       Category.create :name => "Music"
economics =   Category.create :name => "Business / Economics"
social =     Category.create :name => "Social Studies / Cultures"
health =      Category.create :name => "Health / Physical Education"
civics =      Category.create :name => "Civics / Government"

AmazonProduct.destroy_all
Product.destroy_all

def create_product(isbn, cats=[])
  p = Product.load_from_amazon isbn
  p.category_ids = cats.collect{|c| c.id}
  p.save
end

Product.fetch! '0060777508', [religion]
Product.fetch! '0929239571', [religion]

Product.fetch! '1565771389', [math]
Product.fetch! '0939798824', [math]
Product.fetch! '093979845X', [math]

Product.fetch! '141657588X', [history]
Product.fetch! '0131955411', [history, art]
Product.fetch! '0060838655', [history]

Product.fetch! '0205606695', [literature]
Product.fetch! '1580495834', [literature]
Product.fetch! '0142437263', [literature]
Product.fetch! '0979760909', [literature]

Product.fetch! '0131177354', [langarts]
Product.fetch! '0131177990', [langarts]
Product.fetch! '0325009430', [langarts]

Product.fetch! '0764134361', [grammar]
Product.fetch! '0134369629', [grammar]

Product.fetch! '0060891548', [writing]
Product.fetch! '0060519606', [writing]
Product.fetch! '0130257133', [writing]

Product.fetch! '0765224801', [spelling]
Product.fetch! '076522481X', [spelling]

Product.fetch! '0979631300', [reading, teacher]
Product.fetch! '0132277212', [reading]

Product.fetch! '0486280861', [foreign]
Product.fetch! '0972947418', [foreign]
Product.fetch! '0970121881', [foreign]

Product.fetch! '1580625576', [science]
Product.fetch! '0471044563', [science]
Product.fetch! '0769639453', [science]

Product.fetch! '0974514055', [technology]
Product.fetch! '0672328844', [technology]
Product.fetch! '0976694042', [technology]

Product.fetch! '080692845X', [games]
Product.fetch! 'B000EPFFJC', [games]
Product.fetch! 'B00011F5DK', [games]
Product.fetch! 'B000930CSS', [games]

Product.fetch! 'B000FAAJV0', [unitstudy]
Product.fetch! '1880892421', [unitstudy]

Product.fetch! '0876592280', [complete]
Product.fetch! '0876592825', [complete]
Product.fetch! '1561893749', [complete]

Product.fetch! '0787994553', [teacher]
Product.fetch! '0071472800', [teacher]

Product.fetch! '0805431381', [misc]
Product.fetch! '0736909184', [misc]

Product.fetch! '0495500321', [art]
Product.fetch! '0131743201', [art]

Product.fetch! '0393979903', [music]
Product.fetch! '0393928039', [music]

Product.fetch! '0073126632', [economics]
Product.fetch! '0324224729', [economics]

Product.fetch! '0131712705', [social]
Product.fetch! '0131591819', [social]

Product.fetch! '0321523024', [health]
Product.fetch! '007351621X', [health]
Product.fetch! '0495090654', [health]

Product.fetch! '0205511414', [civics]
Product.fetch! '0321473140', [civics]

Product.find(:all).each {|p| p.seller = @@seller; p.save }

# Product.fetch! '', []

puts "Created #{Product.count} products"
