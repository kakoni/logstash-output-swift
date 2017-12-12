# encoding: utf-8
require "logstash/outputs/swift"
require "logstash/event"
require "logstash/codecs/line"
require "stud/temporary"
require "fog/openstack"

describe LogStash::Outputs::Swift do
  let(:prefix) { "super/%{server}" }
  let(:bucket_name) { "mybucket" }
  let(:options) { { "container" => bucket_name,
                    "prefix" => prefix,
                    "restore" => false,
                    "username" => "access_key_id",
                    "api_key" => "secret_access_key",
                    "auth_url" => "secret_access_key",
                    "project_name" => "secret_access_key",
                    "domain_name" => "secret_access_key"
  } }
  let(:service) { Fog::Storage::OpenStack.new }
  let(:mock_container) { service.directories.get(bucket_name)  }
  let(:event) { LogStash::Event.new({ "server" => "overwatch" }) }
  let(:event_encoded) { "super hype" }
  let(:events_and_encoded) { { event => event_encoded } }

  subject { described_class.new(options) }

  before do
    allow(subject).to receive(:container_resource).and_return(mock_container)
    allow_any_instance_of(LogStash::Outputs::Swift::WriteContainerPermissionValidator).to receive(:valid?).with(mock_container).and_return(true)
  end

  context "#register configuration validation" do
    describe "temporary directory" do
      let(:temporary_directory) { Stud::Temporary.pathname }
      let(:options) { super.merge({ "temporary_directory" => temporary_directory }) }

      it "creates the directory when it doesn't exist" do
        expect(Dir.exist?(temporary_directory)).to be_falsey
        subject.register
        expect(Dir.exist?(temporary_directory)).to be_truthy
      end

      it "raises an error if we cannot write to the directory" do
        expect(LogStash::Outputs::Swift::WritableDirectoryValidator).to receive(:valid?).with(temporary_directory).and_return(false)
        expect { subject.register }.to raise_error(LogStash::ConfigurationError)
      end
    end

    it "validates the prefix" do
      swift = described_class.new(options.merge({ "prefix" => "`no\><^" }))
      expect { swift.register }.to raise_error(LogStash::ConfigurationError)
    end

    it "allow to not validate credentials" do
      swift = described_class.new(options.merge({"validate_credentials_on_root_bucket" => false}))
      expect_any_instance_of(LogStash::Outputs::Swift::WriteContainerPermissionValidator).not_to receive(:valid?).with(any_args)
      swift.register
    end
  end

  context "receiving events" do
    before do
      subject.register
    end

    after do
      subject.close
    end

    it "uses `Event#sprintf` for the prefix" do
      expect(event).to receive(:sprintf).with(prefix).and_return("super/overwatch")
      subject.multi_receive_encoded(events_and_encoded)
    end
  end
end
