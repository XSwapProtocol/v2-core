pragma solidity =0.5.16;

import './interfaces/IXswapFactory.sol';
import './XswapPair.sol';

contract XswapFactory is IXswapFactory {
    bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(XswapPair).creationCode));

    address public feeToDev = 0x359ad8918A16BF0dB048eCcDbdEE761548312693;
    address public feeToMarketing = 0xb6b4677c73A16f327326F48f9bBd5e7eA9FBD580;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function getFeeTo() public view returns(address, address) {
        return (feeToDev, feeToMarketing);
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'Xswap: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'Xswap: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'Xswap: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(XswapPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IXswapPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeToDev, address _feeToMarketing) external {
        require(msg.sender == feeToSetter, 'Xswap: FORBIDDEN');
        feeToDev = _feeToDev;
        feeToMarketing = _feeToMarketing;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'Xswap: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}
