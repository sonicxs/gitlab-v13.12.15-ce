<script>
import {
  GlFilteredSearchToken,
  GlAvatar,
  GlFilteredSearchSuggestion,
  GlDropdownDivider,
  GlLoadingIcon,
} from '@gitlab/ui';
import { debounce } from 'lodash';

import { deprecatedCreateFlash as createFlash } from '~/flash';
import { __ } from '~/locale';

import { DEFAULT_LABEL_ANY, DEBOUNCE_DELAY } from '../constants';

export default {
  components: {
    GlFilteredSearchToken,
    GlAvatar,
    GlFilteredSearchSuggestion,
    GlDropdownDivider,
    GlLoadingIcon,
  },
  props: {
    config: {
      type: Object,
      required: true,
    },
    value: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      authors: this.config.initialAuthors || [],
      defaultAuthors: this.config.defaultAuthors || [DEFAULT_LABEL_ANY],
      loading: true,
    };
  },
  computed: {
    currentValue() {
      return this.value.data.toLowerCase();
    },
    activeAuthor() {
      return this.authors.find((author) => author.username.toLowerCase() === this.currentValue);
    },
    activeAuthorAvatar() {
      return this.avatarUrl(this.activeAuthor);
    },
  },
  watch: {
    active: {
      immediate: true,
      handler(newValue) {
        if (!newValue && !this.authors.length) {
          this.fetchAuthorBySearchTerm(this.value.data);
        }
      },
    },
  },
  methods: {
    fetchAuthorBySearchTerm(searchTerm) {
      const fetchPromise = this.config.fetchPath
        ? this.config.fetchAuthors(this.config.fetchPath, searchTerm)
        : this.config.fetchAuthors(searchTerm);

      fetchPromise
        .then((res) => {
          // We'd want to avoid doing this check but
          // users.json and /groups/:id/members & /projects/:id/users
          // return response differently.
          this.authors = Array.isArray(res) ? res : res.data;
        })
        .catch(() => createFlash(__('There was a problem fetching users.')))
        .finally(() => {
          this.loading = false;
        });
    },
    avatarUrl(author) {
      return author.avatarUrl || author.avatar_url;
    },
    searchAuthors: debounce(function debouncedSearch({ data }) {
      this.fetchAuthorBySearchTerm(data);
    }, DEBOUNCE_DELAY),
  },
};
</script>

<template>
  <gl-filtered-search-token
    :config="config"
    v-bind="{ ...$props, ...$attrs }"
    v-on="$listeners"
    @input="searchAuthors"
  >
    <template #view="{ inputValue }">
      <gl-avatar
        v-if="activeAuthor"
        :size="16"
        :src="activeAuthorAvatar"
        shape="circle"
        class="gl-mr-2"
      />
      <span>{{ activeAuthor ? activeAuthor.name : inputValue }}</span>
    </template>
    <template #suggestions>
      <gl-filtered-search-suggestion
        v-for="author in defaultAuthors"
        :key="author.value"
        :value="author.value"
      >
        {{ author.text }}
      </gl-filtered-search-suggestion>
      <gl-dropdown-divider v-if="defaultAuthors.length" />
      <gl-loading-icon v-if="loading" />
      <template v-else>
        <gl-filtered-search-suggestion
          v-for="author in authors"
          :key="author.username"
          :value="author.username"
        >
          <div class="d-flex">
            <gl-avatar :size="32" :src="avatarUrl(author)" />
            <div>
              <div>{{ author.name }}</div>
              <div>@{{ author.username }}</div>
            </div>
          </div>
        </gl-filtered-search-suggestion>
      </template>
    </template>
  </gl-filtered-search-token>
</template>
