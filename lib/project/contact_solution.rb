### Example Usage
#
#   # Grab all phones for some contact
#   some_contact = ContactSolution.all.first
#   phones = some_contact.phones
#   # Now read out the first phone (if it has at least 1)
#   if phones.moveToFirst
#     mp ContactSolution.read_number(phones)
#   end
#
# => OR
#
#   # Grab ALL THE PHONES!!
#   all_phones = ContactSolution.find_phones
#
# => AND
#
#   # Give me the first mobile phone
#   ContactSolution.get_number_by_type(some_phones, ContactSolution::PHONE_TYPE_MOBILE)

class ContactSolution

  # Useful constants
  PHONE_NUMBER = "data1"
  PHONE_TYPE = "data2"
  PHONE_CONTACT_ID = "contact_id"
  PHONE_TYPE_HOME = 1
  PHONE_TYPE_MOBILE = 2
  PHONE_TYPE_WORK = 3

  def self.context
    PMApplication.current_application.context
  end

  def self.query
    uri = Potion::Contacts::CONTENT_URI
    projection = [
      Potion::Contacts::LOOKUP_KEY,
      Potion::Contacts::DISPLAY_NAME,
      Potion::Contacts::HAS_PHONE_NUMBER
    ]
    selection = Potion::Contacts::HAS_PHONE_NUMBER + " = '1'"
    selection_args = nil
    sort_order = Potion::Contacts::DISPLAY_NAME + " COLLATE LOCALIZED ASC"

    # (Android::Provider::ContactsContract::CommonDataKinds::Phone::CONTENT_URI, nil, Android::Provider::ContactsContract::ContactsContract::CommonDataKinds::Phone::CONTACT_ID + " = ?", id.to_s, nil)
    # mp Android::Provider::ContactsContract::CommonDataKinds::Phone::CONTENT_URI

    context.getContentResolver.query(uri, projection, selection, selection_args, sort_order)
  end

  def self.each(&block)
    cursor = query
    return if cursor.count == 0

    while cursor.moveToNext
      block.call ContactSolution.new(cursor)
    end
    cursor
  end

  def self.all
    contacts = []
    self.each do |c|
      contacts << c
    end
    contacts
  end

  def initialize(cursor)
    @properties = {
      key:      cursor.getString(0),
      name:     cursor.getString(1),
    }
  end

  def key
    @properties[:key]
  end

  def name
    @properties[:name]
  end

  def first_name
    name.split(" ", 2).first
  end

  def last_name
    name.split(" ", 2).last
  end

  def to_s
    super + " " + @properties.to_s
  end

  # contact_id seems to be an integer
  # display_name is first and last name
  def phones
    self.class.find_phones(name: self.name)
  end

  def self.find_phones(opts={})
     # overwriting options
    selection = nil
    selection = "#{PHONE_CONTACT_ID} = '#{contact_id}'" if opts[:contact_id]
    selection = "DISPLAY_NAME = '#{opts[:name]}'" if opts[:name]
    context.getContentResolver.query(Potion::PHONE_CONTENT_URI, nil, selection, nil, nil)
  end

  # Read phone number string out of cursor
  def self.read_number(phone_cursor)
    phone_cursor.getString(phone_cursor.getColumnIndex(PHONE_NUMBER))
  end

  def contacturi_from_key(contact_key)
    muri = Potion::Contacts.getLookupUri(0,contact_key)
    Potion::Contacts.lookupContact(self.class.context.getContentResolver(), muri)
  end

  # Searches and returns first number of that phone_type
  def self.get_number_by_type(phone_cursor, phone_type)
    mobile_number = nil
    # Iterate over phones
    while phone_cursor.moveToNext do
      current_phone_type = phone_cursor.getInt(phone_cursor.getColumnIndex(ContactSolution::PHONE_TYPE))
      mobile_number = read_number(phone_cursor) if current_phone_type == phone_type
      break if mobile_number
    end

    mobile_number
  end

  # Jamon's original work, not really sure how close it was, but had trouble with it.
  # Left here for reference and reuse
  # def phone_record
  #   # Revisit this ->   http://stackoverflow.com/questions/3754217/android-manage-contacts-with-lookup-key
  #   uri = Android::Net::Uri::Builder.new.tap{|b| b.path("content://vnd.android.cursor.dir/phone_v2") }.build
  #   self.class.context.getContentResolver.query(uri, [ "data1" ], "lookup = ?", [ self.key ], nil)
  # end
end
