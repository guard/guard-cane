require "guard/compat/test/helper"

require "guard/cane"

RSpec.describe Guard::Cane do
  let(:options) { {} }
  let(:paths) { [] }

  let(:guard) { described_class.new(options) }

  subject { guard }

  before do
    allow(Guard::Notifier).to receive :notify

    allow(Guard::UI).to receive :info
    allow(Guard::UI).to receive :error
  end

  describe "#start" do
    subject(:start) { guard.start }

    it "runs all" do
      expect(guard).to receive :run_all

      start
    end

    context "with run_all_on_start: false" do
      let(:options) { { run_all_on_start: false } }

      it "does not run all" do
        expect(guard).to_not receive :run_all

        start
      end
    end
  end

  describe "#run_all" do
    subject(:run_all) { guard.run_all }

    it "runs cane with no arguments" do
      expect(guard).to receive(:cane).with(no_args)

      run_all
    end
  end

  describe "#run_on_modifications" do
    subject(:run_on_modifications) { guard.run_on_modifications(paths) }

    let(:paths) { %w[a b c] }

    it "runs cane with the paths" do
      expect(guard).to receive(:cane).with(paths)

      run_on_modifications
    end

    context "with all_after_pass: true" do
      let(:options) { { all_after_pass: true } }

      it "does run all after pass" do
        allow(guard).to receive(:cane).and_return(true)
        expect(guard).to receive(:cane).with(paths)
        expect(guard).to receive :run_all

        run_on_modifications
      end

      it "does not run all if tests did not pass" do
        allow(guard).to receive(:cane).and_return(false)
        expect(guard).to receive(:cane).with(paths)
        expect(guard).to_not receive :run_all

        run_on_modifications
      end
    end
  end

  describe "#cane" do
    subject(:cane) { guard.cane(paths) }

    let(:result) { true }

    before do
      allow(guard).to receive(:system).and_return result
    end

    it { should be true }

    it "does not notify of success" do
      expect(Guard::Notifier).to_not receive(:notify)

      expect(cane).to be true
    end

    context "when failed" do
      let(:result) { false }

      it { should be false }

      it "notifies of a failure" do
        expect(Guard::Notifier).to receive(:notify)
        .with(*described_class::FAILED)

        cane
      end
    end

    context "when failing and then succeeding" do
      it "notifies of a success" do
        allow(guard).to receive(:system).and_return false
        expect(Guard::Notifier).to receive(:notify)
        .with(*described_class::FAILED)

        guard.cane(paths)

        allow(guard).to receive(:system).and_return true
        expect(Guard::Notifier).to receive(:notify)
        .with(*described_class::SUCCESS)

        guard.cane(paths)
      end
    end
  end

  describe "#build_command" do
    subject(:build_command) { guard.build_command(paths) }

    it { should == "cane" }

    context "with paths" do
      let(:paths) { %w[a b c] }

      it { should == "cane --all '{a,b,c}'" }
    end

    context "with cli arguments" do
      let(:options) { { cli: "--color" } }

      it { should == "cane --color" }
    end

    context "with a custom command" do
      let(:options) { { command: "rake quality" } }

      it { should == "rake quality" }
    end
  end
end
