require 'spec_helper'

describe Guard::Cane do
  subject { guard }
  let(:guard) { described_class.new(watchers, options) }

  let(:options) { {} }
  let(:paths) { [] }
  let(:watchers) { [] }

  before do
    Guard::Notifier.stub :notify

    Guard::UI.stub :info
    Guard::UI.stub :error
  end

  describe "#start" do
    subject(:start) { guard.start }

    it "runs all" do
      guard.should_receive :run_all

      start
    end

    context "with all_on_start: false" do
      let(:options) { { all_on_start: false } }

      it "does not run all" do
        guard.should_not_receive :run_all

        start
      end
    end
  end

  describe "#run_all" do
    subject(:run_all) { guard.run_all }

    it "runs cane with no arguments" do
      guard.should_receive(:cane).with(no_args)

      run_all
    end
  end

  describe "#run_on_modifications" do
    subject(:run_on_modifications) { guard.run_on_modifications(paths) }

    let(:paths) { %w[a b c] }

    it "runs cane with the paths" do
      guard.should_receive(:cane).with(paths)

      run_on_modifications
    end

    context "with all_after_pass: true" do
      let(:options) { { all_after_pass: true } }

      it "does run all after pass" do
        guard.stub(:cane).and_return(true)
        guard.should_receive(:cane).with(paths)
        guard.should_receive :run_all

        run_on_modifications
      end

      it "does not run all if tests did not pass" do
        guard.stub(:cane).and_return(false)
        guard.should_receive(:cane).with(paths)
        guard.should_not_receive :run_all

        run_on_modifications
      end
    end
  end

  describe "#cane" do
    subject(:cane) { guard.cane(paths) }

    let(:result) { true }

    before do
      guard.stub system: result
    end

    it { should eq(true) }

    it "does not notify of success" do
      Guard::Notifier.should_not_receive(:notify)

      cane.should == true
    end

    context "when failed" do
      let(:result) { false }

      it { should eq(false) }

      it "notifies of a failure" do
        Guard::Notifier.should_receive(:notify).with(*described_class::FAILED)

        cane
      end
    end

    context "when failing and then succeeding" do
      it "notifies of a success" do
        guard.stub system: false
        Guard::Notifier.should_receive(:notify).with(*described_class::FAILED)

        guard.cane(paths)

        guard.stub system: true
        Guard::Notifier.should_receive(:notify).with(*described_class::SUCCESS)

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
