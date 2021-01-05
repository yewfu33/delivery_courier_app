enum VehicleType { bike, car, lorry }

enum DeliveryStatus {
  markArrivedPickUp, // 0
  startDeliveryTask, // 1
  markArrivedDropPoint, // 2
  completeDelivery //3
}

extension NameExtension on VehicleType {
  String get name {
    switch (this) {
      case VehicleType.bike:
        return 'MotorBike';
      case VehicleType.car:
        return 'Car';
      case VehicleType.lorry:
        return 'Lorry';
      default:
        return '';
    }
  }
}
