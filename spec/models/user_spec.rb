require 'rails_helper'

describe User do
  describe '#create' do
  
    # email、passwordとpassword_confirmationが存在すれば登録できる
    it "is valid with an email, password, password_confirmation" do
      user = build(:user)
      expect(user).to be_valid
    end
    # emailが空では登録できない
    it "is invalid without a email" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end
    # passwordが空では登録できない
    it "is invalid without a password" do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end
    # # passwordが存在してもpassword_confirmationが空では登録できない
    it "is invalid without a password_confirmation although with a password" do
      user = build(:user, password_confirmation: "")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
    # # 重複したemailが存在する場合登録できない
    it "is invalid with a duplicate email address" do
      user = create(:user)
      another_user = build(:user, email: user.email)
      another_user.valid?
      expect(another_user.errors[:email]).to include("has already been taken")
    end
    # # passwordが6文字以上であれば登録できる
    it "is valid with a password that has more than 6 characters" do
      user = create(:user, password: "000000",password_confirmation: "000000")
      user.valid?
      expect(user).to be_valid
    end
    # # passwordが5文字以下であれば登録できない
    it "is invalid with a password that has less than 5 characters " do
      user = build(:user, password: "00000", password_confirmation: "00000")
      user.valid?
      expect(user.errors[:password][0]).to include("is too short")
    end

#   end
# end