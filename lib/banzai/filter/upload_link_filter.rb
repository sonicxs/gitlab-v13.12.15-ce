# frozen_string_literal: true

require 'uri'

module Banzai
  module Filter
    # HTML filter that "fixes" links to uploads.
    #
    # Context options:
    #   :group
    #   :only_path
    #   :project
    #   :system_note
    class UploadLinkFilter < BaseRelativeLinkFilter
      def call
        return doc if context[:system_note]

        if Feature.enabled?(:optimize_linkable_attributes, project, default_enabled: :yaml)
          # We exclude processed upload links from the linkable attributes to
          # prevent further modifications by RepositoryLinkFilter
          linkable_attributes.reject! do |attr|
            process_link_to_upload_attr(attr)
          end
        else
          linkable_attributes.each do |attr|
            process_link_to_upload_attr(attr)
          end
        end

        doc
      end

      protected

      def process_link_to_upload_attr(html_attr)
        return unless html_attr.value.start_with?('/uploads/')

        path_parts = [unescape_and_scrub_uri(html_attr.value)]

        if project
          path_parts.unshift(relative_url_root, project.full_path)
        elsif group
          path_parts.unshift(relative_url_root, 'groups', group.full_path, '-')
        else
          path_parts.unshift(relative_url_root)
        end

        begin
          path = Addressable::URI.escape(File.join(*path_parts))
        rescue Addressable::URI::InvalidURIError
          return
        end

        html_attr.value =
          if context[:only_path]
            path
          else
            Addressable::URI.join(Gitlab.config.gitlab.base_url, path).to_s
          end

        if html_attr.name == 'href'
          html_attr.parent.set_attribute('data-link', 'true')
        end

        html_attr.parent.add_class('gfm')
      end

      def group
        context[:group]
      end
    end
  end
end
