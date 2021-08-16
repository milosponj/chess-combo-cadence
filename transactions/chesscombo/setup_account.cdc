import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import ChessCombo from "../../contracts/ChessCombo.cdc"

// This transaction configures an account to hold Combos.
  transaction {
    prepare(acct: AuthAccount) {
        if acct.borrow<&ChessCombo.Collection>(from: ChessCombo.CollectionStoragePath) == nil {
            acct.save(<-ChessCombo.createEmptyCollection(), to: ChessCombo.CollectionStoragePath)
        
            acct.unlink(ChessCombo.CollectionPublicPath)

            acct.link<&ChessCombo.Collection{NonFungibleToken.CollectionPublic, ChessCombo.ComboCollectionPublic}>(ChessCombo.CollectionPublicPath, target: ChessCombo.CollectionStoragePath)
        }
      }
  }
