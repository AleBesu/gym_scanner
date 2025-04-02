class CasualCustomer {
  int pay;

  CasualCustomer(this.pay);

  factory CasualCustomer.fromJson(Map<String, dynamic> json) {
    return CasualCustomer(
      json['pay'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pay': pay,
    };
  }
}
