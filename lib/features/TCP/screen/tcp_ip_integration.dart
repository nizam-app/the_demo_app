import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workpleis/features/TCP/widget/add_expose_devices.dart';

/// -------------------- Models --------------------
class ExposedDevice {
  final String name;
  final String code; // SENS-....
  final String tag; // ID..1
  final String image; // your image path
  final Color iconTint; // keeps same color feel

  const ExposedDevice({
    required this.name,
    required this.code,
    required this.tag,
    required this.image,
    required this.iconTint,
  });
}

/// -------------------- Controller (ChangeNotifier) --------------------
class TcpIpIntegrationController extends ChangeNotifier {
  bool autoSend = true;
  bool header = true;

  int interfaceId = 1;
  int tcpPort = 10000;

  final List<ExposedDevice> devices = const [
    ExposedDevice(
      name: 'Salon down',
      code: 'SENS-4B37-3419-363A-PB1',
      tag: 'ID..1',
      image: 'assets/images/brightness_sensor.png',
      iconTint: Color(0xFF00C853),
    ),
    ExposedDevice(
      name: 'Salon up',
      code: 'SENS-4B37-3419-363A-PB2',
      tag: 'ID..2',
      image: 'assets/images/sensor.png',
      iconTint: Color(0xFFFFB300),
    ),
    ExposedDevice(
      name: 'Kitchen up',
      code: 'SENS-4B37-3419-363A-PB3',
      tag: 'ID..3',
      image: 'assets/images/lock.png',
      iconTint: Color(0xFF7C4DFF),
    ),
    ExposedDevice(
      name: 'Kitchen down',
      code: 'SENS-4B37-3419-363A-PB4',
      tag: 'ID..1',
      image: 'assets/images/fan.png',
      iconTint: Color(0xFF00B0FF),
    ),
  ];

  void toggleAutoSend() {
    autoSend = !autoSend;
    notifyListeners();
  }

  void toggleHeader() {
    header = !header;
    notifyListeners();
  }

  void setInterfaceId(int v) {
    interfaceId = v;
    notifyListeners();
  }

  void setTcpPort(int v) {
    tcpPort = v;
    notifyListeners();
  }

  void addDevice() {
    // demo action
    notifyListeners();
  }
}

/// -------------------- Asset icon helper (replace with your assets) --------------------
class AppAssetIcon extends StatelessWidget {
  const AppAssetIcon(
      this.asset, {
        super.key,
        required this.size,
        this.color,
      });

  final String asset;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: size.w,
      height: size.w,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: color == null ? null : BlendMode.srcIn,
    );
  }
}

/// -------------------- Screen --------------------
class TcpIpIntegrationScreen extends StatefulWidget {
  const TcpIpIntegrationScreen({super.key});

  static const routeName = "/tcpIpIntegrationScreen";

  @override
  State<TcpIpIntegrationScreen> createState() => _TcpIpIntegrationScreenState();
}

class _TcpIpIntegrationScreenState extends State<TcpIpIntegrationScreen> {
  late final TcpIpIntegrationController controller;

  // Colors (match your design language)
  static const Color _bg = Color(0xFFF3F4F6);
  static const Color _card = Colors.white;
  static const Color _textDark = Color(0xFF111827);
  static const Color _textGrey = Color(0xFF6B7280);
  static const Color _divider = Color(0xFFE5E7EB);
  static const Color _blue = Color(0xFF0088FE);
  static const Color _pillGrey = Color(0xFFF1F3F6);

  @override
  void initState() {
    super.initState();
    controller = TcpIpIntegrationController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _openMenu() {
    // your menu action
  }
  bool _sliderWidget = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,

      floatingActionButton: _RoundFab(
        onTap: () => showAddExposeDeviceBottomSheet(context),
        child: Icon(Icons.add, size: 30.sp, color: _textDark),
      ),

      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return ListView(
              padding: EdgeInsets.fromLTRB(18.w, 20.h, 14.w, 120.h),
              children: [
                _TopBar(
                  title: 'TCP/IP Integration',
                  onBack: () => Navigator.maybePop(context),
                  onMenu: _openMenu,
                ),
                SizedBox(height: 24.h),

                Text(
                  'Inputs',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
                SizedBox(height: 8.h),

                _CardContainer(
                  child: Column(
                    children: [
                      _SettingsRow(
                        title: 'Interface ID',
                        rightText: '${controller.interfaceId}',
                        showChevron: true,
                        onTap: () {
                          // demo: cycle 1..3
                          final next = controller.interfaceId == 3 ? 1 : controller.interfaceId + 1;
                          controller.setInterfaceId(next);
                        },
                      ),
                      const _Line(),
                      _SettingsRow(
                        title: 'Auto send (Push All)',
                        trailing: CupertinoSwitch(
                          value: _sliderWidget,
                          onChanged: (v) => setState(() => _sliderWidget = v),
                          activeColor: _blue,
                        ),
                      ),
                      const _Line(),
                      _SettingsRow(
                        title: 'Header',
                        trailing: CupertinoSwitch(
                          value: _sliderWidget,
                          onChanged: (v) => setState(() => _sliderWidget = v),
                          activeColor: _blue,
                        ),
                      ),
                      const _Line(),
                      _SettingsRow(
                        title: 'TCP Port',
                        rightText: '${controller.tcpPort}',
                        showChevron: true,
                        onTap: () {
                          // demo change
                          controller.setTcpPort(controller.tcpPort == 10000 ? 10001 : 10000);
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 22.h),

                Text(
                  'Expose devices',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
                SizedBox(height: 8.h),

                _CardContainer(
                  child: Column(
                    children: [
                      for (int i = 0; i < controller.devices.length; i++) ...[
                        _ExposeDeviceRow(device: controller.devices[i]),
                        if (i != controller.devices.length - 1) const _Line(),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// -------------------- Widgets --------------------
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.onBack,
    required this.onMenu,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onMenu;

  static const Color _textDark = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(26.r),
          onTap: onBack,
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Center(
              child: Image.asset( "assets/aro.png", color: _textDark, height: 16.h, width: 16.w,),
              //child: Icon(Icons.chevron_left_rounded, size: 22.sp, color: _textDark),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(26.r),
          onTap: onMenu,
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Center(
              child: Icon(Icons.more_horiz_rounded, size: 22.sp, color: _textDark),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardContainer extends StatelessWidget {
  const _CardContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26.r),
        child: child,
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.title,
    this.rightText,
    this.trailing,
    this.showChevron = false,
    this.onTap,
  });

  final String title;
  final String? rightText;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onTap;

  static const Color _textDark = Color(0xFF111827);
  static const Color _textGrey = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.only(top: 15.h, right: 14.w, left: 18.w, bottom: 15.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: _textDark,
              ),
            ),
          ),
          if (rightText != null) ...[
            Text(
              rightText!,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: _textGrey,
              ),
            ),
            //SizedBox(width: 8.w),
          ],
          if (trailing != null) trailing!,
          if (showChevron) ...[
            SizedBox(width: 10.w),
            Image.asset("assets/Mask group copy 4.png", height: 13.h, width: 13.w,fit: BoxFit.cover,)

          ],
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      onTap: onTap,
      child: content,
    );
  }
}

class _ExposeDeviceRow extends StatelessWidget {
  const _ExposeDeviceRow({required this.device});
  final ExposedDevice device;

  static const Color _textDark = Color(0xFF111827);
  static const Color _textGrey = Color(0xFF6B7280);
  static const Color _pillGrey = Color(0xFFF1F3F6);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(top: 15.h, right: 14.w, left: 18.w, bottom: 15.h),
        child: Row(
          children: [
            // left icon
            Container(
              width: 30.w,
              height: 30.w,
              alignment: Alignment.center,
              child: AppAssetIcon(
                device.image,
                size: 30,
                color: device.iconTint,
              ),
            ),
            SizedBox(width: 12.w),
            // name + code
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: _textDark,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    device.code,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: _textGrey,
                    ),
                  ),
                ],
              ),
            ),
            // tag pill
            Container(
              height: 26.h,
              width: 52.w,
              // padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _pillGrey,
                borderRadius: BorderRadius.circular(26.r),
              ),
              child: Text(
                device.tag,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: _textDark,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Image.asset("assets/Mask group copy 4.png", height: 13.h, width: 13.w,fit: BoxFit.cover,)
            //Icon(Icons.chevron_right_rounded, size: 26.sp, color: _textGrey),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 14.w, left: 18.w,),
      child: Divider(
        height: 1.h,
         thickness: 1.h,
        color: const Color(0xFFE5E7EB),
      ),
    );
  }
}

/// iOS-like toggle (no setState; controller drives updates)
class _IosToggle extends StatelessWidget {
  const _IosToggle({
    required this.value,
    required this.onTap,
  });

  final bool value;
  final VoidCallback onTap;

  static const Color _blue = Color(0xFF0088FE);
  static const Color _off = Color(0xFFE1E1E1);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.05,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 60.w,
          height: 35.h,
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: value ? _blue : _off,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 31.w,
              height: 31.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundFab extends StatelessWidget {
  const _RoundFab({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26.r),
        child: Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24.r,
                offset: Offset(0, 12.h),
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}