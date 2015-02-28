xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1) do
    xml.Say "A potential customer would like to know if you have #{@search.description} in stock."
    xml.Say "Please press 1 if you do. Or press 2 if you do not."
    xml.Play 'http://linode.rabasa.com/cantina.mp3'
  end
end
