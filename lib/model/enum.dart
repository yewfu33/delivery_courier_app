enum VehicleType { Bike, Car, Lorry }

enum DeliveryStatus {
  MarkArrivedPickUp, // 0
  StartDeliveryTask, // 1
  MarkArrivedDropPoint, // 2
  CompleteDelivery //3
}

extension NameExtension on VehicleType {
  String get name {
    switch (this) {
      case VehicleType.Bike:
        return 'MotorBike';
      case VehicleType.Car:
        return 'Car';
      case VehicleType.Lorry:
        return 'Lorry';
      default:
        return '';
    }
  }
}
