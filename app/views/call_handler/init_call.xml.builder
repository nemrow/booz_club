xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1) do
    xml.Say "A customer in your area would like to buy #{@search.description}, do you have it in stock?"
    xml.Say "Please press 1 for yes or 2 for No, thanks!"
    xml.Play "https://s3-us-west-2.amazonaws.com/booz-club/boozclub.mp3"
    xml.Say "Please press 1 if you have #{@search.description} in stock, or 2 if you do not."
    xml.Play "https://s3-us-west-2.amazonaws.com/booz-club/boozclub.mp3"
  end
end
