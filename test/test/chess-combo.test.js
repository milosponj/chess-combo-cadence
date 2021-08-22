import path from "path";
import { emulator, init, getAccountAddress, shallPass, shallResolve, shallRevert } from "flow-js-testing";
import { Dictionary, String } from "@onflow/types";

import {
	deployChessCombo,
	getCollectionLength,
	getCurrentSeries,
	getChessComboSupply,
	mintCombo,
	setupChessComboOnAccount,
	transferCombo,
	startNewSeries,
	createCompilation,
	getNextCompilationId,
	createCombination,
	getNextCombinationId,
	addCombinationToCompilation,
	getCombinationsInCompilation,
} from "../src/chess-combo";
import { getChessComboAdminAddress } from "../src/common";

// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(50000);

describe("Chess Combo", () => {
	// Instantiate emulator and path to Cadence files
	beforeEach(async () => {
		const basePath = path.resolve(__dirname, "../../");
		const port = 8080;
		await init(basePath, port);
		return await emulator.start(port, false);
	});

	// Stop emulator, so it could be restarted
	afterEach(async () => {
		await emulator.stop();
		await new Promise((resolve) => setTimeout(resolve, 100));
	});

	it("shall deploy ChessCombo contract", async () => {
		await shallPass(deployChessCombo());
	});

	it("supply shall be 0 after contract is deployed", async () => {
		// Setup
		await deployChessCombo();
		const ChessComboAdmin = await getChessComboAdminAddress();
		await shallPass(setupChessComboOnAccount(ChessComboAdmin));

		await shallResolve(async () => {
			const supply = await getChessComboSupply();
			expect(supply).toBe(0);
		});
	});

	it("shall start new series", async () => {
		await deployChessCombo();
		const ChessComboAdmin = await getChessComboAdminAddress();
		await shallPass(setupChessComboOnAccount(ChessComboAdmin));

		await shallPass(startNewSeries());

		await shallResolve(async () => {
			const currentSeries = await getCurrentSeries();
			expect(currentSeries).toBe(1);
		});
	});

	it("shall create a new compilation", async () => {
		await deployChessCombo();
		const ChessComboAdmin = await getChessComboAdminAddress();
		await shallPass(setupChessComboOnAccount(ChessComboAdmin));
		await shallPass(startNewSeries());

		await shallPass(createCompilation("test"));

		await shallResolve(async () => {
			const compilationId = await getNextCompilationId();
			expect(compilationId).toBe(2);
		});
	});

	it("shall create a new combination", async () => {
		await deployChessCombo();
		const ChessComboAdmin = await getChessComboAdminAddress();
		await shallPass(setupChessComboOnAccount(ChessComboAdmin));
		await shallPass(startNewSeries());

		await shallPass(
			createCombination([[{ key: "testie", value: "test" }], Dictionary({ key: String, value: String })])
		);

		await shallResolve(async () => {
			const combinationId = await getNextCombinationId();
			expect(combinationId).toBe(2);
		});
	});

	it("shall add a combination to compilation", async () => {
		// Arrange
		await deployChessCombo();
		const ChessComboAdmin = await getChessComboAdminAddress();
		await shallPass(setupChessComboOnAccount(ChessComboAdmin));
		await shallPass(startNewSeries());
		await shallPass(createCompilation("test"));
		await shallPass(
			createCombination([[{ key: "testie", value: "test" }], Dictionary({ key: String, value: String })])
		);

		//Act
		await shallPass(
			// add the first combination to first compilation
			addCombinationToCompilation(1, 1)
		);

		//Assert
		await shallResolve(async () => {
			const combinationIds = await getCombinationsInCompilation(1);
			expect(combinationIds).toEqual([1]);
		});
	});

	it("shall mint a combo", async () => {
		// Arrange
		await deployChessCombo();
		const Alice = await getAccountAddress("Alice");
		await setupChessComboOnAccount(Alice);
		await shallPass(startNewSeries());
		await shallPass(createCompilation("test"));
		await shallPass(
			createCombination([[{ key: "testie", value: "test" }], Dictionary({ key: String, value: String })])
		);
		await shallPass(addCombinationToCompilation(1, 1));

		await shallPass(mintCombo(1, 1, Alice));

		await shallResolve(async () => {
			const amount = await getCollectionLength(Alice);
			expect(amount).toBe(1);
		});
	});

	it("shall not be able to withdraw an NFT that doesn't exist in a collection", async () => {
		// Setup
		await deployChessCombo();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupChessComboOnAccount(Alice);
		await setupChessComboOnAccount(Bob);

		// Transfer transaction shall fail for non-existent item
		await shallRevert(transferCombo(Alice, Bob, 42));
	});

	it("shall be able to withdraw an NFT and deposit to another accounts collection", async () => {
		await deployChessCombo();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupChessComboOnAccount(Alice);
		await setupChessComboOnAccount(Bob);

		await shallPass(startNewSeries());
		await shallPass(createCompilation("test"));
		await shallPass(
			createCombination([[{ key: "testie", value: "test" }], Dictionary({ key: String, value: String })])
		);
		await shallPass(addCombinationToCompilation(1, 1));
		await shallPass(mintCombo(1, 1, Alice));

		// Transfer transaction shall pass
		await shallPass(transferCombo(Alice, Bob, 1));

		await shallResolve(async () => {
			const aliceCollectionLength = await getCollectionLength(Alice);
			expect(aliceCollectionLength).toBe(0);
			const bobCollectionLength = await getCollectionLength(Bob);
			expect(bobCollectionLength).toBe(1);
		});
	});
});
