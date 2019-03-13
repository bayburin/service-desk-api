class Case < ActiveResource::Base
  self.site = 'https://astraea-ui.iss-reshetnev.ru/api/'
  self.primary_key = :case_id
end
