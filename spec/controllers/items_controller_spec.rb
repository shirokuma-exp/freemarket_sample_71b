require 'rails_helper'

describe ItemsController, type: :controller do

  #letを利用してテスト中使用するインスタンスを定義
  # letメソッドは初回の呼び出し時のみ実行される
  let(:user)        { create(:user) }
  let(:item)        { create(:item) }
  let(:photo)       { create(:photo) }

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

  # # editアクション全体のテストコード
  # describe 'GET #edit' do

  #   # editアクションかつUserがログインしている時のテスト
  #   context 'log in' do
  #     before do
  #       login user
  #       get :edit, params: { id: item.id }
  #     end
      
  #     # 1.ログイン状態ではedit.html.hamlに遷移すること
  #     it "renders the :edit template" do
  #       expect(response).to render_template :edit
  #     end
  #   end

  #    # editアクションかつUserがログアウトしている時のテスト
  #    context 'not log in' do
  #     before do
  #       get :edit, params: { id: item.id }
  #     end

  #     # 1.ログアウト状態ではトップページに遷移すること
  #     it 'redirects to root_path' do
  #       expect(response).to redirect_to(root_path)
  #     end
  #   end
  # end

  # indexアクション全体のテストコード
  describe 'GET #index' do
      
    # 1.ログイン状態に関わらずindex.html.hamlに遷移すること
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end

    # 2.indexアクションの際のインスタンス変数の中身を確かめる
    it "populates an array of items ordered by created_at DESC" do
      items = create_list(:item, 3) 
      get :index
      expect(assigns(:items)).to match(items.sort{ |a, b| b.created_at <=> a.created_at } )
    end

  end
  
  # # createアクション全体のテストコード
  # describe 'POST #create' do
    
  #   context 'log in' do
  #     # この中にログインしている場合のテストを記述
  #     before do
  #       login user
  #     end

  #     # この中にメッセージの保存に成功した場合のテストを記述
  #     context 'can save' do
  #       subject {
  #         post :create, params: { user_id: user.id, item: attributes_for(:item), item_images_attributes: [ FactoryBot.attributes_for( :photo[:image] )] } 
  #       }

  #       # 1.予約が保存できること
  #       it 'count up reservation' do
  #         expect{ subject }.to change(Item, :count).by(1)
  #       end

  #       # 2.予約完了した時にホーム画面に戻ること
  #       it 'redirects to root_path' do
  #         subject
  #         expect(response).to redirect_to(root_path)
  #       end
      
  #     end

  #     # この中にメッセージの保存に失敗した場合のテストを記述
  #     context 'can not save' do
  #       let(:invalid_params) { { user_id: user.id, item: attributes_for(:item, receivedate: nil) } }

  #       subject {
  #         post :create,
  #         params: invalid_params
  #       }

  #       # 1.予約の保存が失敗していること
  #       it 'does not count up' do
  #         expect{ subject }.not_to change(Item, :count)
  #       end

  #       # 2.予約が失敗時にnew.html.hamlに遷移すること
  #       it 'redirects to new_user_reservation_path' do
  #         subject
  #         expect(response).to redirect_to(new_user_reservation_path)
  #       end

  #     end
  #   end

  #   context 'not log in' do
  #   # この中にログインしていない場合のテストを記述
  #   it 'redirects to new_user_session_path' do
  #     post :create, params: params
  #     expect(response).to redirect_to(new_user_session_path)
  #   end
  
  #   end
  # end
end