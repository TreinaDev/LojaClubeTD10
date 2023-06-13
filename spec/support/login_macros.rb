def login(user)
  click_on 'Entrar'
  
  fill_in 'Email', with: user.email 
  fill_in 'Password', with: user.password
  
  within('form') do
    click_on 'Log in'
  end
end


    