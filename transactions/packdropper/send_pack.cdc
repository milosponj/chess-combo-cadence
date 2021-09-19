import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import ChessCombo from "../../contracts/ChessCombo.cdc"
      
      // This transaction sends a number of combos to a recipient
      
      // Parameters
      //
      // recipientAddress: the Flow address that will receive the NFTs
      // comboIds: an array of combo Ids of NFTs that recipient will receive
      
transaction(recipientAddress: Address, comboIds: [UInt64]) {
      
          let transferTokens: @NonFungibleToken.Collection
          
          prepare(acct: AuthAccount) {
      
              self.transferTokens <- acct.borrow<&ChessCombo.Collection>(from: /storage/ChessComboCollection)!.batchWithdraw(ids: comboIds)
          }
      
          execute {
              
              // get the recipient's public account object
              let recipient = getAccount(recipientAddress)
      
              // get the Collection reference for the receiver
              let receiverRef = recipient.getCapability(/public/ChessComboCollection).borrow<&{ChessCombo.ComboCollectionPublic}>()
                  ?? panic("Could not borrow a reference to the recipients moment receiver")
      
              // deposit the NFT in the receivers collection
              receiverRef.batchDeposit(tokens: <-self.transferTokens)
          }
}