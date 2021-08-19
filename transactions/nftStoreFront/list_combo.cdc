import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import FUSD from "../../contracts/FUSD.cdc"
import ChessCombo from "../../contracts/ChessCombo.cdc"
import NFTStorefront from "../../contracts/NFTStorefront.cdc"

transaction(saleItemID: UInt64, saleItemPrice: UFix64) {

    let fusdReceiver: Capability<&FUSD.Vault{FungibleToken.Receiver}>
    let chessComboProvider: Capability<&ChessCombo.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront

    prepare(account: AuthAccount) {
        // We need a provider capability, but one is not provided by default so we create one if needed.
        let chessComboCollectionProviderPrivatePath = /private/chessComboCollectionProvider

        self.fusdReceiver = account.getCapability<&FUSD.Vault{FungibleToken.Receiver}>(/public/fusdReceiver)
        
        assert(self.fusdReceiver.borrow() != nil, message: "Missing or mis-typed FUSD receiver")

        if !account.getCapability<&ChessCombo.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(chessComboCollectionProviderPrivatePath)!.check() {
            account.link<&ChessCombo.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(chessComboCollectionProviderPrivatePath, target: ChessCombo.CollectionStoragePath)
        }

        self.chessComboProvider = account.getCapability<&ChessCombo.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(chessComboCollectionProviderPrivatePath)!
        
        assert(self.chessComboProvider.borrow() != nil, message: "Missing or mis-typed ChessCombo.Collection provider")

        self.storefront = account.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")
    }

    execute {
        let saleCut = NFTStorefront.SaleCut(
            receiver: self.fusdReceiver,
            amount: saleItemPrice
        )
        self.storefront.createSaleOffer(
            nftProviderCapability: self.chessComboProvider,
            nftType: Type<@ChessCombo.NFT>(),
            nftID: saleItemID,
            salePaymentVaultType: Type<@FUSD.Vault>(),
            saleCuts: [saleCut]
        )
    }
}