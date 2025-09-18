class UserProfile {
  final int id;
  final int userId;
  final String? avatarUrl;
  final String? fullName;
  final String? email;
  final String? bio;
  final String? phoneNumber;
  final String? address;
  final String? birthDate;
  final String? gender;
  final String? occupation;
  final List<String>? interests;
  final String? website;
  final Map<String, String>? socialLinks;
  final Map<String, dynamic>? preferences;

  UserProfile({
    required this.id,
    required this.userId,
    this.avatarUrl,
    this.fullName,
    this.email,
    this.bio,
    this.phoneNumber,
    this.address,
    this.birthDate,
    this.gender,
    this.occupation,
    this.interests,
    this.website,
    this.socialLinks,
    this.preferences,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      userId: json['user_id'],
      avatarUrl: json['avatar_url'],
      fullName: json['full_name'],
      email: json['email'],
      bio: json['bio'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      birthDate: json['birth_date'],
      gender: json['gender'],
      occupation: json['occupation'],
      interests: json['interests'] != null ? List<String>.from(json['interests']) : null,
      website: json['website'],
      socialLinks: json['social_links'] != null ? Map<String, String>.from(json['social_links']) : null,
      preferences: json['preferences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'avatar_url': avatarUrl,
      'full_name': fullName,
      'email': email,
      'bio': bio,
      'phone_number': phoneNumber,
      'address': address,
      'birth_date': birthDate,
      'gender': gender,
      'occupation': occupation,
      'interests': interests,
      'website': website,
      'social_links': socialLinks,
      'preferences': preferences,
    };
  }

  UserProfile copyWith({
    int? id,
    int? userId,
    String? avatarUrl,
    String? fullName,
    String? email,
    String? bio,
    String? phoneNumber,
    String? address,
    String? birthDate,
    String? gender,
    String? occupation,
    List<String>? interests,
    String? website,
    Map<String, String>? socialLinks,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      interests: interests ?? this.interests,
      website: website ?? this.website,
      socialLinks: socialLinks ?? this.socialLinks,
      preferences: preferences ?? this.preferences,
    );
  }
}