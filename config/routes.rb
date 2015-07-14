Rails.application.routes.draw do

  root 'browser#view'
  get 'stream' => 'browser#index'
  get 'view' => 'browser#view'

end
