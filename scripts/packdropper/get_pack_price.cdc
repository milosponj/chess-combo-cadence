import PackDropper from "../../contracts/PackDropper.cdc"

pub fun main(packId: UInt32, packsHandlerAddress: Address): UFix64 {
    let packPurchaser = getAccount(packsHandlerAddress)
        .getCapability<&PackDropper.PacksHandler{PackDropper.PackPurchaser}>(
            PackDropper.PacksHandlerPublicPath
        )
        .borrow()
        ?? panic("Could not borrow PacksHandler from PacksHandler address")  
        
            
    let price = packPurchaser.getPackPrice(packId: packId)
            
    return price
}         