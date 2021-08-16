import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import ChessCombo from "../../contracts/ChessCombo.cdc"

pub fun main(address: Address): Int {
    let account = getAccount(address)

    let collectionRef = account.getCapability(ChessCombo.CollectionPublicPath)!
        .borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")
    
    return collectionRef.getIDs().length
}