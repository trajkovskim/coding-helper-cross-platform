import 'package:coding_helper_cross_platform/src/components/common/list_options.dart';
import 'package:coding_helper_cross_platform/src/components/common/modal.dart';
import 'package:coding_helper_cross_platform/src/i18n/i18n.dart';
import 'package:flutter/material.dart';

enum ViewProfile {
  LIST,
  GRID;
}

class SearchSettingsRow extends StatelessWidget {
  SearchSettingsRow(
      {super.key,
      this.filterOptions,
      this.sortOptions,
      this.handleFilterSubmit,
      this.handleSortSubmit,
      this.handleViewModeChange,
      this.viewMode = ViewProfile.LIST});

  final Map<String, List<String>>? filterOptions;
  final Map<String, List<String>>? sortOptions;
  final Function(List<String>)? handleFilterSubmit;
  final Function(List<String>)? handleSortSubmit;
  final Function(ViewProfile view)? handleViewModeChange;

  ViewProfile viewMode;

  getSearchSettingsButtonStyle() => ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.black.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 2,
      );

  changeViewMode() {
    viewMode = viewMode == ViewProfile.LIST ? ViewProfile.GRID : ViewProfile.LIST;
    return viewMode;
  }

  @override
  Widget build(BuildContext context) {
    final tListOptions = getTranslation(context, 'listOptions');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if(filterOptions != null && handleFilterSubmit != null) Expanded(
          child: ElevatedButton.icon(
            onPressed: () => createFilterModal(context, handleFilterSubmit!, filterOptions!),
            icon: const Icon(Icons.filter_alt),
            label: Text(tListOptions('filters'),
                style: const TextStyle(fontWeight: FontWeight.bold),
                softWrap: false,
                overflow: TextOverflow.ellipsis),
            style: getSearchSettingsButtonStyle(),
          ),
        ),
        if(sortOptions != null && handleSortSubmit != null) Expanded(
          child: ElevatedButton.icon(
            onPressed: () => createSortModal(context, handleSortSubmit!, sortOptions!),
            icon: const Icon(Icons.sort),
            label: Text(tListOptions('sort'),
                style: const TextStyle(fontWeight: FontWeight.bold),
                softWrap: false,
                overflow: TextOverflow.ellipsis),
            style: getSearchSettingsButtonStyle(),
          ),
        ),
        if (handleViewModeChange != null) Expanded(
          child: ElevatedButton.icon(
            onPressed: () => handleViewModeChange!(changeViewMode()),
            icon: const Icon(Icons.settings),
            label: Text(tListOptions('view'),
                style: const TextStyle(fontWeight: FontWeight.bold),
                softWrap: false,
                overflow: TextOverflow.ellipsis),
            style: getSearchSettingsButtonStyle(),
          ),
        ),
      ],
    );
  }
}

createFilterModal(
    BuildContext context, Function(List<String>) handleSubmit, Map<String, List<String>> options) async {
  final t = getTranslation(context, 'modal');
  createBottomModal(
    context,
    options,
    t('filter'),
    (values) {
      final commands = values.entries
          .map((entry) =>
              createCommand(Command.FILTER, '${entry.key}: ${entry.value}'))
          .toList();
      handleSubmit(commands);
    },
  );
}

createSortModal(
    BuildContext context, Function(List<String>) handleSubmit, Map<String, List<String>> options) async {
  final t = getTranslation(context, 'modal');
  createBottomModal(
    context,
    options,
    t('sort'),
    (values) {
      final commands = values.entries
          .map((entry) =>
              createCommand(Command.SORT, '${entry.key}: ${entry.value}'))
          .toList();
      handleSubmit(commands);
    },
  );
}

createBottomModal(BuildContext context, Map<String, List<String>> options,
    String submitText, Function(Map<String, String?>) handleSubmit) async {
  final t = getTranslation(context, 'modal');

  final Map<String, String?>? values = await showModalBottomSheet(
    context: context,
    builder: (context) => Modal(
      options: options,
      submitButton: submitText,
    ),
  );

  if (values != null) {
    handleSubmit(values);
  }
}

Map<String, String> transformFilterOptionsListToMap(List<String> options) {
  return options.asMap().map((index, element) {
    final parts = element.split(':');
    return MapEntry(parts[0].trim().toLowerCase(), parts[1].trim());
  });
}

List<String> transformSortOptions(List<String> options) {
  return options.map((element) {
    final parts = element.split(':');
    final value = parts[1].trim().toLowerCase();
    return '${parts[0].trim().toLowerCase()}=${value == 'ascending' ? 'asc' : 'desc'}';
  }).toList();
}
