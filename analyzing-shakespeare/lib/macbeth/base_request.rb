require 'net/http'

class BaseRequest
  MACBETH_URL = 'http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml'

  def self.fetch_xml
    Net::HTTP.get(URI(MACBETH_URL))
  end
end
