import path from "path";
import { emulator, init, getAccountAddress, shallPass, shallResolve, shallRevert } from "flow-js-testing";
import { deployPackDropper, getPackIds, addPack, getPackPrice, buyPack, getPackBuyers } from "../src/pack-dropper";
import { mintFUSD, setupFUSDOnAccount } from "../src/fusd";
import { getChessComboAdminAddress, toUFix64 } from "../src/common";

// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(50000);

describe("Pack dropper", () => {
	// Instantiate emulator and path to Cadence files
	beforeEach(async () => {
		const basePath = path.resolve(__dirname, "../../");
		const port = 8084;
		init(basePath, port);
		return emulator.start(port, true);
	});
	// Stop emulator, so it could be restarted
	afterEach(async () => {
		return emulator.stop();
	});

	it("shall deploy PackDropper contract", async () => {
		await shallRevert(deployPackDropper());
	});
	// it("shall not have any packs at start", async () => {
	// 	const ChessComboAdminAddress = await getChessComboAdminAddress();
	// 	await shallPass(deployPackDropper());
	// 	await shallResolve(async () => {
	// 		const packIds = await getPackIds();
	// 		expect(packIds).toEqual([]);
	// 	});
	// });
	// it("shall add a new pack", async () => {
	// 	const ChessComboAdminAddress = await getChessComboAdminAddress();
	// 	await shallPass(deployPackDropper());
	// 	await shallPass(addPack("Test pack", 100, toUFix64(10), toUFix64(9999999999)));
	// 	const packIds = await getPackIds();
	// 	expect(packIds).toEqual([1]);
	// });
	// it("shall fail adding a pack with negative price", async () => {
	// 	await shallPass(deployPackDropper());
	// 	await shallRevert(addPack("Test pack", 100, toUFix64(-10), toUFix64(9999999999)));
	// });
	// it("shall fail adding a pack with non-positive size", async () => {
	// 	await shallPass(deployPackDropper());
	// 	await shallRevert(addPack("Test pack", 0, toUFix64(10), toUFix64(9999999999)));
	// });
	// it("shall fail adding a pack without a name", async () => {
	// 	await shallPass(deployPackDropper());
	// 	await shallRevert(addPack("", 10, toUFix64(10), toUFix64(9999999999)));
	// });
	// it("shall return pack price", async () => {
	// 	const ChessComboAdminAddress = await getChessComboAdminAddress();
	// 	await shallPass(deployPackDropper());
	// 	const price = toUFix64(10);
	// 	await shallPass(addPack("Test pack", 100, price, toUFix64(9999999999)));
	// 	await shallResolve(async () => {
	// 		const packPrice = await getPackPrice(1);
	// 		expect(packPrice).toEqual(price);
	// 	});
	// });
	// it("shall return ids of all packs", async () => {
	// 	const ChessComboAdminAddress = await getChessComboAdminAddress();
	// 	await shallPass(deployPackDropper());
	// 	await shallPass(addPack("Test pack", 100, toUFix64(10), toUFix64(9999999999)));
	// 	await shallPass(addPack("Test pack 2", 100, toUFix64(10), toUFix64(9999999999)));
	// 	await shallPass(addPack("Test pack 3", 100, toUFix64(10), toUFix64(9999999999)));
	// 	const packIds = await getPackIds();
	// 	expect(packIds).toEqual([1, 2, 3]);
	// });
	// it("shall execute buy pack given proper payment", async () => {
	// 	const ChessComboAdminAddress = await getChessComboAdminAddress();
	// 	await shallPass(deployPackDropper());
	// 	await shallPass(addPack("Test pack", 100, toUFix64(10), toUFix64(1)));
	// 	shallPass(await setupFUSDOnAccount(ChessComboAdminAddress));
	// 	const Alice = await getAccountAddress("Alice");
	// 	shallPass(await setupFUSDOnAccount(Alice));
	// 	shallPass(await mintFUSD(Alice, toUFix64(10)));
	// 	await shallPass(buyPack(1, Alice));
	// 	await shallResolve(async () => {
	// 		const packBuyers = await getPackBuyers(1);
	// 		expect(packBuyers).toEqual([Alice]);
	// 	});
	// });
	// it("shall revert pack buying with insufficient vault funds", async () => {
	// 	const ChessComboAdminAddress = await getChessComboAdminAddress();
	// 	await shallPass(deployPackDropper());
	// 	shallPass(await setupFUSDOnAccount(ChessComboAdminAddress));
	// 	const price = 10;
	// 	await shallPass(addPack("Test pack", 100, toUFix64(price), toUFix64(1)));
	// 	const Alice = await getAccountAddress("Alice");
	// 	shallPass(await setupFUSDOnAccount(Alice));
	// 	shallPass(await mintFUSD(Alice, toUFix64(price - 1)));
	// 	await shallRevert(buyPack(1, Alice));
	// });
	// it("shall revert pack buying with non existing pack id", async () => {
	// 	const ChessComboAdminAddress = await getChessComboAdminAddress();
	// 	await shallPass(deployPackDropper());
	// 	shallPass(await setupFUSDOnAccount(ChessComboAdminAddress));
	// 	const Alice = await getAccountAddress("Alice");
	// 	shallPass(await setupFUSDOnAccount(Alice));
	// 	shallPass(await mintFUSD(Alice, toUFix64(10)));
	// 	await shallRevert(buyPack(1, Alice));
	// });
	// it("shall revert pack buying when all are bought", async () => {
	// 	const ChessComboAdminAddress = await getChessComboAdminAddress();
	// 	await shallPass(deployPackDropper());
	// 	await shallPass(addPack("Test pack", 1, toUFix64(10), toUFix64(1)));
	// 	shallPass(await setupFUSDOnAccount(ChessComboAdminAddress));
	// 	const Alice = await getAccountAddress("Alice");
	// 	shallPass(await setupFUSDOnAccount(Alice));
	// 	shallPass(await mintFUSD(Alice, toUFix64(20)));
	// 	await shallPass(buyPack(1, Alice));
	// 	await shallRevert(buyPack(1, Alice));
	// });
});
