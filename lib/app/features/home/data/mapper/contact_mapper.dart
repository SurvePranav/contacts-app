import 'package:contacts_app/app/core/common/methods/common_methods.dart';
import 'package:contacts_app/app/features/home/data/models/contact_model.dart';
import 'package:contacts_app/app/features/home/domain/entities/contact_entity.dart';

abstract class ContactMapper {
  static Contact toEntity(ContactModel model) {
    return Contact(
      id: model.id,
      name: model.name,
      phone: model.phone,
      initials: model.initials,
      color: CommonMethods.stringToColor(model.color),
      emailId: model.emailId,
      isFavourite: model.isFavourite,
    );
  }

  /// Convert Entity → Model
  static ContactModel toModel(Contact entity) {
    return ContactModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      initials: entity.initials,
      color: CommonMethods.colorToString(entity.color),
      emailId: entity.emailId,
      isFavourite: entity.isFavourite,
    );
  }
}
