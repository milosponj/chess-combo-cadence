import PackDropper from "../../contracts/PackDropper.cdc"

transaction(name: String, size: Int, price: UFix64, availableFrom: UFix64) {
     // local variable for storing the PackHandler reference
    let packsHandler: &PackDropper.PacksHandler

    prepare(signer: AuthAccount) {
        // borrow a reference to the PacksHandler resource in storage
        self.packsHandler = signer.borrow<&PackDropper.PacksHandler>(from: PackDropper.PacksHandlerStoragePath)
            ?? panic("Could not borrow a reference to the PacksHandler")
    }

    execute {
      self.packsHandler.addPack(name: name, size: size, price: price, availableFrom: availableFrom)
    }
}