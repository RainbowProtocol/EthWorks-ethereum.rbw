require 'spec_helper'

describe Ethereum::Solidity do

  let (:greeter_bin) { '606060405234610000576040516102c13803806102c1833981016040528051015b5b60008054600160a060020a0319163360' }  
  let (:mortal_bin) { '606060405234610000575b60008054600160a060020a03191633600160a060020a03161790555b5b609b8061003560003960' }
  let (:mortal_abi) { '[{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]' }  
  let (:greeter_abi) { '[{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"greet","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"inputs":[{"name":"_greeting","type":"string"}],"payable":false,"type":"constructor"}]' }
  let (:contract_path) { "#{Dir.pwd}/spec/fixtures/greeter.sol" }
  let (:compiler_instance) { Ethereum::Solidity.new }
  let (:subject) { compiler_instance.compile(contract_path) }

  it "compiles contract" do
    expect(subject["greeter"]["abi"].strip).to eq greeter_abi
    expect(subject["mortal"]["abi"].strip).to eq mortal_abi
    expect(subject["greeter"]["bin"]).to start_with greeter_bin
    expect(subject["mortal"]["bin"]).to start_with mortal_bin
  end

  context "compilation error" do
    let (:contract_path) { "#{Dir.pwd}/spec/fixtures/ContractWithError.sol" }
    it { expect{ subject }.to raise_error(Ethereum::CompilationError, /.*Error: Identifier not found or not unique.*/) }
  end

  context "compilator not installed" do
    let (:compiler_instance) { Ethereum::Solidity.new("no solc") }
    it { expect{ subject }.to raise_error(SystemCallError) }
  end

end
