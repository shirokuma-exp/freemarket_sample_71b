require 'rails_helper'

describe ItemsController, type: :controller do

  #letを利用してテスト中使用するインスタンスを定義
  # letメソッドは初回の呼び出し時のみ実行される
  let(:user)        { create(:user) }

  # newアクション全体のテストコード
  describe 'GET #new' do

    # newアクションかつUserがログインしている時のテスト
    context 'log in' do
      before do
        login user
        get :new
      end
      
      # 1.ログイン状態ではnew.html.hamlに遷移すること
      it "renders the :new template" do
        expect(response).to render_template :new
      end
    end

     # newアクションかつUserがログアウトしている時のテスト
     context 'not log in' do
      before do
        get :new
      end

      # 1.ログアウト状態ではトップページに遷移すること
      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

end