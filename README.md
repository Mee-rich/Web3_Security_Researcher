# Reentrancy PoC – VulnerableBank

## Vulnerability
Reentrancy due to external call before state update.

## Impact
Attacker can drain all ETH from the contract.

## Exploit Flow
1. Attacker deposits ETH
2. Calls withdraw
3. Re-enters via receive()
4. Drains full balance

## Mitigation
- Use checks-effects-interactions
- Add reentrancy guard

# Access Control PoC - Vault Ownership Takeover

## Vulnerability
Missing access control on `setOwner()` allows anyone to become owner.

## Impact
Full fund drain by unauthorized attacker.

## Exploit Steps
1. Attacker calls `setOwner(attacker)`
2. Attacker calls `withdrawAll()`
3. Vault balance drained

## Root Cause
Lack of access modifier n privileged function

## Mitigation
- Add `onlyOwner` modifier
- Use OpenZeppelin `ownable`


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
$ forge test
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
