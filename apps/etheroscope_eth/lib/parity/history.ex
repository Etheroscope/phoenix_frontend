defmodule EtheroscopeEth.Parity.History do
  @moduledoc """
    EtheroscopeEth.Parity.History is the module containing functions to handle retrieval
  of a contract history from our Parity node.
  """
  use Etheroscope.Util, :parity
  alias EtheroscopeEth.Parity
  alias EtheroscopeEth.Parity.Block

  @behaviour EtheroscopeEth.Parity.Resource

  def fetch({address, variable}) do

    Logger.info "Starting from block #{Block.start_block()}"

    with contract   = Etheroscope.fetch_contract_abi(address),
         {:ok, ts}  <- address |> filter_params |> Parity.trace_filter,
         block_nums = block_numbers(ts)
    do
      # variable value at first block
      fetch_variable_state(address, variable, block_nums |> MapSet.to_list |> hd)
    end

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
  def fetch(_), do: Error.build_error(:badarg)

  def fetch_variable_state(address, variable_name, block_number) do
    variable_name
      |> Parity.keccak_value
      |> Parity.variable_value(address, Hex.to_hex(block_number))
  end

  def filter_params(address) do
      %{ "toAddress" => [address], "fromBlock" => Block.start_block() }
  end

end
