class UserProfileModel {
  final int isLogin;
  final int memberNo;
  final String memberLoginID;
  final String memberID;
  final String memberName;
  final String memberRegisterDate;
  final String memberExpireDate;
  final int memberTypeNo;
  final int memberLevelNo;
  final String memberLevelName;
  final int memberPoint;
  final String photo;

  UserProfileModel({
    this.isLogin,
    this.memberNo,
    this.memberLoginID,
    this.memberID,
    this.memberName,
    this.memberRegisterDate,
    this.memberExpireDate,
    this.memberTypeNo,
    this.memberLevelNo,
    this.memberLevelName,
    this.memberPoint,
    this.photo,
  });

  Map<String, dynamic> toMap() {
    return {
      'IsLogin': isLogin,
      'MemberNo': memberNo,
      'MemberLoginID': memberLoginID,
      'MemberID': memberID,
      'MemberName': memberName,
      'MemberRegisterDate': memberRegisterDate,
      'MemberExpireDate': memberExpireDate,
      'MemberTypeNo': memberTypeNo,
      'MemberLevelNo': memberLevelNo,
      'MemberLevelName': memberLevelName,
      'MemberPoint': memberPoint,
      'Photo': photo,
    };
  }

  // Implement toString to make it easier to see information about each UserProfile when
  // using the print statement.
  @override
  String toString() {
    return '''UserProfileModel{$isLogin,$memberNo,$memberLoginID,$memberID,$memberName,$memberRegisterDate,$memberExpireDate,$memberTypeNo,$memberLevelNo,$memberLevelName,$memberPoint,$photo,}''';
  }
}
