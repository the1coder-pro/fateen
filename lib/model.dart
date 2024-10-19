class Course {
  String code;
  String crn;
  String section;
  String status;
  String course;
  String creditHours;
  String days;
  String type;
  String time;

  String instructor;
  String requirments;
  String availableColleges;
  String availableMajors;

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
        code: json['code'],
        crn: json['crn'],
        section: json['section'],
        status: json['status'],
        course: json['course'],
        creditHours: json['credit hours'],
        days: json['days'],
        type: json['type'],
        time: json['time'],
        instructor: json['instructor'],
        requirments: json['requirments'],
        availableColleges: json['available_colleges'],
        availableMajors: json['available_majors']);
  }

  Course(
      {required this.code,
      required this.crn,
      required this.section,
      required this.status,
      required this.course,
      required this.creditHours,
      required this.days,
      required this.type,
      required this.time,
      required this.instructor,
      required this.requirments,
      required this.availableColleges,
      required this.availableMajors});
}
