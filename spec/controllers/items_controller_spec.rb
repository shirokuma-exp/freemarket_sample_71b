require 'rails_helper'

describe ItemsController, type: :controller do

  #letを利用してテスト中使用するインスタンスを定義
  # letメソッドは初回の呼び出し時のみ実行される
  let(:user)        { create(:user) }
  let(:item)        { create(:item) }
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

  # showアクション全体のテストコード
  describe 'GET #show' do
      
    # 1.ログイン状態に関わらずshow.html.hamlに遷移すること
    it "renders the :show template" do
      get :show, params: { id: item.id }
      expect(response).to render_template :show
    end

    # 2.showアクションの際のインスタンス変数の中身を確かめる
    it "assigns the requested reservation to @item" do
      get :show, params: { id: item.id }
      expect(assigns(:item)).to eq item
    end

  end

end