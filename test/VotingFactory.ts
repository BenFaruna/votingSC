import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("VotingFactory", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployVotingFactoryFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const VotingFactory = await ethers.getContractFactory("VotingFactory");
    const votingfactory = await VotingFactory.deploy();

    const Voting = await ethers.getContractFactory("Voting");
    const voting = await Voting.deploy(owner.address, "", [])

    return { votingfactory, voting, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should create new voting pool from factory", async function () {
      const { votingfactory, owner } = await loadFixture(deployVotingFactoryFixture);

      const description = "This is a sample voting pool";
      const options = ["Option 1", "Option 2", "Option 3"]

      await expect(await votingfactory.createVotingPool(description, options)).to.be.emit(
        votingfactory, "VotingPoolCreated"
      ).withArgs(anyValue, owner.address);
    });
  });
});
