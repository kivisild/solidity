import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("CounterModule", (m) => {
  const smartContract = m.contract("MySmartContract");

  m.call(smartContract, "incBy", [5n]);

  return { smartContract };
});
