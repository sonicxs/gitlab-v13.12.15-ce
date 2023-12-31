# frozen_string_literal: true

require 'spec_helper'
require Rails.root.join('db', 'post_migrate', '20210420103955_remove_hipchat_service_records.rb')

RSpec.describe RemoveHipchatServiceRecords do
  let(:services) { table(:services) }

  before do
    services.create!(type: 'HipchatService')
    services.create!(type: 'SomeOtherType')
  end

  it 'removes services records of type HipchatService' do
    expect(services.count).to eq(2)

    migrate!

    expect(services.count).to eq(1)
    expect(services.first.type).to eq('SomeOtherType')
    expect(services.where(type: 'HipchatService')).to be_empty
  end
end
