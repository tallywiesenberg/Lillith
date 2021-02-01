import json

from eth_account import Account
from decouple import config
from web3 import Web3
from web3.middleware import geth_poa_middleware
'''Rinkeby deployment'''
w3 = Web3(Web3.HTTPProvider(config('PROVIDER')))
print(w3.isConnected())

# w3.middleware_onion.inject(geth_poa_middleware, layer=0)

w3.eth.defaultAccount = "0x077acFebbde9fE5B055B51304B21F5b5f20BaDec"

#open contract data, as compiled by Truffle
with open('build/contracts/Lillith.json', 'r') as f:
    data = json.load(f)
    bytecode = data['bytecode']
    abi = data['abi']

lillith_predeployed = w3.eth.contract(abi=abi, bytecode=bytecode)
# tx_hash = lillith_predeployed.constructor(1*10**21).buildTransaction({
#     'from': Web3.toChecksumAddress(w3.eth.defaultAccount.address),
#     'nonce': w3.eth.getTransactionCount(w3.eth.defaultAccount.address)
# })

# signed = w3.eth.defaultAccount.sign_transaction(tx_hash)

# w3.eth.sendRawTransaction(signed.rawTransaction)


tx_hash = lillith_predeployed.constructor(1*10**21).transact()

tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)


lillith_deployed = w3.eth.contract(
    address=tx_receipt.contractAddress,
    abi=abi
)