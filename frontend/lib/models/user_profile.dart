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

    this.socialLinks,
    this.preferences,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Handle null or non-list interests
    List<String>? interestsList;
    if (json['interests'] != null) {
      if (json['interests'] is List) {
        interestsList = List<String>.from(json['interests'].map((i) => i.toString()));
      }
    }
    
    // Handle null or non-map social links
    Map<String, String>? socialLinksMap;
    if (json['social_links'] != null) {
      if (json['social_links'] is Map) {
        socialLinksMap = Map<String, String>.from(
          json['social_links'].map((key, value) => MapEntry(key.toString(), value.toString()))
        );
      }
    }
    
    // Safely parse id and userId with multiple fallbacks
    int id = 0;
    int userId = 0;
    
    try {
      if (json['id'] != null) {
        if (json['id'] is int) {
          id = json['id'];
        } else {
          id = int.tryParse(json['id'].toString()) ?? 0;
        }
      }
      
      if (json['user_id'] != null) {
        if (json['user_id'] is int) {
          userId = json['user_id'];
        } else {
          userId = int.tryParse(json['user_id'].toString()) ?? 0;
        }
      }
    } catch (e) {
      print('Error parsing id or user_id: $e');
      // Fallback to default values
      id = 0;
      userId = 0;
    }
    
    return UserProfile(
      id: id,
      userId: userId,
      avatarUrl: json['avatar_url']?.toString(),
      fullName: json['full_name']?.toString(),
      email: json['email']?.toString(),
      bio: json['bio']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      address: json['address']?.toString(),
      birthDate: json['birth_date']?.toString(),
      gender: json['gender']?.toString(),
      occupation: json['occupation']?.toString(),
      interests: interestsList,

      socialLinks: socialLinksMap,
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

      socialLinks: socialLinks ?? this.socialLinks,
      preferences: preferences ?? this.preferences,
    );
  }
}