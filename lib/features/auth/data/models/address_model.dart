class Address {
  final String id;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String label;
  final bool isDefault;

  const Address({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.label,
    this.isDefault = false,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      country: map['country'] ?? '',
      label: map['label'] ?? 'Home',
      isDefault: map['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'label': label,
      'isDefault': isDefault,
    };
  }

  Address copyWith({
    String? id,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? label,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      label: label ?? this.label,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'Address(id: $id, street: $street, city: $city, state: $state, zipCode: $zipCode, country: $country, label: $label, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address &&
        other.id == id &&
        other.street == street &&
        other.city == city &&
        other.state == state &&
        other.zipCode == zipCode &&
        other.country == country &&
        other.label == label &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        street.hashCode ^
        city.hashCode ^
        state.hashCode ^
        zipCode.hashCode ^
        country.hashCode ^
        label.hashCode ^
        isDefault.hashCode;
  }
}
