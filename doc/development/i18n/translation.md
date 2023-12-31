---
stage: Manage
group: Import
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#assignments
---

# Translating GitLab

For managing the translation process we use [CrowdIn](https://crowdin.com).

## Using CrowdIn

The first step is to get familiar with CrowdIn.

### Sign In

To contribute translations at <https://translate.gitlab.com>
you must create a CrowdIn account.
You may create a new account or use any of their supported sign in services.

### Language Selections

GitLab is being translated into many languages.

1. Find the language that you want to contribute to, in our
   [GitLab Crowdin project](https://crowdin.com/project/gitlab-ee).
   - If the language that you're looking for is available, proceed
     to the next step.
   - If the language you are looking for is not available,
      [open an issue](https://gitlab.com/gitlab-org/gitlab/-/issues?scope=all&utf8=✓&state=all&label_name[]=Category%3AInternationalization). Notify our Crowdin
      administrators by including `@gitlab-org/manage/import` in your issue.
   - After the issue/Merge Request is complete, restart this procedure.
1. Next, you can view list of files and folders.
   Select `gitlab.pot` to open the translation editor.

### Translation Editor

The online translation editor is the easiest way to contribute translations.

![CrowdIn Editor](img/crowdin-editor.png)

1. Strings for translation are listed in the left panel
1. Translations are entered into the central panel.
  Multiple translations are required for strings that contains plurals.
  The string to be translated is shown above with glossary terms highlighted.
  If the string to be translated is not clear, you can 'Request Context'

A glossary of common terms is available in the right panel by clicking Terms.
Comments can be added to discuss a translation with the community.

Remember to **Save** each translation.

## General Translation Guidelines

Be sure to check the following guidelines before you translate any strings.

### Namespaced strings

When an externalized string is prepended with a namespace, e.g.
`s_('OpenedNDaysAgo|Opened')`, the namespace should be removed from the final
translation.
For example in French `OpenedNDaysAgo|Opened` would be translated to
`Ouvert•e`, not `OpenedNDaysAgo|Ouvert•e`.

### Technical terms

Some technical terms should be treated like proper nouns and not be translated.

Technical terms that should always be in English are noted in the glossary when
using <https://translate.gitlab.com>.

This helps maintain a logical connection and consistency between tools (e.g.
`git` client) and GitLab.

### Formality

The level of formality used in software varies by language:

| Language | Formality | Example |
| -------- | --------- | ------- |
| French | formal | `vous` for `you` |
| German | informal | `du` for `you` |

You can refer to other translated strings and notes in the glossary to assist
determining a suitable level of formality.

### Inclusive language

[Diversity](https://about.gitlab.com/handbook/values/#diversity) is a GitLab value.
We ask you to avoid translations which exclude people based on their gender or
ethnicity.
In languages which distinguish between a male and female form, use both or
choose a neutral formulation.

<!-- vale gitlab.Spelling = NO -->
For example in German, the word "user" can be translated into "Benutzer" (male) or "Benutzerin" (female).
Therefore "create a new user" would translate into "Benutzer(in) anlegen".
<!-- vale gitlab.Spelling = YES -->

### Updating the glossary

To propose additions to the glossary please
[open an issue](https://gitlab.com/gitlab-org/gitlab/-/issues?scope=all&utf8=✓&state=all&label_name[]=Category%3AInternationalization).

## French Translation Guidelines

### Inclusive language in French

<!-- vale gitlab.Spelling = NO -->
In French, the "écriture inclusive" is now over (see on [Legifrance](https://www.legifrance.gouv.fr/jorf/id/JORFTEXT000036068906/)).
So, to include both genders, write "Utilisateurs et utilisatrices" instead of "Utilisateur·rice·s".
When space is missing, the male gender should be used alone.
<!-- vale gitlab.Spelling = YES -->
