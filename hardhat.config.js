require("dotenv").config();

let mnemonic = process.env.MNEMONIC;

module.exports = {
    paths: {
        artifacts: "./artifacts"
    },
    solidity: {
        version: "0.5.16",
        settings: {
            optimizer: {
                enabled: true,
                runs: 200,
            },
        },
    },
    networks: {
        xdc: {
            url: "https://rpc.xinfin.network",
            chainId: 50,
            accounts: {
                mnemonic: mnemonic,
                initialIndex: 1,
            }
        },
        xdctest: {
            url: "https://rpc.apothem.network",
            chainId: 51,
            accounts: {
                mnemonic: mnemonic,
                initialIndex: 1,
            }
        },
    },
};
