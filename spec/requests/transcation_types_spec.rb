 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/transcation_types", type: :request do
  
  # TranscationType. As you add validations to TranscationType, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      TranscationType.create! valid_attributes
      get transcation_types_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      transcation_type = TranscationType.create! valid_attributes
      get transcation_type_url(transcation_type)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_transcation_type_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      transcation_type = TranscationType.create! valid_attributes
      get edit_transcation_type_url(transcation_type)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new TranscationType" do
        expect {
          post transcation_types_url, params: { transcation_type: valid_attributes }
        }.to change(TranscationType, :count).by(1)
      end

      it "redirects to the created transcation_type" do
        post transcation_types_url, params: { transcation_type: valid_attributes }
        expect(response).to redirect_to(transcation_type_url(TranscationType.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new TranscationType" do
        expect {
          post transcation_types_url, params: { transcation_type: invalid_attributes }
        }.to change(TranscationType, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post transcation_types_url, params: { transcation_type: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested transcation_type" do
        transcation_type = TranscationType.create! valid_attributes
        patch transcation_type_url(transcation_type), params: { transcation_type: new_attributes }
        transcation_type.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the transcation_type" do
        transcation_type = TranscationType.create! valid_attributes
        patch transcation_type_url(transcation_type), params: { transcation_type: new_attributes }
        transcation_type.reload
        expect(response).to redirect_to(transcation_type_url(transcation_type))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        transcation_type = TranscationType.create! valid_attributes
        patch transcation_type_url(transcation_type), params: { transcation_type: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested transcation_type" do
      transcation_type = TranscationType.create! valid_attributes
      expect {
        delete transcation_type_url(transcation_type)
      }.to change(TranscationType, :count).by(-1)
    end

    it "redirects to the transcation_types list" do
      transcation_type = TranscationType.create! valid_attributes
      delete transcation_type_url(transcation_type)
      expect(response).to redirect_to(transcation_types_url)
    end
  end
end
