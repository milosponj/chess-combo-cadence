import PackDropper from "../../contracts/PackDropper.cdc"

pub fun main(packId: UInt32, packsHandlerAddress: Address): [Address] {
    let packsHandler = getAccount(packsHandlerAddress)
        .getCapability<&PackDropper.PacksHandler{PackDropper.PackPurchaser}>(
            PackDropper.PacksHandlerPublicPath
        )
        .borrow()
        ?? panic("Could not borrow PacksHandler from PacksHandler address")   
            
    let packBuyers = packsHandler.getPackBuyers(packId: packId)
            
    return packBuyers
}