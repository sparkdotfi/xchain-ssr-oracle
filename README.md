# XChain SSR Oracle

Reports the Sky Savings Rate (SSR) values across various bridges. This is primarily used as an exchange rate between USDS (USD) and sUSDS for use by DEXs+PSMs in capital efficiency liquidity amplification. Provided the three sUSDS values (`ssr`, `chi` and `rho`) are synced you can extrapolate an exact exchange rate to any point in the future for as long as the `ssr` value does not get updated on mainnet. Because this oracle does not need to be synced unless the `ssr` changes, it can use the chain's canonical bridge for maximum security.

## Contracts

### SSROracleBase

Common functionality shared between the Mainnet and XChain instances of the oracle. Contains convenience functions to fetch the conversion rate at various levels of precision trading off gas efficiency. sUSDS data is compressed into a single word to save SLOAD gas cost.

### SSRMainnetOracle

Mainnet instance pulls data directly from the `sUSDS` as it is on the same chain. It's not clear the use case for this beyond consistency and some gas savings, but it was included none-the-less.

### SSRAuthOracle

Oracle receives data from an authorized data provider. This is intended to be one or more bridges which publish data to the oracle. Application-level sanity checks are included when new data is proposed to minimize damage in the event of a bridge being compromised. These sanity checks also enforce event ordering in case messages are relayed out of order. `maxSSR` is used as an upper bound to prevent exchange rates that are wildly different from reality. It is recommended to sync this oracle somewhat frequently to minimize the damage of a compromised bridge.

### Forwarders + Receivers

These are bridge-specific messaging contracts. Forwarders permissionlessly relay `sUSDS` data. Receivers decode this message and forward it to the `SSRAuthOracle`. Please note that receivers are generic and part of the `xchain-helpers` repository.

## Supported Chains

 * Optimism
 * Base
 * World Chain
 * Aribitrum One
 * Gnosis Chain

## Deployment Instructions

Run `make deploy-XXX` where XXX is one of the supported networks. Be sure to have the `ETH_FROM` environment variable set to the deployer address as well as the relevant environment variables set for RPCs and contract verification. You can see contract verification api key names in `foundry.toml`.

## Deployments (USDS)

### Arbitrum

Forwarder (Ethereum): [0x1A229AdbAC83A948226783F2A3257B52006247D5](https://etherscan.io/address/0x1A229AdbAC83A948226783F2A3257B52006247D5#code)  
AuthOracle (Arbitrum): [0xEE2816c1E1eed14d444552654Ed3027abC033A36](https://arbiscan.io/address/0xEE2816c1E1eed14d444552654Ed3027abC033A36#code)  
Receiver (Arbitrum): [0x567214Dc57a2385Abc4a756f523ddF0275305Cbc](https://arbiscan.io/address/0x567214Dc57a2385Abc4a756f523ddF0275305Cbc#code)  
Chainlink Rate Provider (Arbitrum): [0x84AB0c8C158A1cD0d215BE2746cCa668B79cc287](https://arbiscan.io/address/0x84AB0c8C158A1cD0d215BE2746cCa668B79cc287#code)  
Balancer Rate Provider (Arbitrum): [0xc0737f29b964e6fC8025F16B30f2eA4C2e2d6f22](https://arbiscan.io/address/0xc0737f29b964e6fC8025F16B30f2eA4C2e2d6f22#code)  

### Base

Forwarder (Ethereum): [0xB2833392527f41262eB0E3C7b47AFbe030ef188E](https://etherscan.io/address/0xB2833392527f41262eB0E3C7b47AFbe030ef188E#code)  
AuthOracle (Base): [0x65d946e533748A998B1f0E430803e39A6388f7a1](https://basescan.org/address/0x65d946e533748A998B1f0E430803e39A6388f7a1#code)  
Receiver (Base): [0x212871A1C235892F86cAB30E937e18c94AEd8474](https://basescan.org/address/0x212871A1C235892F86cAB30E937e18c94AEd8474#code)  
Chainlink Rate Provider (Base): [0x026a5B6114431d8F3eF2fA0E1B2EDdDccA9c540E](https://basescan.org/address/0x026a5B6114431d8F3eF2fA0E1B2EDdDccA9c540E#code)  
Balancer Rate Provider (Base): [0x49aF4eE75Ae62C2229bb2486a59Aa1a999f050f0](https://basescan.org/address/0x49aF4eE75Ae62C2229bb2486a59Aa1a999f050f0#code)  

### Optimism

Forwarder (Ethereum): [0x6Ac25B8638767a3c27a65597A74792d599038724](https://etherscan.io/address/0x6Ac25B8638767a3c27a65597A74792d599038724#code)  
AuthOracle (Optimism): [0x6E53585449142A5E6D5fC918AE6BEa341dC81C68](https://optimistic.etherscan.io/address/0x6E53585449142A5E6D5fC918AE6BEa341dC81C68#code)  
Receiver (Optimism): [0xE2868095814c2714039b3A9eBEE035B9E2c411E5](https://optimistic.etherscan.io/address/0xE2868095814c2714039b3A9eBEE035B9E2c411E5#code)  
Chainlink Rate Provider (Optimism): [0x8e3b08e65cC59d293932F5e9aF3186970087a529](https://optimistic.etherscan.io/address/0x8e3b08e65cC59d293932F5e9aF3186970087a529#code)  
Balancer Rate Provider (Optimism): [0xe1e4953C93Da52b95eDD0ffd910565D3369aCd6b](https://optimistic.etherscan.io/address/0xe1e4953C93Da52b95eDD0ffd910565D3369aCd6b#code)  

## Legacy Deployments (DAI)

### World Chain

Forwarder (Ethereum): [0xA34437dAAE56A7CC6DC757048933D7777b3e547B](https://etherscan.io/address/0xA34437dAAE56A7CC6DC757048933D7777b3e547B#code)  
AuthOracle (World Chain): [0x779053E25267B591Dcfbb20b2397462aaaD6B776](https://worldchain-mainnet.explorer.alchemy.com/address/0x779053E25267B591Dcfbb20b2397462aaaD6B776?tab=contract)  
Receiver (World Chain): [0x33a3aB524A43E69f30bFd9Ae97d1Ec679FF00B64](https://worldchain-mainnet.explorer.alchemy.com/address/0x33a3aB524A43E69f30bFd9Ae97d1Ec679FF00B64?tab=contract)  
Balancer Rate Provider (World Chain): [0xE206AEbca7B28e3E8d6787df00B010D4a77c32F3](https://worldchain-mainnet.explorer.alchemy.com/address/0xE206AEbca7B28e3E8d6787df00B010D4a77c32F3?tab=contract)  

### Optimism

Forwarder (Ethereum): [0x4042127DecC0cF7cc0966791abebf7F76294DeF3](https://etherscan.io/address/0x4042127DecC0cF7cc0966791abebf7F76294DeF3#code)  
AuthOracle (Optimism): [0x33a3aB524A43E69f30bFd9Ae97d1Ec679FF00B64](https://optimistic.etherscan.io/address/0x33a3ab524a43e69f30bfd9ae97d1ec679ff00b64#code)  
Receiver (Optimism): [0xE206AEbca7B28e3E8d6787df00B010D4a77c32F3](https://optimistic.etherscan.io/address/0xE206AEbca7B28e3E8d6787df00B010D4a77c32F3#code)  
Balancer Rate Provider (Optimism): [0x15ACEE5F73b36762Ab1a6b7C98787b8148447898](https://optimistic.etherscan.io/address/0x15ACEE5F73b36762Ab1a6b7C98787b8148447898#code)  

### Base

Forwarder (Ethereum): [0x8Ed551D485701fe489c215E13E42F6fc59563e0e](https://etherscan.io/address/0x8Ed551D485701fe489c215E13E42F6fc59563e0e#code)  
AuthOracle (Base): [0x2Dd2a2Fe346B5704380EfbF6Bd522042eC3E8FAe](https://basescan.org/address/0x2Dd2a2Fe346B5704380EfbF6Bd522042eC3E8FAe#code)  
Receiver (Base): [0xaDEAf02Ddb5Bed574045050B8096307bE66E0676](https://basescan.org/address/0xaDEAf02Ddb5Bed574045050B8096307bE66E0676#code)  
Balancer Rate Provider (Base): [0xeC0C14Ea7fF20F104496d960FDEBF5a0a0cC14D0](https://basescan.org/address/0xeC0C14Ea7fF20F104496d960FDEBF5a0a0cC14D0#code)  

### Arbitrum

Forwarder (Ethereum): [0x7F36E7F562Ee3f320644F6031e03E12a02B85799](https://etherscan.io/address/0x7F36E7F562Ee3f320644F6031e03E12a02B85799#code)  
AuthOracle (Arbitrum): [0xE206AEbca7B28e3E8d6787df00B010D4a77c32F3](https://arbiscan.io/address/0xE206AEbca7B28e3E8d6787df00B010D4a77c32F3#code)  
Receiver (Arbitrum): [0xcA61540eC2AC74E6954FA558B4aF836d95eCb91b](https://arbiscan.io/address/0xcA61540eC2AC74E6954FA558B4aF836d95eCb91b#code)  
Balancer Rate Provider (Arbitrum): [0x73750DbD85753074e452B2C27fB9e3B0E75Ff3B8](https://arbiscan.io/address/0x73750DbD85753074e452B2C27fB9e3B0E75Ff3B8#code)  

***
*The IP in this repository was assigned to Mars SPC Limited in respect of the MarsOne SP*
