# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/outputs/swift/write_container_permission_validator"
require "fog/openstack"

describe LogStash::Outputs::Swift::WriteContainerPermissionValidator do
  let(:logger) { spy(:logger ) }
  let(:bucket_name) { "foobar" }
  let(:obj) { double("swift_object") }

  let(:service) { Fog::Storage::OpenStack.new }
  let(:container) { service.directories.get(bucket_name)  }

  let(:upload_options) { {} }

  subject { described_class.new(logger) }

  context "when permissions are sufficient" do
    it "returns true" do
      expect(container).to receive_message_chain(:files, :create).with(any_args).and_return(obj)
      expect(obj).to receive(:delete).and_return(true)
      expect(subject.valid?(container)).to be_truthy
    end

    it "hides delete errors" do
      expect(container).to receive_message_chain(:files, :create).with(any_args).and_return(obj)
      expect(obj).to receive(:delete).and_raise(StandardError)
      expect(subject.valid?(container)).to be_truthy
    end
  end

  context "when permission aren't sufficient" do
    it "returns false" do
      expect(container).to receive_message_chain(:files, :create).with(any_args).and_raise(StandardError)
      expect(subject.valid?(container)).to be_falsey
    end
  end
end
