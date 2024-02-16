require 'rails_helper'
require './app/services/posts_for_branch_service.rb'

describe PostsForBranchService do

  context '#call' do
    let(:not_included_posts) { create_list(:post, 2) }
    let(:category) { create(:category, branch: 'hobby', name: 'arts') }
    let(:post) do
      create(:post,
              title: 'a very fun post', 
              category_id: category.id)
    end
    it 'returns posts filtered by a branch' do
      not_included_posts
      category
      included_posts = create_list(:post, 2, category_id: category.id)
      expect(PostsForBranchService.new({branch: 'hobby'}).call).to(
        match_array included_posts
      )
    end

    it 'returns posts filtered by a branch and a search input' do
      not_included_posts
      category
      included_post = [] << post
      expect(PostsForBranchService.new({branch: 'hobby', search: 'fun'}).call).to(
        eq included_post
      )
    end

    it 'returns posts filtered by a category name' do
      not_included_posts
      category
      included_post = [] << post
      expect(PostsForBranchService.new({branch: 'hobby', category: 'arts'}).call).to(
        eq included_post
      )
    end

    it 'returns posts filtered by a category name and a search input' do
      not_included_posts
      category
      included_post = [] << post
      expect(PostsForBranchService.new({name: 'arts', 
                                        search: 'fun', 
                                        branch: 'hobby'}).call).to eq included_post
    end
  end
end

RSpec.describe PostsHelper, :type => :helper do
  context '#create_new_post_partial_path' do
    it "returns a signed_in partial's path" do
      allow(helper).to receive(:user_signed_in?).and_return(true)
      expect(helper.create_new_post_partial_path).to eq 'posts/branch/create_new_post/signed_in'
    end

    it "returns a signed_in partial's path" do
      allow(helper).to receive(:user_signed_in?).and_return(false)
      expect(helper.create_new_post_partial_path).to eq 'posts/branch/create_new_post/not_signed_in'
    end
  end

  context '#all_categories_button_partial_path' do
    it "returns an all_selected partial's path" do
      controller.params[:category] = ''
      expect(helper.all_categories_button_partial_path).to eq 'posts/branch/categories/all_selected'
    end

    it "returns an all_not_selected partial's path" do
      controller.params[:category] = 'category'
      expect(helper.all_categories_button_partial_path).to eq 'posts/branch/categories/all_not_selected'
    end
  end

  context '#no_posts_partial_path' do
    it "returns a no_posts partial's path" do
      assign(:posts, [])
      expect(helper.no_posts_partial_path([])).to eq 'shared/no_posts'
    end

    it "returns an empty partial's path" do
      assign(:posts, [1])
      expect(helper.no_posts_partial_path([1])).to eq 'shared/empty_partial'
    end
  end

  context '#post_format_partial_path' do
    it "returns a home_page partial's path" do
      allow(helper).to receive(:current_page?).and_return(true)
      expect(helper.post_format_partial_path).to eq 'posts/post/home_page'
    end

    it "returns a branch_page partial's path" do
      allow(helper).to receive(:current_page?).and_return(false)
      expect(helper.post_format_partial_path).to eq 'posts/post/branch_page'
    end
  end

  context '#update_pagination_partial_path' do
    it "returns an update_pagination partial's path" do
      posts = double('posts', :next_page => 2)
      assign(:posts, posts)
      expect(helper.update_pagination_partial_path).to(
        eq 'posts/posts_pagination_page/update_pagination'
      )
    end

    it "returns a remove_pagination partial's path" do
      posts = double('posts', :next_page => nil)
      assign(:posts, posts)
      expect(helper.update_pagination_partial_path).to(
        eq 'posts/posts_pagination_page/remove_pagination'
      )
    end
  end
end