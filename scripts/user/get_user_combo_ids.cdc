import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import ChessCombo from "../../contracts/ChessCombo.cdc"

// This script returns an array of all the NFT IDs in an account's collection.

pub fun main(address: Address): [UInt64] {
    let account = getAccount(address)

    let collectionRef = account.getCapability(ChessCombo.CollectionPublicPath).borrow<&{ChessCombo.ComboCollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")
    
    return collectionRef.getIDs()
}