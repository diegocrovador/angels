require 'rails_helper'

feature 'user create a group and join into' do
  scenario 'successfully' do
    market = create(:market)
    investors = create_list(:investor, 3)

    visit market_path(market)
    login_as(investors.first, scope: :investor)

    click_on 'Criar Grupo'

    fill_in 'group_name',         with: 'Bootcampers'
    fill_in 'group_description',  with: 'Lorem ipsum'
    check   investors.first.name
    check   investors.last.name

    click_on 'Cadastrar'

    expect(page).to have_css('h1', text: 'Bootcampers')
    expect(page).to have_css('p', text: 'Lorem ipsum')
    expect(page).to have_css('p', text: investors.first.name)
    expect(page).to have_css('p', text: investors.last.name)
    expect(page).to have_css('p', text: market.name)
  end

  scenario 'fail unless authenticated' do
    market = create(:market)
    visit market_path(market)

    click_on 'Criar Grupo'

    expect(current_path).to eq new_investor_session_path
  end

  scenario 'fail without required fields' do
    market = create(:market)
    visit market_path(market)
    investor = create(:investor)
    login_as(investor, scope: :investor)

    click_on 'Criar Grupo'

    click_on 'Cadastrar'

    within('.group_name') { expect(page).to have_content 'can\'t be blank' }
    within('.group_description') { expect(page).to have_content 'can\'t be blank' }
  end

end
