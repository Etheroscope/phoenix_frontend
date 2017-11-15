defmodule EtheroscopeEth.Parity.History do
  @moduledoc """
    EtheroscopeEth.Parity.History is the module containing functions to handle retrieval
  of a contract history from our Parity node.
  """
  use Etheroscope.Util
  alias EtheroscopeEth.Parity

  @behaviour EtheroscopeEth.Parity.Resource

  def fetch(address) do
    # fetch contract

    Logger.info "Fetching contract from block 0"
    result = Parity.trace_filter(filter_params(address))

#
#     const contract = await (contractABICache.get(address));
# console.timeEnd('Contract retrieval');
#
# console.log('From block: 0');
#
# console.time('Trace filter request');
# const events = await promisify(web3.trace.filter, web3.trace)({"toAddress": [address]});
# console.timeEnd('Trace filter request');
#
# console.log('Browsing through ' + events.length + ' transactions');
#
# var history = [];
# var i = 0;
# var prevTime = 0;
# for (let event of events) {
#   console.log(event)
#   const time = await blockTimeCache.get(event.blockNumber);
#   if (time === prevTime) continue;
#   prevTime = time;
#   const val = await promisify(contract[variable], contract)(event.blockNumber);
#   history.push({time, val});
#   console.log('Fetched: ' + i++ + ' time: ' + time + ' val: ' + val);
# }
# history.sort((a, b) => a[0] - b[0]);
# console.timeEnd('Whole history');
# return Promise.resolve(history);
  end

  def filter_params(address) do
      %{ "toAddress" => [address], "fromBlock" => Hex.to_hex(Parity.current_block_number - 200_000) }
  end

end
