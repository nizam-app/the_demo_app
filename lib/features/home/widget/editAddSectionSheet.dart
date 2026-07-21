import 'dart:io' show File;

import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dashboard_section_widget_size.dart';

const _textPrimary = Color(0xFF111827);
const _textSecondary = Color(0xFF6B7280);
const _danger = Color(0xFFFE019A);
const _blue = Color(0xFF007AFF);

class EditAddSectionSheet extends StatefulWidget {
  const EditAddSectionSheet({
    super.key,
    this.initialSize = kSectionLayoutStorageList,
    this.onSizeChanged,
    this.sectionRenameLabel,
    this.addDeviceCountLabel,
    this.onRenameTap,
    this.onRenameChanged,
    this.onAddDeviceTap,
    this.onHeaderBackgroundTap,
    this.headerBackgroundImagePath,
    this.onMoveUp,
    this.onMoveDown,
    this.canMoveUp = true,
    this.canMoveDown = true,
    this.onRemove,
    this.initialHorizontalScroll,
    this.onHorizontalScrollChanged,
    this.showWidgetSize = true,
    this.onClose,
  });

  final String initialSize;
  final ValueChanged<String>? onSizeChanged;
  final String? sectionRenameLabel;
  final String? addDeviceCountLabel;
  final VoidCallback? onRenameTap;
  final ValueChanged<String>? onRenameChanged;
  final VoidCallback? onAddDeviceTap;
  final VoidCallback? onHeaderBackgroundTap;
  final String? headerBackgroundImagePath;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback? onRemove;
  final bool? initialHorizontalScroll;
  final ValueChanged<bool>? onHorizontalScrollChanged;
  final bool showWidgetSize;
  final VoidCallback? onClose;

  @override
  State<EditAddSectionSheet> createState() => _EditAddSectionSheetState();
}

class _EditAddSectionSheetState extends State<EditAddSectionSheet> {
  late String _selectedSize;
  bool _sliderWidget = true;
  bool _isRenaming = false;
  late final TextEditingController _renameController;
  late final FocusNode _renameFocusNode;

  @override
  void initState() {
    super.initState();
    _selectedSize = canonicalSectionLayoutStorage(widget.initialSize);
    _sliderWidget = widget.initialHorizontalScroll ?? _sliderWidget;
    _renameController = TextEditingController(
      text: widget.sectionRenameLabel ?? 'Light',
    );
    _renameFocusNode = FocusNode();
    _renameFocusNode.addListener(() {
      if (!_renameFocusNode.hasFocus && _isRenaming) {
        _commitRename();
      }
    });
  }

  @override
  void dispose() {
    _renameController.dispose();
    _renameFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EditAddSectionSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSize != widget.initialSize) {
      _selectedSize = canonicalSectionLayoutStorage(widget.initialSize);
    }
    if (!_isRenaming &&
        oldWidget.sectionRenameLabel != widget.sectionRenameLabel) {
      _renameController.text = widget.sectionRenameLabel ?? 'Light';
    }
  }

  void _startRename() {
    if (widget.onRenameChanged == null) {
      widget.onRenameTap?.call();
      return;
    }
    setState(() {
      _isRenaming = true;
      _renameController.text = widget.sectionRenameLabel ?? 'Light';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _renameFocusNode.requestFocus();
      _renameController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _renameController.text.length,
      );
    });
  }

  void _commitRename() {
    if (!_isRenaming) return;
    final String trimmed = _renameController.text.trim();
    if (trimmed.isNotEmpty) {
      widget.onRenameChanged?.call(trimmed);
    } else {
      _renameController.text = widget.sectionRenameLabel ?? 'Light';
    }
    setState(() => _isRenaming = false);
    _renameFocusNode.unfocus();
  }

  Widget _buildRenameRow() {
    final String displayName = widget.sectionRenameLabel ?? 'Light';
    final TextStyle valueStyle = TextStyle(
      color: _textSecondary,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Inter',
    );

    return GestureDetector(
      onTap: _isRenaming ? null : _startRename,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 55.h,
        padding: EdgeInsets.only(left: 12.w, right: 17.w),
        child: Row(
          children: [
            Image.asset(
              'assets/images/rename.png',
              width: 26.w,
              height: 26.h,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 10.w),
            Text(
              'Rename',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
                color: _textPrimary,
              ),
            ),
            SizedBox(width: 8.w),
            if (_isRenaming && widget.onRenameChanged != null)
              Expanded(
                child: TextField(
                  controller: _renameController,
                  focusNode: _renameFocusNode,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  showCursor: true,
                  cursorColor: _blue,
                  cursorWidth: 2,
                  cursorHeight: 18.sp,
                  style: valueStyle,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _commitRename(),
                  onTapOutside: (_) => _commitRename(),
                ),
              )
            else
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: valueStyle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Image.asset(
                      'assets/images/edit_image.png',
                      width: 14.w,
                      height: 13.h,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
//new changes

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.r),
        topRight: Radius.circular(24.r),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top:0.h,
            bottom: 16.h,
          ),
          decoration: BoxDecoration(
            // Keep the sheet clearly transparent like the dashboard header/footer.
            // color: Colors.white.withOpacity(0.28),
            color: Color(0xFFFFFFFF).withOpacity(0.4),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: SafeArea(
            top: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.72,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 14.w,
                        top: 8.h,
                        right: 0.w,
                        bottom: 10.h,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left spacer (same size as close button)
                          SizedBox(width: 30.w, height: 30.w),

                          Expanded(
                            child: Center(
                              child: Text(
                                'Edit Section',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: _textPrimary,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),

                          // Close button (right)
                          Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (widget.onClose != null) {
                                  widget.onClose!();
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                Icons.close_rounded,
                                size: 20.sp,
                                color: _textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// CARD 1
                    SizedBox(height: 10.h),

                    /// CARD 2
                    _Card(
                      child: Column(
                        children: [
                          // _SimpleRow(
                          //   imagePath: 'assets/images/add_device.png',
                          //   title: 'Add device',
                          //   imageWidth: 23.w,
                          //   imageHeight: 23.h,
                          // ),
                          _buildRenameRow(),

                          _SimpleRow(
                            imagePath: 'assets/images/add_device.png',
                            title: 'Add device',
                            imageWidth: 23.w,
                            imageHeight: 23.h,
                            trailingText: widget.addDeviceCountLabel,
                            onTap: widget.onAddDeviceTap,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Card 2
                    _Card(
                      child: Column(
                        children: [
                          _RowItem(
                            imagePath: 'assets/images/header_icon.png',
                            title: 'Header background',
                            imageHeight: 26.h,
                            imageWidth: 26.w,
                            onTap: widget.onHeaderBackgroundTap,
                            trailing: _headerBackgroundPreview(
                              widget.headerBackgroundImagePath,
                            ),
                          ),
                          _SimpleRow(
                            imagePath: 'assets/images/move_up.png',
                            title: 'Move up',
                            imageWidth: 22.w,
                            imageHeight: 22.h,
                            onTap: widget.canMoveUp ? widget.onMoveUp : null,
                            enabled: widget.canMoveUp,
                          ),

                          _SimpleRow(
                            title: 'Move down',
                            imagePath: 'assets/images/move_up.png',
                            imageWidth: 22.w,
                            imageHeight: 22.h,
                            imageQuarterTurns: 2,
                            onTap: widget.canMoveDown
                                ? widget.onMoveDown
                                : null,
                            enabled: widget.canMoveDown,
                          ),

                          _RowItem(
                            imagePath: 'assets/images/Slider.png',
                            title: 'Horizontal scrolling',
                            imageHeight: 22.h,
                            imageWidth: 22.w,
                            trailing: SizedBox(
                              height: 35.h,
                              width: 60.w,
                              child: CupertinoSwitch(
                                value: _sliderWidget,
                                onChanged: (v) {
                                  setState(() => _sliderWidget = v);
                                  widget.onHorizontalScrollChanged?.call(v);
                                },
                                activeColor: _blue,
                              ),
                            ),
                          ),

                          if (widget.showWidgetSize)
                            _RowItem(
                              imagePath: 'assets/images/widget_size.png',
                              title: 'Layout',
                              trailing: DashboardSectionSizeSegment(
                                value: _selectedSize,
                                onChanged: (v) {
                                  setState(() => _selectedSize = v);
                                  widget.onSizeChanged?.call(v);
                                },
                              ),
                            ),
                          if (widget.showWidgetSize) SizedBox(height: 12.h),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h),

                    /// REMOVE
                    GestureDetector(
                      onTap: widget.onRemove,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: double.infinity,
                        height: 49.h,
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(26.r),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/cross.png',
                              width: 26.w,
                              height: 26.h,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Remove',
                              style: TextStyle(
                                color: _danger,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _headerBackgroundPreview(String? imagePath) {
  if (imagePath != null && imagePath.isNotEmpty) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: Image.file(
        File(imagePath),
        height: 39.h,
        width: 39.w,
        fit: BoxFit.cover,
      ),
    );
  }
  return Image.asset(
    'assets/images/header_image.png',
    height: 39.h,
    width: 39.w,
    fit: BoxFit.cover,
  );
}

/// CARD CONTAINER
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: child,
    );
  }
}

/// ROW WITH TRAILING
class _RowItem extends StatelessWidget {
  final String? imagePath;
  final IconData? icon;
  final String title;
  final Widget trailing;
  final double imageWidth;
  final double imageHeight;

  const _RowItem({
    this.imagePath,
    this.icon,
    required this.title,
    required this.trailing,
    this.imageWidth = 20,
    this.imageHeight = 20,
    this.onTap,
  }) : assert(imagePath != null || icon != null, 'Provide imagePath or icon');

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget leading = imagePath != null
        ? Image.asset(
            imagePath!,
            width: imageWidth.w,
            height: imageHeight.h,
            fit: BoxFit.contain,
          )
        : Icon(icon!, size: 20.sp, color: _textSecondary);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 55.h,
        child: Padding(
          padding: EdgeInsets.only(left: 12.w, right: 14.w),
          child: Row(
            children: [
              leading,
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                    color: _textPrimary,
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// SIMPLE ROW
class _SimpleRow extends StatelessWidget {
  final String? imagePath;
  final String? iconPath;
  final IconData? icon;
  final String title;
  final String? trailingText;
  final double imageWidth;
  final double imageHeight;
  final int imageQuarterTurns;
  final double iconWidth;
  final double iconHeight;

  const _SimpleRow({
    this.imagePath,
    this.iconPath,
    this.icon,
    required this.title,
    this.trailingText,
    this.imageWidth = 20,
    this.imageHeight = 20,
    this.imageQuarterTurns = 0,
    this.iconWidth = 14,
    this.iconHeight = 14,
    this.onTap,
    this.enabled = true,
  }) : assert(imagePath != null || icon != null, 'Provide imagePath or icon');

  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final Widget leading = imagePath != null
        ? RotatedBox(
            quarterTurns: imageQuarterTurns,
            child: Image.asset(
              imagePath!,
              width: imageWidth.w,
              height: imageHeight.h,
              fit: BoxFit.contain,
            ),
          )
        : Icon(icon!, size: 20.sp, color: _textSecondary);

    final Color titleColor = enabled ? _textPrimary : _textSecondary;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: Container(
          height: 55.h,
          child: Padding(
            padding: EdgeInsets.only(left: 12.w, right: 17.w),
            child: Row(
              children: [
                leading,
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      color: titleColor,
                    ),
                  ),
                ),
                if (trailingText != null)
                  Row(
                    children: [
                      Text(
                        trailingText!,
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (iconPath != null) ...[
                        SizedBox(width: 5.w),
                        Image.asset(
                          iconPath!,
                          width: iconWidth.w,
                          height: iconHeight.h,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}