company = Company.where( name: 'RuanShan').first_or_create!( desc: 'Dalian Ruanshan network Co.,Ltd.')


User.where(company_id: nil).update_all company_id:  company.id
