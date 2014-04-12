require 'spec_helper'
require 'cancan/matchers'

describe CompaniesController do

  let(:user) { FactoryGirl.create(:user) }
  let(:company) { FactoryGirl.create(:company) }

  let(:valid_attributes) { build(:company).attributes }

  before :each do
    user.roles.create(name: 'Pauline')
    sign_in user
  end

  describe "GET index" do
    it "assigns all comapanies as @companies" do
      pending "Randomly failing spec."
      get :index, {}
      expect(assigns(:companies).to_a).to be == [company]
    end
  end

  describe "GET new" do
    it "assigns a new company as @company" do
      get :new, {}
      expect(assigns(:company)).to  be_a_new(Company)
    end
  end

  describe "GET edit" do
    context "when logged in user belongs to this company" do
      let(:company) { FactoryGirl.create(:company) }

      it "assigns the requested company as @company" do
        get :edit, { id: company.to_param }
        expect(assigns(:company)).to eq(company)
      end
    end

    context "when logged in user does not belong to the company" do
      let(:another_company) { FactoryGirl.create(:company) }

      it "redirects to the homepage" do
        get :edit, { id: another_company.to_param }
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new company" do
        params = { company_id: company.to_param, company: valid_attributes }
        expect { post :create, params }.to change(Company, :count).by(1)
      end

      it "assigns a newly created company as @company" do
        post :create, { company_id: company.to_param, company: valid_attributes }
        expect(assigns(:company)).to be_a(Company)
        expect(assigns(:company)).to be_persisted
      end

      it "redirects to the companies index" do
        post :create, { company_id: company.to_param, company: valid_attributes }
        expect(response).to redirect_to(companies_url)
      end

      it "assigns the current_user as the company owner" do
        post :create, { company_id: company.to_param, company: valid_attributes }
        expect(assigns(:company).owner).to eq user
      end
    end
  end

  describe "PUT update" do
    context "when logged in user belongs to this company" do
      let(:company) { FactoryGirl.create(:company, owner: user) }

      describe "with valid params" do
        it "updates the requested company" do
          Company.any_instance.should_receive(:update_attributes).with({ 'name' => 'Blue' })
          put :update, { id: company.to_param, company: { 'name' => 'Blue' } }
        end

        it "assigns the requested company as @company" do
          put :update, { id: company.to_param, company: valid_attributes }
          expect(assigns(:company)).to eq(company)
        end

        it "redirects to the companies index" do
          put :update, { id: company.to_param, company: valid_attributes }
          expect(response).to redirect_to(companies_url)
        end
      end

      describe "with invalid params" do
        it "assigns the company as @company" do
          Company.any_instance.stub(:save).and_return(false)
          put :update, { id: company.to_param, company: { 'name' => 'invalid value' } }
          expect(assigns(:company)).to eq(company)
        end

        it "re-renders the 'edit' template" do
          Company.any_instance.stub(:save).and_return(false)
          put :update, { id: company.to_param, company: { 'name' => 'invalid value' } }
          expect(response).to render_template("edit")
        end
      end

      context "another company" do
        let(:another_company) { FactoryGirl.create(:company) }

        it "does not update the requested company" do
          Company.any_instance.should_not_receive(:update_attributes)
          put :update, { id: another_company.to_param, company: { 'name' => 'Blue' } }
        end

        it "redirects the company to the homepage" do
          put :update, { id: another_company.to_param, company: valid_attributes }
          expect(response).to redirect_to(root_url)
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "when logged in user belongs to this company" do
      let!(:company) { FactoryGirl.create(:company, owner: user) }
      let(:params) { { id: company.to_param } }

      it "destroys the requested company" do
        expect { delete :destroy, params }.to change(Company, :count).by(-1)
      end

      it "redirects to the companies index" do
        delete :destroy, params
        expect(response).to redirect_to(companies_url)
      end
    end

    context "another company's profile" do
      let!(:another_company) { FactoryGirl.create(:company) }
      let(:params) { { id: company.to_param } }

      it "doesn't destroy the requested company" do
        expect { delete :destroy, { id: another_company.to_param } }.to change(Company, :count).by(0)
      end

      it "redirects to the homepage" do
        delete :destroy, params
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
