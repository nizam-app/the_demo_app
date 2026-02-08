import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/core/widget/global_back_button.dart';

class CoresScreen extends StatefulWidget {
  const CoresScreen({super.key});

  static const String routeName = '/cores';

  @override
  State<CoresScreen> createState() => _CoresScreenState();
}

class _CoresScreenState extends State<CoresScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String? _selectedCoreId = 'aican_demo';

  static const _bg = Color(0xFFF3F4F6);
  static const _cardBg = Color(0xFFFFFFFF);
  static const _primary = Color(0xFF111827);
  static const _secondary = Color(0xFF6B7280);
  static const _searchBorder = Color(0xFF61A3FF);
  static const _selectedBg = Color(0xFFE8F0FF);
  static const _pillBg = Color(0xFFE5E7EB);
  static const _pillText = Color(0xFF6B7280);
  static const _atomIcon = Color(0xFF4FC3F7);
  static const _fabIcon = Color(0xFF0088FE);
  static const _checkGreen = Color(0xFF10B981);

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 100.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  //  SizedBox(height: 10.h),
                    _buildSearchBar(),
                    SizedBox(height: 16.h),
                    _buildSectionTitle('Local access'),
                    SizedBox(height: 12.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26.r),
                          color: Colors.white,
                        ),
                        child: _buildCoreCard(
                          id: 'node24',
                          name: 'Node 24',
                          pillText: '*KX5Z',
                          timeText: 'Today 12:25',
                          isSelected: _selectedCoreId == 'node24',
                          onTap: () => setState(() => _selectedCoreId = 'node24'),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildSectionTitle('Remote access'),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26.r),
                          color: Colors.white
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCoreCard(
                              id: 'rd_suta',
                              name: 'RD Suta',
                              pillText: '*KX5Z',
                              timeText: 'Yesterday 13:26',
                              isSelected: _selectedCoreId == 'rd_suta',
                              onTap: () => setState(() => _selectedCoreId = 'rd_suta'),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(26.r),
                                topRight: Radius.circular(26.r),
                              ),
                            ),
                          _InnerDivider(),
                    
                            _buildCoreCard(
                              id: 'aican_demo',
                              name: 'Aican Demo Account',
                              pillText: '*KX5Z',
                              timeText: 'Before 10 days',
                              isSelected: _selectedCoreId == 'aican_demo',
                              showCheckmark: true,
                              onTap: () =>
                                  setState(() => _selectedCoreId = 'aican_demo'),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(26.r),
                                bottomRight: Radius.circular(26.r),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: Row(
        children: [
          GlobalCircleIconBtn(
            child: Image.asset(
              'assets/aro.png',
              width: 16.w,
              height: 16.h,
            ),
            onTap: () => Navigator.maybePop(context),
            // color: Color(0xFFF3F4F6),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Cores',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: _primary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          SizedBox(width: 36.w),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return ListenableBuilder(
      listenable: _searchFocusNode,
      builder: (context, _) {
        final hasFocus = _searchFocusNode.hasFocus;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Container(
            padding: EdgeInsets.all(hasFocus ? 1.5.w : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26.r),
              gradient: hasFocus
                  ? const LinearGradient(
                      colors: [Color(0xFF0088FE), Color(0xFF00D1FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: 46.h,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(hasFocus ? 22.r : 26.r),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontSize: 16.sp,
                      color: Color(0xFF6B7280), // 0xFF6B7280 - visible on white0xFF6B7280
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                    filled: false,
                    prefixIcon: Image.asset(
                      'assets/images/Mask group.png',
                      width: 22.w,
                      height: 22.w,
                      fit: BoxFit.contain,
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 24.h,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 0,
                    ),
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                    color: _primary,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: _primary,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildCoreCard({
    required String id,
    required String name,
    required String pillText,
    required String timeText,
    required bool isSelected,
    bool showCheckmark = false,
    required VoidCallback onTap,
    BorderRadius? borderRadius,
  }) {
    final radius = borderRadius ?? BorderRadius.circular(26.r);
    return Material(
      color: isSelected ? _selectedBg : _cardBg,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              _buildAtomIcon(showCheckmark: showCheckmark),
              SizedBox(width: 12.w),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: _primary,
                          fontFamily: 'Inter',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 60.w,
                      height: 23.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFFDAE0E8),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      child: Text(
                        pillText,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                  timeText,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: _secondary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 14.h),
                  if (isSelected)
                    Icon(
                      Icons.check,
                      size: 26.sp,
                      color:_fabIcon,
                    )
                  else
                    SizedBox(height: 22.sp),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAtomIcon({bool showCheckmark = false}) {
    return SizedBox(
      width: 40.w,
      height: 40.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
           Center(child: Image.asset("assets/images/rd_suta.png", height: 20.h, width: 20.w,)),
          if (showCheckmark)
            Positioned(
              right: 6.w,
              bottom: 6.h,
              child: Container(
                width: 12.w,
                height: 12.h,
                decoration: const BoxDecoration(
                  color: _checkGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
         shape: BoxShape.circle,
        //borderRadius: BorderRadius.all(Radius.circular(100)),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.08),
        //     blurRadius: 12,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Material(
        color: _cardBg,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () {
            // Add new core
          },
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 46.w,
            height: 46.h,
            child: Icon(
              Icons.add_rounded,
              size: 30.sp,
              color: _fabIcon,
            ),
          ),
        ),
      ),
    );
  }
}



class _InnerDivider extends StatelessWidget {
  const _InnerDivider();

  @override
  Widget build(BuildContext context) {
    // Icon size (40) + gap (12) + left padding (14)
    final left = 40.w + 12.w + 14.w;
    return Container(
      height: 1.h,
      margin: EdgeInsets.only(left: left, ),
      color: const Color(0xFFE5E7EB),
    );
  }
}