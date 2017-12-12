# Encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/outputs/swift/uploader"
require "logstash/outputs/swift/temporary_file"
require "fog/openstack"
require "stud/temporary"

describe LogStash::Outputs::Swift::Uploader do
  let(:logger) { spy(:logger ) }
  let(:max_upload_workers) { 1 }
  let(:bucket_name) { "foobar-bucket" }

  let(:service) { Fog::Storage::OpenStack.new }
  let(:container) { service.directories.get(bucket_name)  }

  let(:temporary_directory) { Stud::Temporary.pathname }
  let(:temporary_file) { Stud::Temporary.file }
  let(:key) { "foobar" }
  let(:upload_options) { {} }
  let(:threadpool) do
    Concurrent::ThreadPoolExecutor.new({
                                         :min_threads => 1,
                                         :max_threads => 8,
                                         :max_queue => 1,
                                         :fallback_policy => :caller_runs
                                       })
  end

  let(:file) do
    f = LogStash::Outputs::Swift::TemporaryFile.new(key, temporary_file, temporary_directory)
    f.write("random content")
    f.fsync
    f
  end

  subject { described_class.new(container, logger, threadpool) }

  it "upload file to the swift container" do
    expect { subject.upload(file) }.not_to raise_error
  end

  it "execute a callback when the upload is complete" do
    callback = proc { |f| }

    expect(callback).to receive(:call).with(file)
    subject.upload(file, { :on_complete => callback })
  end

end
