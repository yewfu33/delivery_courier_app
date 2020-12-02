enum VehicleType { Bike, Car, Lorry }

extension CatExtension on VehicleType {
  String get name {
    switch (this) {
      case VehicleType.Bike:
        return 'MotorBike';
      case VehicleType.Car:
        return 'Car';
      case VehicleType.Lorry:
        return 'Lorry';
      default:
        return null;
    }
  }
}
