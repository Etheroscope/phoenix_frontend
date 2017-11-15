defmodule EtheroscopeEth.Parity.History do
  @moduledoc """
    EtheroscopeEth.Parity.History is the module containing functions to handle retrieval
  of a contract history from our Parity node.
  """
  use Etheroscope.Util, :parity
  alias EtheroscopeEth.Parity

  @behaviour EtheroscopeEth.Parity.Resource

  def fetch(address, variable) do

    Logger.info "Starting from block #{start_block()}"

    contract = Etheroscope.fetch_contract_abi(address)
    transactions = Parity.trace_filter(filter_params(address))

    require IEx
    IEx.pry()

    block_numbers(transactions)


    # console.time('Contract retrieval');
    # const abiJSON = await (contractABICache.get(address));
    # const contract =  web3.eth.contract(abiJSON).at(address);
    # console.timeEnd('Contract retrieval');
    #
    # const startBlock = web3.eth.blockNumber - 75000;
    # console.log('From block:', startBlock);
    #
    # console.log('Sending trace filter request');
    # console.time('Trace filter request');
    # const events = await promisify(web3.trace.filter, web3.trace)({
    #   "fromBlock": "0x" + startBlock.toString(16),
    #   "toAddress": [address]
    # });
    # console.timeEnd('Trace filter request');
    #
    # console.log('Browsing through ' + events.length + ' transactions');
    #
    # var history = [];
    # var i = 0;
    # await Promise.all(events.map(async ({blockNumber}) => {
    #   console.log('Requesting data for block number #' + blockNumber)
    #   const timePromise = blockTimeCache.get(blockNumber);
    #   const valPromise = promisify(contract[variable], contract)(blockNumber);
    #   history.push({time: await timePromise, value: await valPromise});
    #   console.log(`Fetched: ${i++} values`);
    # }));
    # history.sort((a, b) => a[0] - b[0]);
    #
    # console.timeEnd('Whole history');
    # return history;
  end

  def fetch_variable_state(address, variable, block_number) do

  end

  def filter_params(address) do
      %{ "toAddress" => [address], "fromBlock" => start_block() }
  end

  defp start_block do
    Hex.to_hex(Parity.current_block_number - 75_000)
  end

end
