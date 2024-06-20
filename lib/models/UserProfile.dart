class UserProfile {
  final String? firstName;  
  final String? lastName;   
  final String? phoneNumber; 
  final String? address;
  final String? email;     

  UserProfile({
    this.firstName, 
    this.lastName,
    this.phoneNumber,
    this.address,
    this.email
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'] as String?, // Ép kiểu và xử lý null
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }
}
