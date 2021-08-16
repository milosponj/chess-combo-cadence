import path from "path";
import { emulator, init, getAccountAddress, shallPass, shallResolve, shallRevert } from "flow-js-testing";
import { getChessComboAdminAddress } from "../src/common";
// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(50000);

describe("Pack Handler", () => {
	// Instantiate emulator and path to Cadence files
	beforeEach(async () => {
		const basePath = path.resolve(__dirname, "../../");
		const port = 8084;
		init(basePath, port);
		return emulator.start(port, false);
	});

	// Stop emulator, so it could be restarted
	afterEach(async () => {
		return emulator.stop();
	});

	it("shall deploy ChessCombo contract", async () => {
		await shallPass(deployPackHandler());
	});
});
