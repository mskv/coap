defmodule Coap.Records do
  require Record
  Record.defrecord :coap_content, Record.extract(
    :coap_content, from_lib: "gen_coap/include/coap.hrl"
  )
end
