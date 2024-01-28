## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test   #Or for testing specific function
$ forge test --match-test testFunctionName

$ forge coverage #get the test coverage
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
# with make is even easier
$ make deploy-sepolia # look into the make file to see the shortcut
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

```shell
$ forge init #initialising a new foundry project
$ forge test #running the tests
$ forge test -vv #run test and see the console outputs we can use vvv to see more
$ forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit
#The chainlink contract we can get them from the chainlink github: smartcontractkit/chainlink-brownie-contracts. This hlps for our imports
$ forge build #compile your contracts
#testing getVersion that relies on chainlink sepolia how to?
$ forge test --match-test testPriceFeedVersionIsAccurate -vvv --fork-url $SEPOLIA_RPC_URL #anvil will spin up a test environment as a copy of sepolia chain _ it will pretend as its deploying on sepolia chain! this is still expensive cause we making many calls but there are some test that mus use it.
# let look for the coverage
$ forge coverage --fork-url $SEPOLIA_RPC_URL # Or --rpc-url sameas --fork-url
$ forge test --fork-url $SEPOLIA_RPC_URL
$ forge inspect FundMe storageLayout # give us the exact layout of storage in our FundMe contract
# https://github.com/Cyfrin/foundry-devops : help to get the most recent deployed contract
$ forge install Cyfrin/foundry-devops --no-commit
$ forge install foundry-rs/forge-std@v1.7.0 --no-commit #install newest version of forge-std
#Make files allow us to create shortcuts for commands we are going to commonly use, they are great cause they allow us to automatically grab what is in our .env without us having to source .env everytime
$ sudo apt install make
$ make #make: *** No targets.  Stop. this means you have installed
# create Makefile
$ git status # you see the status because foundry automatically initialises a git repo for us if nothing then do git init -b main
$ ls
$ pwd #see the path
$ git add . #stage: add all folder and files exept the one that arein the gitignore
$ git log
$ git commit -m 'Our first commit'
$ git remote add origin https://github.com/gf75002270/foundry-fund-me-f23.git
$ git remote -v
$ git push -u origin main
# if already existing repo
$ git remote add origin https://github.com/gf75002270/foundry-fund-me-f23.git
$ git branch -M main
$ git push -u origin main
```

### chisel

```shell
# allows us to write solidity code on the terminal and execute it line by line
$ chisel
    $ !help
    # crtl+K to clear chisel terminal
```
