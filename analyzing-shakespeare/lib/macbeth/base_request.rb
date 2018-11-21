require 'net/http'

class BaseRequest
  MACBETH_URL = URI('http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml')

  def macbeth_xml
    Net::HTTP.get(MACBETH_URL)
  end
end
