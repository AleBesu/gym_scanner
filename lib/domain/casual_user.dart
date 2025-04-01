class CasualUser {
  int pay;

  CasualUser(this.pay);

  factory CasualUser.fromJson(Map<String, dynamic> json) {
    return CasualUser(
      json['pay'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pay': pay,
    };
  }
}
