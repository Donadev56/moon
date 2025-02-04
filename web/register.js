

const regContract = {
    address: '0xC4A39C048177A339a3C46759B89a9eC01c56407a',
    abi: [
      {
        inputs: [
          { internalType: 'address', name: 'ownerAddress', type: 'address' },
          { internalType: 'address', name: '_contract', type: 'address' },
        ],
        stateMutability: 'nonpayable',
        type: 'constructor',
      },
      {
        anonymous: false,
        inputs: [
          {
            indexed: false,
            internalType: 'address',
            name: 'user',
            type: 'address',
          },
          {
            indexed: false,
            internalType: 'string',
            name: 'userId',
            type: 'string',
          },
          {
            indexed: false,
            internalType: 'string',
            name: 'uplineId',
            type: 'string',
          },
          {
            indexed: false,
            internalType: 'string',
            name: 'name',
            type: 'string',
          },
        ],
        name: 'Initialized',
        type: 'event',
      },
      {
        anonymous: false,
        inputs: [
          {
            indexed: false,
            internalType: 'address',
            name: 'userAddress',
            type: 'address',
          },
          {
            indexed: false,
            internalType: 'string',
            name: 'userId',
            type: 'string',
          },
          {
            indexed: false,
            internalType: 'string',
            name: 'uplineId',
            type: 'string',
          },
          {
            indexed: false,
            internalType: 'string',
            name: 'name',
            type: 'string',
          },
        ],
        name: 'UserRegistered',
        type: 'event',
      },
      {
        anonymous: false,
        inputs: [
          {
            indexed: false,
            internalType: 'address',
            name: 'user',
            type: 'address',
          },
          {
            indexed: false,
            internalType: 'string',
            name: 'newName',
            type: 'string',
          },
        ],
        name: 'newNameUpdated',
        type: 'event',
      },
      {
        anonymous: false,
        inputs: [
          {
            indexed: false,
            internalType: 'address',
            name: 'user',
            type: 'address',
          },
        ],
        name: 'newUrlUpdated',
        type: 'event',
      },
      {
        inputs: [{ internalType: 'address', name: '', type: 'address' }],
        name: 'AddressToCountId',
        outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'address', name: '', type: 'address' }],
        name: 'AdrToId',
        outputs: [{ internalType: 'string', name: '', type: 'string' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [],
        name: 'NumberOfUsers',
        outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [],
        name: 'Registration_Fees',
        outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [],
        name: 'checkBalanceAndUpdate',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
        name: 'countIdToAddress',
        outputs: [{ internalType: 'address', name: '', type: 'address' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [
          { internalType: 'address', name: '', type: 'address' },
          { internalType: 'uint256', name: '', type: 'uint256' },
        ],
        name: 'directDownlines',
        outputs: [{ internalType: 'address', name: '', type: 'address' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'address', name: '', type: 'address' }],
        name: 'directDownlinesCount',
        outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [],
        name: 'getTopSponsors',
        outputs: [
          {
            components: [
              { internalType: 'uint256', name: 'downlineCount', type: 'uint256' },
              { internalType: 'address', name: 'user', type: 'address' },
            ],
            internalType: 'struct registration.downlineData[20]',
            name: 'topSponsors',
            type: 'tuple[20]',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'address', name: 'user', type: 'address' }],
        name: 'getTotalTeamSize',
        outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'address', name: 'user', type: 'address' }],
        name: 'getUser',
        outputs: [
          {
            components: [
              { internalType: 'string', name: 'name', type: 'string' },
              { internalType: 'string', name: 'uplineId', type: 'string' },
              { internalType: 'string', name: 'userId', type: 'string' },
              { internalType: 'string', name: 'imgURL', type: 'string' },
              { internalType: 'uint256', name: 'joiningDate', type: 'uint256' },
              { internalType: 'uint256', name: 'countId', type: 'uint256' },
              { internalType: 'uint256', name: 'uplineCountID', type: 'uint256' },
            ],
            internalType: 'struct registration.User',
            name: '',
            type: 'tuple',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [],
        name: 'isLock',
        outputs: [{ internalType: 'bool', name: '', type: 'bool' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'address', name: '', type: 'address' }],
        name: 'isRegistered',
        outputs: [{ internalType: 'bool', name: '', type: 'bool' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [],
        name: 'lastUserId',
        outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [],
        name: 'mainContract',
        outputs: [{ internalType: 'address', name: '', type: 'address' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [],
        name: 'owner',
        outputs: [{ internalType: 'address', name: '', type: 'address' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [
          { internalType: 'address', name: 'upline', type: 'address' },
          { internalType: 'string', name: 'name', type: 'string' },
        ],
        name: 'register',
        outputs: [],
        stateMutability: 'payable',
        type: 'function',
      },
      {
        inputs: [
          { internalType: 'address', name: 'upline', type: 'address' },
          { internalType: 'address', name: 'user', type: 'address' },
          { internalType: 'string', name: 'name', type: 'string' },
        ],
        name: 'registerByOwner',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'string', name: 'newUrl', type: 'string' }],
        name: 'setDefaultImgUrl',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'string', name: 'newUrl', type: 'string' }],
        name: 'setImgUrl',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [
          { internalType: 'address', name: 'contractAddress', type: 'address' },
        ],
        name: 'setMainContract',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'uint256', name: 'newFees', type: 'uint256' }],
        name: 'setRegFees',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'string', name: 'newName', type: 'string' }],
        name: 'setUsername',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'string', name: '', type: 'string' }],
        name: 'userIds',
        outputs: [{ internalType: 'address', name: '', type: 'address' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'address', name: '', type: 'address' }],
        name: 'userUpline',
        outputs: [{ internalType: 'address', name: '', type: 'address' }],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'address', name: '', type: 'address' }],
        name: 'users',
        outputs: [
          { internalType: 'string', name: 'name', type: 'string' },
          { internalType: 'string', name: 'uplineId', type: 'string' },
          { internalType: 'string', name: 'userId', type: 'string' },
          { internalType: 'string', name: 'imgURL', type: 'string' },
          { internalType: 'uint256', name: 'joiningDate', type: 'uint256' },
          { internalType: 'uint256', name: 'countId', type: 'uint256' },
          { internalType: 'uint256', name: 'uplineCountID', type: 'uint256' },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
        name: 'usersById',
        outputs: [
          { internalType: 'uint256', name: 'downlineCount', type: 'uint256' },
          { internalType: 'address', name: 'user', type: 'address' },
        ],
        stateMutability: 'view',
        type: 'function',
      },
    ],
  };


function getWeb3Provider() {
    try {
      const web3 = new Web3("https://opbnb-mainnet-rpc.bnbchain.org");
      console.log("Web3", web3);
      return web3;
    } catch (error) {
      console.error("Error initializing Web3", error);
      return null;
    }
  }



  window.RegisterUser = async (id, userName) => {
  console.log("Registering the user");
  try {
    let ethereum;
    if (typeof window !== "undefined") {
      ethereum = window.ethereum;
    }

    if (!ethereum) {
      return "false";
    }

    await ethereum.request({ method: 'eth_requestAccounts' });
    const connectedAddresses = await ethereum.request({
      method: 'eth_accounts',
    });
   const sponsorAddress = await AddressById(id);
    const userAddress = connectedAddresses[0];
    console.log('User address for registration:', userAddress);
    console.log({
        "user_address": userAddress,
        "sponsor_address": sponsorAddress,
        "username": userName || "User",
    
    })
    const web3Data = await initWeb3();
    if (!web3Data.success) {
      return "false";
    }

    let contract, web3;
    if (typeof web3Data.response !== 'string') {
      contract = web3Data.response.regContractInstance;
      web3 = web3Data.response.web3;
    }

    const registrationFees = await contract.methods.Registration_Fees().call();
    console.log('Registration fees:', registrationFees);

    const txData = contract.methods.register(sponsorAddress, userName || "User").encodeABI();
    const tx = {
        from: userAddress,
        to: contract.options.address,
        value: registrationFees,
        data: txData,
      }
    console.log("Transaction data to send:", tx);
    const estimatedGas = await web3.eth.estimateGas(tx);

    console.error("Estimate fees:", estimatedGas);
    const gasLimit = Math.floor(Number(estimatedGas));

    console.log("Estimated gas:", estimatedGas);
    console.log("Adjusted gas limit:", gasLimit);

    const receipt = await ethereum.request({
      method: "eth_sendTransaction",
      params: [
        {
          from: userAddress,
          to: contract.options.address,
          value: web3.utils.toHex(registrationFees),
          gas: web3.utils.toHex(gasLimit),
          data: txData,
        },
      ],
    });

    if (receipt) {
      console.log('Transaction successful:', receipt.transactionHash);
      return "true";
    }

    return "false";
  } catch (error) {
    console.error('Error registering user:', error);
    return "false";
  }
};

window.AddressById = async (id) => {
    try {
      const web3Data = await initWeb3();
      let contract;
      let web3;
      if (!web3Data.success) {
        return { success: false, response: 'Failed to initialize Ethereum web3' };
      }
      if (typeof web3Data.response !== 'string') {
        contract = web3Data.response.regContractInstance;
        web3 = web3Data.response.web3;
      }
      const address  = await contract.methods
        .countIdToAddress(id)
        .call();
      if (address) {
      return address;
      } else {
        return "";
      }
    } catch (error) {
      console.error('Error checking if user address:', error);
      return "";
    }
}

const  AddressById = async (id) => {
    try {
      const web3Data = await initWeb3();
      let contract;
      let web3;
      if (!web3Data.success) {
        return { success: false, response: 'Failed to initialize Ethereum web3' };
      }
      if (typeof web3Data.response !== 'string') {
        contract = web3Data.response.regContractInstance;
        web3 = web3Data.response.web3;
      }
      const address  = await contract.methods
        .countIdToAddress(id)
        .call();
      if (address) {
      return address;
      } else {
        return "";
      }
    } catch (error) {
      console.error('Error checking if user address:', error);
      return "";
    }
}
const initWeb3 = async () => {
  try {
    const web3 = await getWeb3Provider();

    if (!web3) {
      return { success: false, response: 'Failed to initialize Ethereum web3' };
    }

    const regContractInstance = new web3.eth.Contract(
      regContract.abi,
      regContract.address
    );

    if (!regContractInstance) {
      return { success: false, response: 'Failed to initialize contract' };
    }

    return { success: true, response: { regContractInstance, web3 } };
  } catch (error) {
    return {
      success: false,
      response: `Error: ${error.message || 'Failed to initialize contract'}`,
    };
  }
};



getWeb3Provider()


