import { __ } from '~/locale';

export const MERGE_DISABLED_TEXT = __('You can only merge once the items above are resolved.');
export const MERGE_DISABLED_TEXT_UNAPPROVED = __(
  'You can only merge once this merge request is approved by all reviewers.',
);
export const PIPELINE_MUST_SUCCEED_CONFLICT_TEXT = __(
  'A CI/CD pipeline must run and be successful before merge.',
);

export default {
  computed: {
    isApprovalNeeded() {
      return !this.mr.isApproved;
    },
    isMergeButtonDisabled() {
      const { commitMessage } = this;
      return Boolean(
        !commitMessage.length ||
          !this.shouldShowMergeControls ||
          this.isMakingRequest ||
          this.isApprovalNeeded ||
          this.mr.preventMerge,
      );
    },
    mergeDisabledText() {
      if (this.isApprovalNeeded) {
        return MERGE_DISABLED_TEXT_UNAPPROVED;
      }
      return MERGE_DISABLED_TEXT;
    },
    pipelineMustSucceedConflictText() {
      return PIPELINE_MUST_SUCCEED_CONFLICT_TEXT;
    },
    autoMergeText() {
      // MWPS is currently the only auto merge strategy available in CE
      return __('Merge when pipeline succeeds');
    },
    shouldShowMergeImmediatelyDropdown() {
      return this.isPipelineActive && !this.stateData.onlyAllowMergeIfPipelineSucceeds;
    },
    isMergeImmediatelyDangerous() {
      return false;
    },
    shouldRenderMergeTrainHelperText() {
      return false;
    },
    pipelineId() {
      return this.pipeline.id;
    },
  },
};
