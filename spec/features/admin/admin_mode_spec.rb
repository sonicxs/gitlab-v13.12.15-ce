# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Admin mode' do
  include MobileHelpers
  include StubENV

  let(:admin) { create(:admin) }

  shared_examples 'combined_menu: feature flag examples' do
    before do
      stub_env('IN_MEMORY_APPLICATION_SETTINGS', 'false')
    end

    context 'application setting :admin_mode is enabled', :request_store do
      before do
        sign_in(admin)
      end

      context 'when not in admin mode' do
        it 'has no leave admin mode button' do
          visit new_admin_session_path

          page.within('.navbar-sub-nav') do
            expect(page).not_to have_link(href: destroy_admin_session_path)
          end
        end

        it 'can open pages not in admin scope' do
          pending_on_combined_menu_flag

          visit new_admin_session_path

          page.within('.navbar-sub-nav') do
            find_all('a', text: 'Projects').first.click
          end

          expect(page).to have_current_path(dashboard_projects_path)
        end

        it 'is necessary to provide credentials again before opening pages in admin scope' do
          visit general_admin_application_settings_path # admin logged out because not in admin_mode

          expect(page).to have_current_path(new_admin_session_path)
        end

        it 'can enter admin mode' do
          visit new_admin_session_path

          fill_in 'user_password', with: admin.password

          click_button 'Enter Admin Mode'

          expect(page).to have_current_path(admin_root_path)
        end

        context 'on a read-only instance' do
          before do
            allow(Gitlab::Database).to receive(:read_only?).and_return(true)
          end

          it 'can enter admin mode' do
            visit new_admin_session_path

            fill_in 'user_password', with: admin.password

            click_button 'Enter Admin Mode'

            expect(page).to have_current_path(admin_root_path)
          end
        end
      end

      context 'when in admin_mode' do
        before do
          gitlab_enable_admin_mode_sign_in(admin)
        end

        it 'contains link to leave admin mode' do
          pending_on_combined_menu_flag

          page.within('.navbar-sub-nav') do
            expect(page).to have_link(href: destroy_admin_session_path)
          end
        end

        it 'can leave admin mode using main dashboard link', :js do
          pending_on_combined_menu_flag

          page.within('.navbar-sub-nav') do
            click_on 'Leave Admin Mode'

            expect(page).to have_link(href: new_admin_session_path)
          end
        end

        it 'can leave admin mode using dropdown menu on smaller screens', :js do
          pending_on_combined_menu_flag

          resize_screen_xs
          visit root_dashboard_path

          find('.header-more').click

          page.within '.navbar-sub-nav' do
            click_on 'Leave Admin Mode'

            find('.header-more').click

            expect(page).to have_link(href: new_admin_session_path)
          end
        end

        it 'can open pages not in admin scope' do
          pending_on_combined_menu_flag

          page.within('.navbar-sub-nav') do
            find_all('a', text: 'Projects').first.click

            expect(page).to have_current_path(dashboard_projects_path)
          end
        end

        context 'nav bar' do
          it 'shows admin dashboard links on bigger screen' do
            pending_on_combined_menu_flag

            visit root_dashboard_path

            page.within '.navbar' do
              expect(page).to have_link(text: 'Admin Area', href: admin_root_path, visible: true)
              expect(page).to have_link(text: 'Leave Admin Mode', href: destroy_admin_session_path, visible: true)
            end
          end

          it 'relocates admin dashboard links to dropdown list on smaller screen', :js do
            pending_on_combined_menu_flag

            resize_screen_xs
            visit root_dashboard_path

            page.within '.navbar' do
              expect(page).not_to have_link(text: 'Leave Admin Mode', href: destroy_admin_session_path, visible: true)
            end

            find('.header-more').click

            page.within '.navbar' do
              expect(page).to have_link(text: 'Admin Area', href: admin_root_path, visible: true)
              expect(page).to have_link(text: 'Leave Admin Mode', href: destroy_admin_session_path, visible: true)
            end
          end
        end

        context 'on a read-only instance' do
          before do
            allow(Gitlab::Database).to receive(:read_only?).and_return(true)
          end

          it 'can leave admin mode', :js do
            pending_on_combined_menu_flag

            page.within('.navbar-sub-nav') do
              click_on 'Leave Admin Mode'

              expect(page).to have_link(href: new_admin_session_path)
            end
          end
        end
      end
    end

    context 'application setting :admin_mode is disabled' do
      before do
        stub_application_setting(admin_mode: false)
        sign_in(admin)
      end

      it 'shows no admin mode buttons in navbar' do
        visit admin_root_path

        page.within('.navbar-sub-nav') do
          expect(page).not_to have_link(href: new_admin_session_path)
          expect(page).not_to have_link(href: destroy_admin_session_path)
        end
      end
    end
  end

  context 'with combined_menu: feature flag on' do
    let(:needs_rewrite_for_combined_menu_flag_on) { true }

    before do
      stub_feature_flags(combined_menu: true)
    end

    it_behaves_like 'combined_menu: feature flag examples'
  end

  context 'with combined_menu feature flag off' do
    let(:needs_rewrite_for_combined_menu_flag_on) { false }

    before do
      stub_feature_flags(combined_menu: false)
    end

    it_behaves_like 'combined_menu: feature flag examples'
  end

  def pending_on_combined_menu_flag
    pending 'https://gitlab.com/gitlab-org/gitlab/-/merge_requests/56587' if needs_rewrite_for_combined_menu_flag_on
  end
end
