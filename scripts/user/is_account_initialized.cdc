import FungibleToken from 0x01
import NonFungibleToken from 0x02
import FUSD from 0x05
import ChessCombo from 0x03
import NFTStorefront from 0x04

  pub fun hasFUSD(_ address: Address): Bool {
    let receiver = getAccount(address)
      .getCapability<&FUSD.Vault{FungibleToken.Receiver}>(/public/fusdReceiver)
      .check()
    let balance = getAccount(address)
      .getCapability<&FUSD.Vault{FungibleToken.Balance}>(/public/fusdBalance)
      .check()
    return receiver && balance
  }
  pub fun hasChessCombo(_ address: Address): Bool {
    return getAccount(address)
      .getCapability<&ChessCombo.Collection{NonFungibleToken.CollectionPublic, ChessCombo.ComboCollectionPublic}>(ChessCombo.CollectionPublicPath)
      .check()
  }
  pub fun hasStorefront(_ address: Address): Bool {
    return getAccount(address)
      .getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(NFTStorefront.StorefrontPublicPath)
      .check()
  }

  pub fun main(address: Address): {String: Bool} {
    let ret: {String: Bool} = {}
    ret["FUSD"] = hasFUSD(address)
    ret["ChessCombo"] = hasChessCombo(address)
    ret["StoreFront"] = hasStorefront(address)
    return ret
  }