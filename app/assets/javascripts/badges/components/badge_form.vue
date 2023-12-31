<script>
/* eslint-disable vue/no-v-html */
import { GlLoadingIcon, GlFormInput, GlFormGroup, GlButton } from '@gitlab/ui';
import { escape, debounce } from 'lodash';
import { mapActions, mapState } from 'vuex';
import { deprecatedCreateFlash as createFlash } from '~/flash';
import { s__, sprintf } from '~/locale';
import createEmptyBadge from '../empty_badge';
import Badge from './badge.vue';

const badgePreviewDelayInMilliseconds = 1500;

export default {
  name: 'BadgeForm',
  components: {
    Badge,
    GlButton,
    GlLoadingIcon,
    GlFormInput,
    GlFormGroup,
  },
  props: {
    isEditing: {
      type: Boolean,
      required: true,
    },
  },
  data() {
    return {
      wasValidated: false,
    };
  },
  computed: {
    ...mapState([
      'badgeInAddForm',
      'badgeInEditForm',
      'docsUrl',
      'isRendering',
      'isSaving',
      'renderedBadge',
    ]),
    badge() {
      if (this.isEditing) {
        return this.badgeInEditForm;
      }

      return this.badgeInAddForm;
    },
    helpText() {
      const placeholders = ['project_path', 'project_id', 'default_branch', 'commit_sha']
        .map((placeholder) => `<code>%{${placeholder}}</code>`)
        .join(', ');
      return sprintf(
        s__('Badges|Supported %{docsLinkStart}variables%{docsLinkEnd}: %{placeholders}'),
        {
          docsLinkEnd: '</a>',
          docsLinkStart: `<a href="${escape(this.docsUrl)}">`,
          placeholders,
        },
        false,
      );
    },
    renderedImageUrl() {
      return this.renderedBadge ? this.renderedBadge.renderedImageUrl : '';
    },
    renderedLinkUrl() {
      return this.renderedBadge ? this.renderedBadge.renderedLinkUrl : '';
    },
    name: {
      get() {
        return this.badge ? this.badge.name : '';
      },
      set(name) {
        const badge = this.badge || createEmptyBadge();
        this.updateBadgeInForm({
          ...badge,
          name,
        });
      },
    },
    imageUrl: {
      get() {
        return this.badge ? this.badge.imageUrl : '';
      },
      set(imageUrl) {
        const badge = this.badge || createEmptyBadge();
        this.updateBadgeInForm({
          ...badge,
          imageUrl,
        });
      },
    },
    linkUrl: {
      get() {
        return this.badge ? this.badge.linkUrl : '';
      },
      set(linkUrl) {
        const badge = this.badge || createEmptyBadge();
        this.updateBadgeInForm({
          ...badge,
          linkUrl,
        });
      },
    },
    badgeImageUrlExample() {
      const exampleUrl =
        'https://example.gitlab.com/%{project_path}/badges/%{default_branch}/pipeline.svg';
      return sprintf(s__('Badges|Example: %{exampleUrl}'), {
        exampleUrl,
      });
    },
    badgeLinkUrlExample() {
      const exampleUrl = 'https://example.gitlab.com/%{project_path}';
      return sprintf(s__('Badges|Example: %{exampleUrl}'), {
        exampleUrl,
      });
    },
  },
  methods: {
    ...mapActions(['addBadge', 'renderBadge', 'saveBadge', 'stopEditing', 'updateBadgeInForm']),
    debouncedPreview: debounce(function preview() {
      this.renderBadge();
    }, badgePreviewDelayInMilliseconds),
    onCancel() {
      this.stopEditing();
    },
    onSubmit() {
      const form = this.$el;
      if (!form.checkValidity()) {
        this.wasValidated = true;
        return Promise.resolve();
      }

      if (this.isEditing) {
        return this.saveBadge()
          .then(() => {
            createFlash(s__('Badges|Badge saved.'), 'notice');
            this.wasValidated = false;
          })
          .catch((error) => {
            createFlash(
              s__('Badges|Saving the badge failed, please check the entered URLs and try again.'),
            );
            throw error;
          });
      }

      return this.addBadge()
        .then(() => {
          createFlash(s__('Badges|New badge added.'), 'notice');
          this.wasValidated = false;
        })
        .catch((error) => {
          createFlash(
            s__('Badges|Adding the badge failed, please check the entered URLs and try again.'),
          );
          throw error;
        });
    },
  },
};
</script>

<template>
  <form
    :class="{ 'was-validated': wasValidated }"
    class="gl-mt-3 gl-mb-3 needs-validation"
    novalidate
    @submit.prevent.stop="onSubmit"
  >
    <gl-form-group :label="s__('Badges|Name')" label-for="badge-name">
      <gl-form-input id="badge-name" v-model="name" />
    </gl-form-group>

    <div class="form-group">
      <label for="badge-link-url" class="label-bold">{{ s__('Badges|Link') }}</label>
      <p v-html="helpText"></p>
      <input
        id="badge-link-url"
        v-model="linkUrl"
        type="URL"
        class="form-control gl-form-input"
        required
        @input="debouncedPreview"
      />
      <div class="invalid-feedback">{{ s__('Badges|Enter a valid URL') }}</div>
      <span class="form-text text-muted">{{ badgeLinkUrlExample }}</span>
    </div>

    <div class="form-group">
      <label for="badge-image-url" class="label-bold">{{ s__('Badges|Badge image URL') }}</label>
      <p v-html="helpText"></p>
      <input
        id="badge-image-url"
        v-model="imageUrl"
        type="URL"
        class="form-control gl-form-input"
        required
        @input="debouncedPreview"
      />
      <div class="invalid-feedback">{{ s__('Badges|Enter a valid URL') }}</div>
      <span class="form-text text-muted">{{ badgeImageUrlExample }}</span>
    </div>

    <div class="form-group">
      <label for="badge-preview">{{ s__('Badges|Badge image preview') }}</label>
      <badge
        v-show="renderedBadge && !isRendering"
        id="badge-preview"
        :image-url="renderedImageUrl"
        :link-url="renderedLinkUrl"
      />
      <p v-show="isRendering">
        <gl-loading-icon :inline="true" />
      </p>
      <p v-show="!renderedBadge && !isRendering" class="disabled-content">
        {{ s__('Badges|No image to preview') }}
      </p>
    </div>

    <div v-if="isEditing" class="row-content-block">
      <gl-button class="btn-cancel gl-mr-4" data-testid="cancelEditing" @click="onCancel">
        {{ __('Cancel') }}
      </gl-button>
      <gl-button
        :loading="isSaving"
        type="submit"
        variant="confirm"
        category="primary"
        data-testid="saveEditing"
      >
        {{ s__('Badges|Save changes') }}
      </gl-button>
    </div>
    <div v-else class="form-group">
      <gl-button :loading="isSaving" type="submit" variant="confirm" category="primary">
        {{ s__('Badges|Add badge') }}
      </gl-button>
    </div>
  </form>
</template>
