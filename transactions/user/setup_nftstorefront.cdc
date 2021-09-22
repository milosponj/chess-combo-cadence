import NFTStorefront from "../../contracts/NFTStorefront.cdc"

// this transaction sets up NFTStorefront to the given account
transaction {
  prepare(acct: AuthAccount) {
    if acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath) == nil {
          acct.save(<-NFTStorefront.createStorefront(), to: NFTStorefront.StorefrontStoragePath)
    }
    acct.unlink(NFTStorefront.StorefrontPublicPath)
    acct.link<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(NFTStorefront.StorefrontPublicPath, target: NFTStorefront.StorefrontStoragePath)           
  }
}
