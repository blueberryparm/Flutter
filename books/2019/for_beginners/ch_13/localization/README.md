# localization

## Generating .arb files with intl_translation
### flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/app_localization.dart
## This command will generate a file called the intl_messages.arb file in lib/i10n, and this file serves as a template for our translations
## We can create the desired translations based on this file by copying it, renaming it intl_<language_code> files, and translating the required resources

## The process is the inverse of generating .arb files
### flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n lib/app_localization.dart lib/l10n/intl_en.arb lib/l10n/intl_es.arb lib/l10n/intl_it.arb
## Now we have the generated Dart code containing the translated resources.

