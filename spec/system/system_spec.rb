require 'rails_helper'
#  login --> create 3 members --> create 2 officers --> create 3 payment methods
#  --> create 3 payments --> modify payments --> create 2 deposits
#  --> modify deposits -->create 2 withdrawals --> modify withdrawals
RSpec.describe 'Create all entities using the UI', type: :feature do
  # mock login
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
  end

  it 'create all successfully' do
    # Now create members
    visit new_member_path
    click_link 'Sign in with your TAMU Google Account'
    visit new_member_path
    fill_in "UIN / Driver's License", with: '222222222'
    fill_in 'First Name', with: 'Alexandria'
    fill_in 'Last Name', with: 'Curtis'
    fill_in 'Email', with: 'acurtis@tamu.edu'
    fill_in 'Phone Number', with: '1231231212'
    click_on 'Create Member'
    # An member has been created
    expect(Member.count).to eq(1)

    visit new_member_path
    fill_in "UIN / Driver's License", with: '111111111'
    fill_in 'First Name', with: 'Yue'
    fill_in 'Last Name', with: 'Hu'
    fill_in 'Email', with: 'yueh@tamu.edu'
    fill_in 'Phone Number', with: '5126256262'
    click_on 'Create Member'
    # Two members have been created
    expect(Member.count).to eq(2)

    visit new_member_path
    fill_in "UIN / Driver's License", with: '56723434'
    fill_in 'First Name', with: 'Andres'
    fill_in 'Last Name', with: 'Blanco'
    fill_in 'Email', with: 'andresblanco@tamu.edu'
    fill_in 'Phone Number', with: '5128908989'
    click_on 'Create Member'
    # Three members have been created
    expect(Member.count).to eq(3)

    visit members_path
    expect(page.has_content?('222222222')).to be(true)
    expect(page.has_content?('Alexandria')).to be(true)
    expect(page.has_content?('Curtis')).to be(true)
    expect(page.has_content?('acurtis@tamu.edu')).to be(true)

    # now create 2 officers
    visit new_officer_path
    fill_in 'Officer UIN', with: '111111111'
    fill_in 'Name', with: 'Yue Hu'
    fill_in 'Email', with: 'yueh@tamu.edu'
    click_on 'Create Officer'
    # An officer has been created
    expect(Officer.count).to eq(1)

    visit new_officer_path
    fill_in 'Officer UIN', with: '99999999'
    fill_in 'Name', with: 'Michael Stewart'
    fill_in 'Email', with: 'justin@tamu.edu'
    click_on 'Create Officer'
    # Two officers have been created
    expect(Officer.count).to eq(2)

    visit officers_path
    expect(page.has_content?('99999999')).to be(true)
    expect(page.has_content?('0')).to be(true)
    expect(page.has_content?('Michael Stewart')).to be(true)
    expect(page.has_content?('justin@tamu.edu')).to be(true)

    # now create 3 payment methods
    visit new_payment_method_path
    fill_in 'Method', with: 'Cash'
    click_on 'Create Payment method'
    visit new_payment_method_path
    fill_in 'Method', with: 'Paypal'
    click_on 'Create Payment method'
    visit new_payment_method_path
    fill_in 'Method', with: 'Venmo'
    click_on 'Create Payment method'
    expect(PaymentMethod.count).to eq(3)

    # now create 3 payments
    visit new_payment_path
    fill_in 'Amount', with: '15'
    fill_in 'Notes', with: 'the first payment'
    select 'Alexandria Curtis', from: 'payment[member_uin]'
    select 'Yue Hu', from: 'payment_officer_uin'
    select 'Cash', from: 'payment[method]'
    click_on 'Create Payment'
    expect(page.has_content?('Payment was successfully created.')).to be(true)
    visit payments_path
    expect(page.has_content?('Alexandria Curtis')).to be(true)
    expect(Payment.count).to eq(1)

    visit new_payment_path
    fill_in 'Amount', with: '45'
    fill_in 'Notes', with: 'the second payment'

    select 'Yue Hu', from: 'payment[member_uin]'
    select 'Michael Stewart', from: 'payment_officer_uin'
    select 'Venmo', from: 'payment[method]'
    click_on 'Create Payment'
    expect(page.has_content?('Payment was successfully created.')).to be(true)
    visit payments_path
    expect(page.has_content?('Yue Hu')).to be(true)
    expect(Payment.count).to eq(2)

    visit new_payment_path
    fill_in 'Amount', with: '50'
    fill_in 'Notes', with: 'the third payment'
    select 'Andres Blanco', from: 'payment[member_uin]'
    select 'Michael Stewart', from: 'payment_officer_uin'
    select 'Paypal', from: 'payment[method]'
    click_on 'Create Payment'
    expect(page.has_content?('Payment was successfully created.')).to be(true)
    visit payments_path
    expect(page.has_content?('Yue Hu')).to be(true)
    expect(Payment.count).to eq(3)

    # Yue has 15 amount owed, Michael has 75 amount owed
    visit officers_path
    expect(page.has_content?('95')).to be(true)
    expect(page.has_content?('15')).to be(true)

    # Make the second payment to Yue, change the third payment amount as 90
    visit payments_path
    find(:xpath, "//tr[td[contains(.,'the second payment')]]/td/a", text: 'Edit').click
    select 'Yue Hu', from: 'payment_officer_uin'
    click_on('Update Payment')
    visit officers_path
    expect(page.has_content?('50')).to be(true)
    expect(page.has_content?('60')).to be(true)
    visit payments_path
    find(:xpath, "//tr[td[contains(.,'the third payment')]]/td/a", text: 'Edit').click
    fill_in 'Amount', with: '90'
    click_on('Update Payment')
    visit officers_path
    expect(page.has_content?('90')).to be(true)
    expect(page.has_content?('60')).to be(true)

    # Delete the first payment
    visit payments_path
    find(:xpath, "//tr[td[contains(.,'the first payment')]]/td/a", text: 'Delete').click
    expect(Payment.count).to eq(2)
    visit officers_path
    expect(page.has_content?('90')).to be(true) # Michael
    expect(page.has_content?('45')).to be(true) # yue hu

    # Now create 2 deposits
    visit new_deposit_path
    select 'Yue Hu', from: 'deposit[officer_uin]'
    fill_in 'Amount', with: 13
    fill_in 'Notes', with: 'the first deposit'
    click_on 'Create Deposit'
    expect(page.has_content?('Deposit was successfully created.')).to be(true)
    # An deposit has been created
    expect(Deposit.count).to eq(1)
    visit officers_path
    expect(page.has_content?('90')).to be(true)
    expect(page.has_content?('32')).to be(true)

    visit new_deposit_path
    select 'Michael Stewart', from: 'deposit[officer_uin]'
    fill_in 'Amount', with: 14
    fill_in 'Notes', with: 'the second deposit'
    click_on 'Create Deposit'
    expect(page.has_content?('Deposit was successfully created.')).to be(true)
    expect(Deposit.count).to eq(2)
    visit officers_path
    expect(page.has_content?('76')).to be(true) # Michael
    expect(page.has_content?('32')).to be(true) # yue hu

    # Change the second deposit to Yue, change the first deposit amount from 13 to 3
    visit deposits_path
    find(:xpath, "//tr[td[contains(.,'the second deposit')]]/td/a", text: 'Edit').click
    select 'Yue Hu', from: 'deposit[officer_uin]'
    click_on 'Update Deposit'
    visit officers_path
    expect(page.has_content?('90')).to be(true) # Michael
    expect(page.has_content?('18')).to be(true) # yue hu

    visit deposits_path
    find(:xpath, "//tr[td[contains(.,'the first deposit')]]/td/a", text: 'Edit').click
    fill_in 'Amount', with: '3'
    click_on 'Update Deposit'
    expect(page.has_content?('Deposit was successfully updated.')).to be(true)
    visit officers_path
    expect(page.has_content?('90')).to be(true) # Michael
    expect(page.has_content?('28')).to be(true) # yue hu

    # Delete the sceond depost
    visit deposits_path
    find(:xpath, "//tr[td[contains(.,'the second deposit')]]/td/a", text: 'Destroy').click
    visit officers_path
    expect(page.has_content?('90')).to be(true) # Michael
    expect(page.has_content?('42')).to be(true) # yue hu

    # Now create 2 withdrawals
    visit new_withdrawal_path
    select 'Yue Hu', from: 'withdrawal[officer_uin]'
    fill_in 'Amount', with: '444'
    fill_in 'Notes', with: 'the first withdrawal'
    click_on 'Create Withdrawal'
    expect(page.has_content?('Withdrawal was successfully created.')).to be(true)
    expect(Withdrawal.count).to eq(1)
    visit officers_path
    expect(page.has_content?('90')).to be(true) # Michael
    expect(page.has_content?('42')).to be(true) # yue hu

    visit new_withdrawal_path
    select 'Michael Stewart', from: 'withdrawal[officer_uin]'

    fill_in 'Amount', with: '333'
    fill_in 'Notes', with: 'the second withdrawal'
    click_on 'Create Withdrawal'
    expect(page.has_content?('Withdrawal was successfully created.')).to be(true)
    expect(Withdrawal.count).to eq(2)
    visit officers_path
    expect(page.has_content?('90')).to be(true) # Michael
    expect(page.has_content?('42')).to be(true) # yue hu

    # Change the second withdrawal to Yue, change the first withdrawal amount to 17
    visit withdrawals_path
    find(:xpath, "//tr[td[contains(.,'the second withdrawal')]]/td/a", text: 'Edit').click
    select 'Yue Hu', from: 'withdrawal[officer_uin]'
    click_on 'Update Withdrawal'
    visit officers_path
    expect(page.has_content?('90')).to be(true) # Michael
    expect(page.has_content?('42')).to be(true) # yue hu

    visit withdrawals_path
    find(:xpath, "//tr[td[contains(.,'the first withdrawal')]]/td/a", text: 'Edit').click
    fill_in 'Amount', with: '17'
    click_on 'Update Withdrawal'
    visit officers_path
    expect(page.has_content?('90')).to be(true) # Michael
    expect(page.has_content?('42')).to be(true) # yue hu

    # Delete the sceond withdrawal, and nothing changes
    visit withdrawals_path
    find(:xpath, "//tr[td[contains(.,'the second withdrawal')]]/td/a", text: 'Delete').click
    visit officers_path
    expect(page.has_content?('90')).to be(true) # Michael
    expect(page.has_content?('42')).to be(true) # yue hu
  end
end
