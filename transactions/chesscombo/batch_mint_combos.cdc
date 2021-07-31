import ChessCombo from "../../contracts/ChessCombo.cdc"

// This transaction mints multiple Combos 
// from a single Compilation/Combination edition

// Parameters:
//
// compilationId: the ID of the Compilation to be minted from
// combinationId: the ID of the Combination from which the Combos are minted 
// quantity: the quantity of Combos to be minted
// recipientAddr: the Flow address of the account receiving the collection of minted Combos

transaction(compilationId: UInt32, combinationId: UInt32, quantity: UInt64, recipientAddr: Address) {

    // Local variable for the topshot Admin object
    let adminRef: &ChessCombo.Admin

    prepare(acct: AuthAccount) {

        // borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&ChessCombo.Admin>(from: /storage/ChessComboAdmin)!
    }

    execute {

        // borrow a reference to the set to be minted from
        let compilationRef = self.adminRef.borrowCompilation(compilationId: compilationId)

        // Mint all the new NFTs
        let collection <- compilationRef.batchMintCombos(combinationId: combinationId, quantity: quantity)

        // Get the account object for the recipient of the minted tokens
        let recipient = getAccount(recipientAddr)

        // get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(ChessCombo.CollectionPublicPath).borrow<&{ChessCombo.ComboCollectionPublic}>()
            ?? panic("Cannot borrow a reference to the recipient's collection")

        // deposit the NFT in the receivers collection
        receiverRef.batchDeposit(tokens: <-collection)
    }
}