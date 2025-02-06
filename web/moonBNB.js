
 const MoonContract = {
    address: '0xeA292baCc8801728152b3273161a8800E07Fc57C',
    abi:[{"inputs":[{"internalType":"address","name":"_manager","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"from","type":"address"},{"indexed":false,"internalType":"uint256","name":"levelPrice","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"LevelPurchased","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"RoyaltyGainSent","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"TransferSent","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"virtualGainSent","type":"event"},{"inputs":[],"name":"FIRST_LVL_EARNING","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"LAST_LVL_EARNING","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"LEVEL_GLOBAL_EARNING","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"PL_EARNING","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"SECONDAIRY_LVL_EARNING","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"TOTAL_LEVELS","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"level","type":"uint256"},{"internalType":"address","name":"user","type":"address"}],"name":"_purchase","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"availableGlobalGain","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"contractEvents","outputs":[{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"uint256","name":"time","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getContrcatEvents","outputs":[{"components":[{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"uint256","name":"time","type":"uint256"}],"internalType":"struct MoonBNB.ContractEvent[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"level","type":"uint256"}],"name":"getPoolUsers","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"user","type":"address"}],"name":"getStories","outputs":[{"components":[{"internalType":"string","name":"actionName","type":"string"},{"internalType":"uint256","name":"actionAmount","type":"uint256"},{"internalType":"address","name":"actionFrom","type":"address"},{"internalType":"uint256","name":"actionDate","type":"uint256"}],"internalType":"struct MoonBNB.UserHistory[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"user","type":"address"}],"name":"getUserUpline","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"user","type":"address"}],"name":"getWd","outputs":[{"components":[{"internalType":"string","name":"actionName","type":"string"},{"internalType":"uint256","name":"actionAmount","type":"uint256"},{"internalType":"address","name":"actionFrom","type":"address"},{"internalType":"uint256","name":"actionDate","type":"uint256"}],"internalType":"struct MoonBNB.WithdrawHistory[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"userId","type":"uint256"}],"name":"getuserAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"history","outputs":[{"internalType":"string","name":"actionName","type":"string"},{"internalType":"uint256","name":"actionAmount","type":"uint256"},{"internalType":"address","name":"actionFrom","type":"address"},{"internalType":"uint256","name":"actionDate","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"isActive","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"lastUser","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"levelPrice","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"numberOfActiveUsers","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"level","type":"uint256"}],"name":"purchase","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"regContract","outputs":[{"internalType":"contract IREG","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalEarned","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"userLevel","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"users","outputs":[{"internalType":"address","name":"userAddress","type":"address"},{"internalType":"uint256","name":"totalIncome","type":"uint256"},{"internalType":"uint256","name":"totalGlobalIncome","type":"uint256"},{"internalType":"uint256","name":"totalPoolIncome","type":"uint256"},{"internalType":"uint256","name":"posSponsorIncome","type":"uint256"},{"internalType":"uint256","name":"lastUpdate","type":"uint256"},{"internalType":"uint256","name":"transactionCount","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"virtualDirectsOf","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"virtualIds","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"virtualUplineOf","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"withdraw","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"withdrawals","outputs":[{"internalType":"string","name":"actionName","type":"string"},{"internalType":"uint256","name":"actionAmount","type":"uint256"},{"internalType":"address","name":"actionFrom","type":"address"},{"internalType":"uint256","name":"actionDate","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"x_update_Emergency_case_only","outputs":[],"stateMutability":"nonpayable","type":"function"}]
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


  const initMoonWeb3 = async () => {
    try {
      const web3 = await getWeb3Provider();
  
      if (!web3) {
        return { success: false, response: 'Failed to initialize Ethereum web3' };
      }
  
      const vrContractInstance = new web3.eth.Contract(
        MoonContract.abi,
        MoonContract.address
      );
  
      if (!vrContractInstance) {
        return { success: false, response: 'Failed to initialize contract' };
      }
  
      return { success: true, response: { vrContractInstance, web3 } };
    } catch (error) {
      return {
        success: false,
        response: `Error: ${error.message || 'Failed to initialize contract'}`,
      };
    }
  };
  
window.GetUserHistories = async (address )=> {
    if (address.length  === 0) {
        return {success : false , response : 'Invalid address'}
    }

   try {
       const init = await initMoonWeb3()
       if (init.success) {
          if (typeof init.response !== "string") {
            const contract = init.response.vrContractInstance

            const histories  = await contract.methods.getStories(address).call()
            const stringifiedData = JSON.stringify(histories, (_, value) =>
                typeof value === "bigint" ? Number(value) : value
              );
            return{ response : stringifiedData}
           } else {

               return {}
           }
       } else {
           console.error('Error initializing Ethereum Web3:', init.response);
            return {} ;
       }
       
   } catch (error) {
       console.error('Error getting user histories:', error);
       return { }
       
   }

}
window. GetUserWithdraw = async (address )=> {
    if (address.length  === 0) {
        return {success : false , response : 'Invalid address'}
    }

   try {
       const init = await initMoonWeb3()
       if (init.success) {
          if (typeof init.response !== "string") {
            const contract = init.response.vrContractInstance

            const histories  = await contract.methods.getWd(address).call()
            const stringifiedData = JSON.stringify(histories, (_, value) =>
                typeof value === "bigint" ? Number(value) : value
              );
            return{ response : stringifiedData}
           } else {

               return {}
           }
       } else {
           console.error('Error initializing Ethereum Web3:', init.response);
            return {} ;
       }
       
   } catch (error) {
       console.error('Error getting user histories:', error);
       return { }
       
   }

}
window.getUserLevel = async (address )=> {
   try {
       const init = await initMoonWeb3()
       if (init.success) {
          if (typeof init.response !== "string") {
            const contract = init.response.vrContractInstance

            const userLevel = Number(await contract.methods.userLevel(address).call())
            return userLevel.toString()
           } else {

               return ""
           }
       } else {
           console.error('Error initializing Ethereum Web3:', init.response);
            return"" ;
       }
   } catch (error) {
       console.error('Error getting user level:', error);
       return"";

       
   }
}
window.GetAvailableGlobalGain = async (address )=> {
    try {
        const init = await initMoonWeb3()
        console.info("Getting available gain of user")
        if (init.success) {
           if (typeof init.response !== "string") {
             const contract = init.response.vrContractInstance
 
             const gain = Number(await contract.methods.availableGlobalGain(address).call())
             console.info("Got gain " + gain )
             return gain.toString()
            } else {
 
                return ""
            }
        } else {
            console.error('Error initializing Ethereum Web3:', init.response);
             return "";
        }
    } catch (error) {
        console.error('Error getting user level:', error);
        return"";
 
        
    }
 }
   

window.getUserM50Data = async (address )=> {
    try {
        const init = await initMoonWeb3()
        if (init.success) {
           if (typeof init.response !== "string") {
             const contract = init.response.vrContractInstance
             
             const user  = await contract.methods.users(address).call()
             const userJson = {
                 "userAddress" : user.userAddress,
                 "totalIncome" : Number(user.totalIncome),
                 "totalGlobalIncome" :Number( user.totalGlobalIncome),
                 "totalPoolIncome"  :Number( user.totalPoolIncome),
                 "posSponsorIncome"  :Number( user.posSponsorIncome),
                 "lastUpdate" : Number(user.lastUpdate ),
                 "transactionCount" : Number(user.transactionCount)
            }
             return{response : userJson}
            } else {

                return {}
            }
        } else {
            console.error('Error initializing Ethereum Web3:', init.response);
             return { } ;
        }
    } catch (error) {
        console.error('Error getting user level:', error);
        return {};

        
    }
}


window.PurchaseLevel = async (level )=> {
    try {
    
        const init = await initMoonWeb3()
        if (init.success) {
           if (typeof init.response !== "string") {
             const web3 = init.response.web3
             const contract = init.response.vrContractInstance
             let ethereum 
             if (typeof window !== "undefined") {
               ethereum = (window ).ethereum;
            }
                     const connectedAddresses = await ethereum.request({
                method: 'eth_accounts',
              });
              const userAddress = connectedAddresses[0];
              const txData = contract.methods.purchase(level).encodeABI();
              const levelPrice = await contract.methods.levelPrice(level).call(); 
    
              
              const estimatedGas = await web3.eth.estimateGas({
                from: userAddress,
                to: contract.options.address,
                value: levelPrice,
                data: txData,
              });
              
            console.log("estimate fees: ", estimatedGas);
            const gasLimit = Math.floor((Number(estimatedGas) ));
    
            console.log("Estimated gas:", estimatedGas);
            console.log("Adjusted gas limit:", gasLimit);
    
            const tx =  {
                from: userAddress, 
                to: contract?.options.address, 
                value:web3.utils.toHex(levelPrice),
                gas: web3.utils.toHex(gasLimit), 
                data: txData,
              }
    
              console.log("tx: ", tx);
    
           const receipt = await ethereum.request({
                method: "eth_sendTransaction",
                params: [
                 tx
                ],
              }); 
    
              if (receipt) {
                console.log('Transaction successful:', receipt.transactionHash);
                return "true";
              }
    
            } else {
    
                return "false"
            }
        } else {
            console.error('Error initializing Ethereum Web3:', init.response);
             return "false" ;
        }
        
    } catch (error) {
        console.error('Error purchasing level:', error);
        return "false";
        
    }
    }
    



    window.Withdraw = async (level )=> {
        try {
        
            const init = await initMoonWeb3()
            if (init.success) {
               if (typeof init.response !== "string") {
                 const web3 = init.response.web3
                 const contract = init.response.vrContractInstance
                 let ethereum 
                 if (typeof window !== "undefined") {
                   ethereum = (window ).ethereum;
                }
                         const connectedAddresses = await ethereum.request({
                    method: 'eth_accounts',
                  });
                  const userAddress = connectedAddresses[0];
                  const txData = contract.methods.withdraw().encodeABI();
        
                  
                  const estimatedGas = await web3.eth.estimateGas({
                    from: userAddress,
                    to: contract.options.address,
                    value: "0",
                    data: txData,
                  });
                  
                console.log("estimate fees: ", estimatedGas);
                const gasLimit = Math.floor((Number(estimatedGas) ));
        
                console.log("Estimated gas:", estimatedGas);
                console.log("Adjusted gas limit:", gasLimit);
        
                const tx =  {
                    from: userAddress, 
                    to: contract?.options.address, 
                    value:web3.utils.toHex("0"), 
                    gas: web3.utils.toHex(gasLimit), 
                    data: txData,
                  }
        
                  console.log("tx: ", tx);
        
               const receipt = await ethereum.request({
                    method: "eth_sendTransaction",
                    params: [
                     tx
                    ],
                  }); 
        
                  if (receipt) {
                    console.log('Transaction successful:', receipt.transactionHash);
                    return"true";
                  }
        
                } else {
        
                    return "false"
                }
            } else {
                console.error('Error initializing Ethereum Web3:', init.response);
                 return "false" ;
            }
            
        } catch (error) {
            console.error('Error purchasing level:', error);
            return "false";
            
        }
        }
        

window.
 getTotalEarned = async ()=> {
    try {
        const init = await initMoonWeb3()
        if (init.success) {
           if (typeof init.response !== "string") {
             const contract = init.response.vrContractInstance

             const totalEarned  = Number(await contract.methods.totalEarned().call())
             return totalEarned.toString()
            } else {

                return ""
            }
        } else {
            console.error('Error initializing Ethereum Web3:', init.response);
             return {success : false , response : 'Error initializing Ethereum Web3' } ;
        }
    } catch (error) {
        console.error('Error getting user level:', error);
        return "";

        
    }
}


window.getMoonContractEvents = async () => {
    try {
      const web3Data = await initMoonWeb3();
      let contract;
  
      if (!web3Data.success) {
        return "{}";
      }
      
      if (typeof web3Data.response !== 'string') {
        contract = web3Data.response.vrContractInstance;
      }
      
      const events  = await contract.methods.getContrcatEvents().call();
      const stringifiedData = JSON.stringify(events, (_, value) =>
        typeof value === "bigint" ? Number(value) : value
      );
  
      if (events) {
        return ( { events : stringifiedData });
      }
    } catch (error) {
      console.error('Error fetching user data:', error);
      return { };
    }
  };
  

  getWeb3Provider()