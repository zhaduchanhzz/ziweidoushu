import 'package:dart_iztro/crape_myrtle/tools/strings.dart' as EnumLibString ;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dart_iztro/dart_iztro.dart';
import 'ziwei_chart_view.dart'; // Widget 4x4 bạn đã tạo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo dịch vụ dịch và thêm bản dịch ứng dụng
  IztroTranslationService.init(initialLocale: 'zh_CN');
  IztroTranslationService.addAppTranslations({
    'vi_VN': {
      'app_name': 'Lá số Tử Vi của tôi',
      'calculate': 'Tính lá số',
      'birth_date': 'Ngày sinh',
      'birth_time': 'Giờ sinh',
      'lunar': 'Âm lịch',
      'leap_month': 'Tháng nhuận',
      'gender': 'Giới tính',
      'male': 'Nam',
      'female': 'Nữ',
    },
    'en_US': {
      'app_name': 'My Zi Wei App',
      'calculate': 'Calculate Chart',
      'birth_date': 'Birth Date',
      'birth_time': 'Birth Time',
      'lunar': 'Lunar',
      'leap_month': 'Leap Month',
      'gender': 'Gender',
      'male': 'Male',
      'female': 'Female',
    },
    'zh_CN': {
      'app_name': '我的紫微斗数',
      'calculate': '计算命盘',
      'birth_date': '出生日期',
      'birth_time': '出生时间',
      'lunar': '农历',
      'leap_month': '闰月',
      'gender': '性别',
      'male': '男',
      'female': '女',
    },
  });

  await Future.delayed(const Duration(milliseconds: 200));

  runApp(const TuViApp());
}

class TuViApp extends StatelessWidget {
  const TuViApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'app_name'.tr,
      translations: IztroTranslationService.withAppTranslations(),
      locale: IztroTranslationService.currentLocale,
      fallbackLocale: const Locale('vi', 'VN'),
      home: const ChartInputScreen(),
    );
  }
}

// ==============================
// Màn hình nhập thông tin sinh
// ==============================
class ChartInputScreen extends StatefulWidget {
  const ChartInputScreen({super.key});

  @override
  State<ChartInputScreen> createState() => _ChartInputScreenState();
}

class _ChartInputScreenState extends State<ChartInputScreen> {
  final iztro = DartIztro();

  DateTime birthDate = DateTime(1990, 1, 1);
  TimeOfDay birthTime = const TimeOfDay(hour: 12, minute: 0);

  bool isLunar = false;
  bool isLeap = true;
  String gender = EnumLibString.male;

  Map<String, dynamic>? chartData;

  Future<void> pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => birthDate = d);
  }

  Future<void> pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: birthTime,
    );
    if (t != null) setState(() => birthTime = t);
  }

  Future<void> calculateChart() async {
    try {

      final data = await iztro.calculateChart(
        year: birthDate.year,
        month: birthDate.month,
        day: birthDate.day,
        hour: birthTime.hour,
        minute: birthTime.minute,
        isLunar: isLunar,
        isLeap: isLeap,
        gender: gender,
      );
      setState(() {
        chartData = data;
      });
    } catch (e) {
      print("Lỗi khi tính toán: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Tính toán thất bại: $e")));
    }
  }

  void changeLanguage(String locale) {
    IztroTranslationService.changeLocale(locale);
    setState(() {}); // refresh UI
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        "${birthDate.year}-${birthDate.month}-${birthDate.day}";
    final timeStr =
        "${birthTime.hour}:${birthTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr),
        actions: [
          PopupMenuButton<String>(
            onSelected: changeLanguage,
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'vi_VN', child: Text('Tiếng Việt')),
              const PopupMenuItem(value: 'en_US', child: Text('English')),
              const PopupMenuItem(value: 'zh_CN', child: Text('中文')),
            ],
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(
            title: Text('birth_date'.tr),
            subtitle: Text(dateStr),
            trailing: const Icon(Icons.calendar_month),
            onTap: pickDate,
          ),
          ListTile(
            title: Text('birth_time'.tr),
            subtitle: Text(timeStr),
            trailing: const Icon(Icons.access_time),
            onTap: pickTime,
          ),
          SwitchListTile(
            title: Text('lunar'.tr),
            value: isLunar,
            onChanged: (v) => setState(() => isLunar = v),
          ),
          if (isLunar)
            SwitchListTile(
              title: Text('leap_month'.tr),
              value: isLeap,
              onChanged: (v) => setState(() => isLeap = v),
            ),
          DropdownButtonFormField<String>(
            value: gender,
            decoration: InputDecoration(labelText: 'gender'.tr),
            items: [
              DropdownMenuItem(value: EnumLibString.male, child: Text('male'.tr)),
              DropdownMenuItem(value: EnumLibString.female, child: Text('female'.tr)),
            ],
            onChanged: (v) => setState(() => gender = v!),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: calculateChart,
            child: Text('calculate'.tr),
          ),
          const SizedBox(height: 20),
          if (chartData != null)
            ZiWeiChartView(palaces: chartData!['palaces']),
        ],
      ),
    );
  }
}
