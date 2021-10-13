import React, {Component} from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider"
import KryptoBird from '../abis/KryptoBird.json'
import _deploy_contracts from "../../migrations/2_deploy_contracts";


class App extends Component {

    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockChainData();
    }
    //detect the ethereum provider
    async loadWeb3() {
        const provider = await detectEthereumProvider();

        //modern browsers
        if(provider){
            console.log('ethereum wallet is connected');
            window.web3 = new Web3(provider);
            window.ethereum.enable();


        } else {
            //no ethereum provider
            console.log('ethereum wallet is not connected')
        }

    }

    async loadBlockChainData() {
        const web3 = window.web3
        const accounts = await web3.eth.getAccounts();
        this.setState({account:accounts})

        const networkId = await web3.eth.net.getId()
        const networkData = KryptoBird.networks[networkId]

        if(networkData){
            const abi = KryptoBird.abi;
            const address = networkData.address;
            const contract = new web3.eth.Contract(abi, address);
            this.setState({contract})

            //call the total supply of our KryptoBirdz

            const totalSupply = await contract.methods.totalSupply().call()
            this.setState({totalSupply})

            //load krypto birdz
            for (let i = 1; i <= totalSupply; i++) {
                const KryptoBird = await contract.methods.kryptoBirdz(i - 1).call()
                this.setState({
                    kryptoBirdz: [...this.state.kryptoBirdz, KryptoBird]
                })

            }

        } else {
            window.alert('Smart contract not deployed')
        }
    }

    mint = (kryptobird) => {
        this.state.contract.methods.mint(kryptobird).send({from:this.state.account})
        .once('receipt', (receipt) => {
            this.setState({
                kryptoBirdz: [...this.state.kryptoBirdz, kryptobird]
            })
        })
    }
    

    constructor(props){
        super(props)
        this.state = {
            account: '',
            contract: null,
            totalSupply : 0,
            kryptoBirdz: []
        }
    }


    render() {
        return (
            <div>
                <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow "> 
                    <div className="navbar-brand col-sm-3 col-md-3 mr-0" style={{color: 'white'}}>
                        Krypto Birdz NFTs (Non Fungible Token)
                    </div>

                    <ul className="navbar-nav px-3 ">
                        <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
                            <small className="text-white">{this.state.account}</small>
                        </li>
                    </ul>
                 </nav>
            </div>
        )
    }

}

export default App;