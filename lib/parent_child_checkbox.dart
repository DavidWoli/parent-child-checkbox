import 'package:flutter/material.dart';

///Main widget of Parent Child Checkbox.
///Parent Child Checkbox is a type of checkbox where we can establish hierarchy in Checkboxes.
class ParentChildCheckbox extends StatefulWidget {
  ///Text Widget to specify the Parent checkbox
  final Text? parent;

  ///List<Text> Widgets to specify the Children checkboxes
  final List<Text>? children;

  ///Color of Parent CheckBox
  ///
  /// By default the value of [CheckboxThemeData.fillColor]
  /// is used. If that is also null, then [ThemeData.disabledColor] is used in
  /// the disabled state, [ColorScheme.secondary] is used in the
  /// selected state, and [ThemeData.unselectedWidgetColor] is used in the
  /// default state.
  final Color? parentCheckboxColor;

  ///Color of Parent CheckBox
  ///
  /// By default the value of [CheckboxThemeData.fillColor]
  /// is used. If that is also null, then [ThemeData.disabledColor] is used in
  /// the disabled state, [ColorScheme.secondary] is used in the
  /// selected state, and [ThemeData.unselectedWidgetColor] is used in the
  /// default state.
  final Color? childrenCheckboxColor;

  ///Scale of the Parent CheckBox
  ///
  /// Defaults to [1.0]
  final double? parentCheckboxScale;

  ///Scale of the Children CheckBox
  ///
  /// Defaults to [1.0]
  final double? childrenCheckboxScale;

  ///Gap between the Parent and Children CheckBox
  ///
  /// Defaults to [10.0]
  final double? gap;

  ///Function that will be executed if a child will be selected
  ///
  final void Function(int index)? onCheckedChild;

  ///Function that will be executed if the parent will be selected
  ///
  final void Function()? onCheckedParent;

  ///Default constructor of ParentChildCheckbox
  ParentChildCheckbox({
    required this.parent,
    required this.children,
    this.parentCheckboxColor,
    this.childrenCheckboxColor,
    this.parentCheckboxScale,
    this.childrenCheckboxScale,
    this.gap,
    this.onCheckedChild,
    this.onCheckedParent,
  });

  /// Map which shows whether particular parent is selected or not.
  ///
  /// Example: {'Parent 1' : true, 'Parent 2' : false} where
  /// Parent 1 and Parent 2 will be 2 separate parents if you are using multiple ParentChildCheckbox in your code.
  ///
  /// Default value will be false for all specified parents
  static Map<String?, bool?> _isParentSelected = {};

  /// Getter to get whether particular parent is selected or not.
  ///
  /// Example: {'Parent 1' : true, 'Parent 2' : false} where
  /// Parent 1 and Parent 2 will be 2 separate parents if you are using multiple ParentChildCheckbox in your code.
  ///
  /// Default value will be false for all specified parents
  static get isParentSelected => _isParentSelected;

  /// Map which shows which childrens are selected for a particular parent.
  ///
  /// Example: {'Parent 1' : ['Children 1.1','Children 1.2'], 'Parent 2' : []} where
  /// Parent 1 and Parent 2 will be 2 separate parents if you are using multiple ParentChildCheckbox in your code.
  ///
  /// Default value is {'Parent 1' : [], 'Parent 2' : []}
  static Map<String?, List<String?>> _selectedChildrenMap = {};

  /// Getter to get which childrens are selected for a particular parent.
  ///
  /// Example: {'Parent 1' : ['Children 1.1','Children 1.2'], 'Parent 2' : []} where
  /// Parent 1 and Parent 2 will be 2 separate parents if you are using multiple ParentChildCheckbox in your code.
  ///
  /// Default value is {'Parent 1' : [], 'Parent 2' : []}
  static get selectedChildrens => _selectedChildrenMap;

  @override
  _ParentChildCheckboxState createState() => _ParentChildCheckboxState();
}

class _ParentChildCheckboxState extends State<ParentChildCheckbox> {
  ///Default parentValue set to false
  bool? _parentValue = false;

  ///List of childrenValue which depicts whether checkbox is clicked or not
  List<bool?> _childrenValue = [];

  @override
  void initState() {
    super.initState();
    _childrenValue = List.filled(widget.children!.length, false);
    ParentChildCheckbox._selectedChildrenMap.addAll({widget.parent!.data: []});
    ParentChildCheckbox._isParentSelected.addAll({widget.parent!.data: false});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Transform.scale(
              scale: widget.parentCheckboxScale ?? 1.0,
              child: Checkbox(
                value: _parentValue,
                splashRadius: 0.0,
                activeColor: widget.parentCheckboxColor,
                onChanged: (value) => _parentCheckBoxClick(),
                tristate: true,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            widget.parent!,
          ],
        ),
        SizedBox(
          height: widget.gap ?? 10.0,
        ),
        for (int i = 0; i < widget.children!.length; i++)
          Padding(
            padding: EdgeInsets.only(left: 25.0),
            child: Row(
              children: [
                Transform.scale(
                  scale: widget.childrenCheckboxScale ?? 1.0,
                  child: Checkbox(
                    splashRadius: 0.0,
                    activeColor: widget.childrenCheckboxColor,
                    value: _childrenValue[i],
                    onChanged: (value) => _childCheckBoxClick(i),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                widget.children![i],
              ],
            ),
          ),
      ],
    );
  }

  ///onClick method when particular children of index i is clicked
  void _childCheckBoxClick(int i) {
    final Function(int index)? onCheckedChild = widget.onCheckedChild;
    if (onCheckedChild != null) {
      onCheckedChild(i);
    }
    setState(() {
      _childrenValue[i] = !_childrenValue[i]!;
      if (!_childrenValue[i]!) {
        ParentChildCheckbox._selectedChildrenMap.update(widget.parent!.data,
            (value) {
          value.removeWhere((element) => element == widget.children![i].data);
          return value;
        });
      } else {
        ParentChildCheckbox._selectedChildrenMap.update(widget.parent!.data,
            (value) {
          value.add(widget.children![i].data);
          return value;
        });
      }
      _parentCheckboxUpdate();
    });
  }

  ///onClick method when particular parent is clicked
  void _parentCheckBoxClick() {
    final Function()? onCheckedParent = widget.onCheckedParent;
    if (onCheckedParent != null) {
      onCheckedParent();
    }
    setState(() {
      if (_parentValue != null) {
        _parentValue = !_parentValue!;
        ParentChildCheckbox._isParentSelected
            .update(widget.parent!.data, (value) => _parentValue);
        ParentChildCheckbox._selectedChildrenMap.addAll({
          widget.parent!.data: [],
        });
        for (int i = 0; i < widget.children!.length; i++) {
          _childrenValue[i] = _parentValue;
          if (_parentValue!) {
            ParentChildCheckbox._selectedChildrenMap.update(widget.parent!.data,
                (value) {
              value.add(widget.children![i].data);
              return value;
            });
          }
        }
      } else {
        _parentValue = false;
        ParentChildCheckbox._isParentSelected
            .update(widget.parent!.data, (value) => _parentValue);
        ParentChildCheckbox._selectedChildrenMap
            .update(widget.parent!.data, (value) => []);
        for (int i = 0; i < widget.children!.length; i++)
          _childrenValue[i] = false;
      }
    });
  }

  ///Method to update the Parent Checkbox based on the status of Child checkbox
  void _parentCheckboxUpdate() {
    setState(() {
      if (_childrenValue.contains(false) && _childrenValue.contains(true)) {
        _parentValue = null;
        ParentChildCheckbox._isParentSelected
            .update(widget.parent!.data, (value) => false);
      } else {
        _parentValue = _childrenValue.first;
        ParentChildCheckbox._isParentSelected
            .update(widget.parent!.data, (value) => _childrenValue.first);
      }
    });
  }
}
