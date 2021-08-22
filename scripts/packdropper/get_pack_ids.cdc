import PackDropper from "../../contracts/PackDropper.cdc"

pub fun main(packsHandlerAddress: Address): [UInt32] {
    let packsHandler = getAccount(packsHandlerAddress)
        .getCapability<&PackDropper.PacksHandler{PackDropper.PacksInfo}>(
            PackDropper.PacksInfoPublicPath
            )
            .borrow() ?? panic("Could not borrow PacksInfo from PacksInfoPublicPath address")  
    let packIds = packsHandler.getIDs()
            
    return packIds
}         