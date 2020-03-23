class Delivery_way < ActiveHash::Base
  self.data = [
      {id: 1, name: '未定'}, {id: 2, name: 'クロネコヤマト'}, {id: 3, name: 'ゆうパック'},
      {id: 4, name: 'ゆうメール'}
  ]
end