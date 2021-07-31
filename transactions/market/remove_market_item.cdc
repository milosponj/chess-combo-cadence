import ChessComboMarket from 0x04

transaction(saleItemID: UInt64) {
    let marketCollection: &ChessComboMarket.Collection

    prepare(signer: AuthAccount) {
        self.marketCollection = signer.borrow<&ChessComboMarket.Collection>(from: ChessComboMarket.CollectionStoragePath)
            ?? panic("Missing or mis-typed ChessComboMarket Collection")
    }

    execute {
        let offer <-self.marketCollection.remove(saleItemID: saleItemID)
        destroy offer
    }
}