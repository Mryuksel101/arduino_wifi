class ArrowRecordStep {
  final String title;
  final String description;
  final ArrowMeasurementType type;
  dynamic value; // Ölçüm değeri

  ArrowRecordStep({
    required this.title,
    required this.description,
    required this.type,
    this.value,
  });
}

enum ArrowMeasurementType {
  code,
  weight,
  leftSpine,
  rightSpine,
}

final List<ArrowRecordStep> arrowRecordSteps = [
  ArrowRecordStep(
    title: 'Kod',
    description: 'Okun kodunu giriniz',
    type: ArrowMeasurementType.code,
  ),
  ArrowRecordStep(
    title: 'Ağırlık',
    description:
        'Okun ağırlığını ölçmek için cihaza yerleştiriniz ve sabit değeri görüp kaydediniz',
    type: ArrowMeasurementType.weight,
  ),
  ArrowRecordStep(
    title: 'Sol Spine',
    description: 'Okun sol spine değeri için cihaza yerleştiriniz',
    type: ArrowMeasurementType.leftSpine,
  ),
  ArrowRecordStep(
    title: 'Sağ Spine',
    description: 'Okun sağ spine değeri için cihaza yerleştiriniz',
    type: ArrowMeasurementType.rightSpine,
  ),
];
