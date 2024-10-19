import 'dart:convert';

import 'package:advanced_chips_input/advanced_chips_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tables_maker/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'فطّين',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2ecec2)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'فطين'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'فطّين',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'مرحبا بكم في تطبيق فطّين لإعداد الجداول الجامعية',
                style: TextStyle(fontSize: 20),
              ),
              // start
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetupPage(),
                    ),
                  );
                },
                child: const Text(
                  'إعداد جدول',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                  "صنع من قبل أحد الطلبة الكفو\n في كلية الحاسب دفعة 224")
            ],
          ),
        ));
  }
}

enum Gender { male, female }

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  Gender _gender = Gender.male;
  final List<String> _selectedCodes = [];
  String _college = '';

  var codesTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إعدادات'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("الكلية"),
                ListTile(
                  title: DropdownButtonFormField(
                    value: _college,
                    items: const [
                      DropdownMenuItem(
                        alignment: Alignment.center,
                        value: '',
                        enabled: false,
                        child: Text('اختر الكلية',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      DropdownMenuItem(
                        alignment: Alignment.centerRight,
                        value: 'CCSIT',
                        child: Text('كلية علوم الحاسب وتقنية المعلومات'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _college = value.toString();
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // radio buttons
                const Text("الجنس"),
                RadioListTile<Gender>(
                    title: const Text("ذكر"),
                    value: Gender.male,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    }),
                RadioListTile<Gender>(
                    title: const Text("انثى"),
                    value: Gender.female,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    }),
                const SizedBox(height: 20),
                // dropdown
                // show all codes with checkboxes
                const Text("الأرقام المرجعية للمواد"),
                AdvancedChipsInput(
                  controller: codesTextEditingController,
                  onSubmitted: (String value) {
                    if (kDebugMode) {
                      print('Submitted: $value');
                    }
                    _selectedCodes.clear();
                    _selectedCodes.addAll(value.trim().split(' '));
                  },
                  separatorCharacter: ' ',
                  deleteIcon: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.cancel,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  validateInputMethod: (String value) {
                    if (value.isEmpty) {
                      return 'الرجاء إدخال رقم مرجعي';
                    }
                    return null;
                  },
                  placeChipsSectionAbove: true,
                  widgetContainerDecoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  chipContainerDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),
                  chipTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                  onChipDeleted: (chipText, index) {
                    if (kDebugMode) {
                      print('Deleted chip: $chipText at index $index');
                    }
                  },
                ),
                const Text(
                    "*: احرص ان تكون بالإحدى الصيغ التالية: ###-#### أو #######"),
                const SizedBox(height: 20),

                FilledButton(
                    onPressed: () {
                      print(_selectedCodes);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TablesViewPage(
                              college: _college,
                              gender: _gender,
                              codes: _selectedCodes),
                        ),
                      );
                    },
                    child: const Text("التالي")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TablesViewPage extends StatefulWidget {
  const TablesViewPage(
      {super.key,
      required this.college,
      required this.gender,
      required this.codes});

  final String college;
  final Gender gender;
  final List<String> codes;

  @override
  State<TablesViewPage> createState() => _TablesViewPageState();
}

class _TablesViewPageState extends State<TablesViewPage> {
  List<Course> _allCoursesData = [];

  // check widget.codes if (it look #######) then make it ####-###
  List<String> enteredCodes = [];
  List<List<Course>> tables = [];

  List<String> modifyCodes(List<String> codes) {
    var newCodes = <String>[];
    for (var code in codes) {
      if (code.length == 7) {
        newCodes.add("${code.substring(0, 4)}-${code.substring(4)}");
      } else {
        newCodes.add(code);
      }
    }
    return newCodes.toSet().toList();
  }

  List<Course> eligibleCourses = [];
  List<String> instructorsOfEligibleCourses = [];
  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString(
        widget.gender == Gender.male ? 'ccsit_male.json' : 'ccsit_female.json');
    final data = await json.decode(response);
    setState(() {
      enteredCodes = modifyCodes(widget.codes);

      _allCoursesData = List<Course>.from(data.map((x) => Course.fromJson(x)));

      for (var course in _allCoursesData) {
        if (enteredCodes.contains(course.code)) {
          if (course.instructor.isNotEmpty && course.status != "غير متاحه") {
            eligibleCourses.add(course);
          }
        }
      }
      print("Done");
      print("eligible Courses: $eligibleCourses");
      visiableCourses = eligibleCourses;
      instructorsOfEligibleCourses =
          eligibleCourses.map((course) => course.instructor).toSet().toList();
      instructorsVisiablity = {
        for (var instructor in instructorsOfEligibleCourses) instructor: true
      };
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the readJson method when the app starts
    readJson();
  }

  List<Course> visiableCourses = [];

  // make a map of instructors and visiablity to make a checkbox list
  // when the user select an instructor, the list of courses will be updated

  Map<String, bool> instructorsVisiablity = {};

  List<Schedule> generateSchedules(
      List<String> codes, List<String> instructors, List<String> offDays) {
    List<Schedule> schedules = [];
    return schedules;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الجداول'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // just show the data
            Text("${widget.college} - ${widget.gender}"),

            Text(enteredCodes.toString()),

            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface, width: 2),
                ),
                height: 400,
                width: 300,
                child: ListView.builder(
                  // a list of instructors with chips
                  itemCount: instructorsOfEligibleCourses.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(instructorsOfEligibleCourses[index]),
                      value: instructorsVisiablity[
                          instructorsOfEligibleCourses[index]], // true or false
                      onChanged: (value) {
                        setState(() {
                          instructorsVisiablity[
                              instructorsOfEligibleCourses[index]] = value!;
                          visiableCourses = eligibleCourses
                              .where((course) =>
                                  instructorsVisiablity[course.instructor]!)
                              .toList();
                        });
                      },
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                  onPressed: () {
                    List<Schedule> schedules = [];

                    for (var course in visiableCourses
                        .where((course) => course.type == "نظري")) {
                      List<Lecture> lectures = [];
                      if (course.type == "نظري") {
                        var practicalCourse = visiableCourses
                            .where(
                              (element) =>
                                  element.type == "عملي" &&
                                  element.code == course.code &&
                                  element.section ==
                                      "${int.parse(course.section) + 40}",
                            )
                            .toList()
                            .firstOrNull;
                        if (practicalCourse != null) {
                          for (var day in practicalCourse.days.split("")) {
                            var times = correctTime(practicalCourse.time);
                            if (day.trim().isNotEmpty) {
                              lectures.add(Lecture(practicalCourse.course,
                                  crn: practicalCourse.crn,
                                  section: practicalCourse.section,
                                  type: practicalCourse.type,
                                  code: practicalCourse.code,
                                  day: day,
                                  instructor: practicalCourse.instructor,
                                  startTime: times[0],
                                  endTime: times[1]));
                            }
                          }
                        }
                      }
                      // add the theoretical course
                      for (var day in course.days.split("")) {
                        var times = correctTime(course.time);
                        if (day.trim().isNotEmpty) {
                          lectures.add(Lecture(course.course,
                              crn: course.crn,
                              section: course.section,
                              type: course.type,
                              code: course.code,
                              day: day,
                              instructor: course.instructor,
                              startTime: times[0],
                              endTime: times[1]));
                        }
                      }

                      schedules.add(Schedule(
                          codes: lectures.map((e) => e.code).toSet().toList(),
                          sundayLectures: lectures
                              .where((element) => element.day == "ح")
                              .toList(),
                          mondayLectures: lectures
                              .where((element) => element.day == "ن")
                              .toList(),
                          tuesdayLectures: lectures
                              .where((element) => element.day == "ث")
                              .toList(),
                          wednesdayLectures: lectures
                              .where((element) => element.day == "ر")
                              .toList(),
                          thursdayLectures: lectures
                              .where((element) => element.day == "خ")
                              .toList(),
                          CRNs: visiableCourses.map((e) => e.crn).toList()));
                    }

                    // merge the schedules

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      var generatedSchedules =
                          combineSchedulesWithoutConflicts(schedules);
                      return Scaffold(
                          appBar: AppBar(),
                          body: ListView.builder(
                              itemCount: generatedSchedules.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    Text("الجدول رقم ${index + 1}"),
                                    cardOfSchedule(generatedSchedules[index])
                                  ]),
                                );
                              }));
                    }));
                  },
                  child: const Text("عرض الجداول")),
            )
          ],
        ),
      ),
    );
  }
}

Widget cardOfSchedule(Schedule schedule) {
  return Card(
    child: Column(
      children: [
        // each day
        const Text("الأحد"),
        for (var lecture in schedule.sundayLectures) LectureListTile(lecture),
        const Text("الاثنين"),
        for (var lecture in schedule.mondayLectures) LectureListTile(lecture),
        const Text("الثلاثاء"),
        for (var lecture in schedule.tuesdayLectures) LectureListTile(lecture),
        const Text("الأربعاء"),
        // show the lectures of the day but no duplicate codes and types in the same day

        for (var lecture in schedule.wednesdayLectures)
          LectureListTile(lecture),
        const Text("الخميس"),
        for (var lecture in schedule.thursdayLectures) LectureListTile(lecture)
      ],
    ),
  );
}

class LectureListTile extends StatelessWidget {
  const LectureListTile(
    this.lecture, {
    super.key,
  });

  final Lecture lecture;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(lecture.course),
      subtitle: Text(lecture.instructor),
      trailing: Text("${lecture.startTime} - ${lecture.endTime}"),
      leading: Chip(
        label: Text("${lecture.type} (${lecture.section})"),
      ),
    );
  }
}

List<String> correctTime(time) {
  var startTime = time.split('-')[0].trim();
  startTime = "${startTime.substring(0, 2)}:${startTime.substring(2)}".trim();
  // startTime is now (hhmm) to (hh:mm)

  var endTime = time.split('-')[1].trim();
  endTime = "${endTime.substring(0, 2)}:${endTime.substring(2)}".trim();
  return [startTime, endTime];
}

class Schedule {
  List<Lecture> sundayLectures = [];
  List<Lecture> mondayLectures = [];
  List<Lecture> tuesdayLectures = [];
  List<Lecture> wednesdayLectures = [];
  List<Lecture> thursdayLectures = [];

  List<String> CRNs = [];

  List<String> codes = [];

  Schedule(
      {required this.sundayLectures,
      required this.mondayLectures,
      required this.tuesdayLectures,
      required this.wednesdayLectures,
      required this.thursdayLectures,
      required this.codes,
      required this.CRNs});
}

class Lecture {
  String course;
  String crn;
  String code;
  String section;
  String day;
  String instructor;
  String startTime;
  String endTime;
  String type;

  Lecture(this.course,
      {required this.crn,
      required this.code,
      required this.day,
      required this.type,
      required this.section,
      required this.instructor,
      required this.startTime,
      required this.endTime});
}

List<Schedule> combineSchedulesWithoutConflicts(List<Schedule> schedules) {
  List<Schedule> resultSchedules = [];

  for (int i = 0; i < schedules.length; i++) {
    for (int j = i + 1; j < schedules.length; j++) {
      Schedule? combinedSchedule =
          _combineTwoSchedules(schedules[i], schedules[j]);
      if (combinedSchedule != null) {
        resultSchedules.add(combinedSchedule);
      }
    }
  }

  return resultSchedules;
}

Schedule? _combineTwoSchedules(Schedule schedule1, Schedule schedule2) {
  Schedule combinedSchedule = Schedule(
    sundayLectures: [],
    mondayLectures: [],
    tuesdayLectures: [],
    wednesdayLectures: [],
    thursdayLectures: [],
    codes: [],
    CRNs: [],
  );

  if (!_addLectures(combinedSchedule.sundayLectures, schedule1.sundayLectures,
      schedule2.sundayLectures)) return null;
  if (!_addLectures(combinedSchedule.mondayLectures, schedule1.mondayLectures,
      schedule2.mondayLectures)) return null;
  if (!_addLectures(combinedSchedule.tuesdayLectures, schedule1.tuesdayLectures,
      schedule2.tuesdayLectures)) return null;
  if (!_addLectures(combinedSchedule.wednesdayLectures,
      schedule1.wednesdayLectures, schedule2.wednesdayLectures)) return null;
  if (!_addLectures(combinedSchedule.thursdayLectures,
      schedule1.thursdayLectures, schedule2.thursdayLectures)) return null;

  combinedSchedule.codes.addAll(schedule1.codes);
  combinedSchedule.codes.addAll(schedule2.codes);
  combinedSchedule.CRNs.addAll(schedule1.CRNs);
  combinedSchedule.CRNs.addAll(schedule2.CRNs);

  return combinedSchedule;
}

bool _addLectures(List<Lecture> targetList, List<Lecture> lectures1,
    List<Lecture> lectures2) {
  Map<String, Lecture> seenLectures = {};

  List<Lecture> allLectures = [...lectures1, ...lectures2];

  for (var lecture in allLectures) {
    String key = '${lecture.code}_${lecture.type}';

    if (seenLectures.containsKey(key)) {
      continue;
    }

    bool conflict = targetList.any((l) =>
        l.startTime == lecture.startTime &&
        l.endTime == lecture.endTime &&
        l.day == lecture.day);

    if (conflict) {
      return false;
    }

    seenLectures[key] = lecture;
    targetList.add(lecture);
  }

  return true;
}
