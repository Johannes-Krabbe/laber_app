// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outgoing_message.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOutgoingMessageCollection on Isar {
  IsarCollection<OutgoingMessage> get outgoingMessages => this.collection();
}

const OutgoingMessageSchema = CollectionSchema(
  name: r'OutgoingMessage',
  id: 1658898918316049680,
  properties: {
    r'content': PropertySchema(
      id: 0,
      name: r'content',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'failedAt': PropertySchema(
      id: 2,
      name: r'failedAt',
      type: IsarType.dateTime,
    ),
    r'recipientDeviceId': PropertySchema(
      id: 3,
      name: r'recipientDeviceId',
      type: IsarType.string,
    ),
    r'senderDeviceId': PropertySchema(
      id: 4,
      name: r'senderDeviceId',
      type: IsarType.string,
    ),
    r'sentAt': PropertySchema(
      id: 5,
      name: r'sentAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 6,
      name: r'status',
      type: IsarType.byte,
      enumMap: _OutgoingMessagestatusEnumValueMap,
    )
  },
  estimateSize: _outgoingMessageEstimateSize,
  serialize: _outgoingMessageSerialize,
  deserialize: _outgoingMessageDeserialize,
  deserializeProp: _outgoingMessageDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _outgoingMessageGetId,
  getLinks: _outgoingMessageGetLinks,
  attach: _outgoingMessageAttach,
  version: '3.1.0+1',
);

int _outgoingMessageEstimateSize(
  OutgoingMessage object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.recipientDeviceId.length * 3;
  bytesCount += 3 + object.senderDeviceId.length * 3;
  return bytesCount;
}

void _outgoingMessageSerialize(
  OutgoingMessage object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.content);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.failedAt);
  writer.writeString(offsets[3], object.recipientDeviceId);
  writer.writeString(offsets[4], object.senderDeviceId);
  writer.writeDateTime(offsets[5], object.sentAt);
  writer.writeByte(offsets[6], object.status.index);
}

OutgoingMessage _outgoingMessageDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OutgoingMessage();
  object.content = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.failedAt = reader.readDateTimeOrNull(offsets[2]);
  object.id = id;
  object.recipientDeviceId = reader.readString(offsets[3]);
  object.senderDeviceId = reader.readString(offsets[4]);
  object.sentAt = reader.readDateTimeOrNull(offsets[5]);
  object.status =
      _OutgoingMessagestatusValueEnumMap[reader.readByteOrNull(offsets[6])] ??
          OutgoingStatus.pending;
  return object;
}

P _outgoingMessageDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (_OutgoingMessagestatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          OutgoingStatus.pending) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _OutgoingMessagestatusEnumValueMap = {
  'pending': 0,
  'sent': 1,
  'failed': 2,
};
const _OutgoingMessagestatusValueEnumMap = {
  0: OutgoingStatus.pending,
  1: OutgoingStatus.sent,
  2: OutgoingStatus.failed,
};

Id _outgoingMessageGetId(OutgoingMessage object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _outgoingMessageGetLinks(OutgoingMessage object) {
  return [];
}

void _outgoingMessageAttach(
    IsarCollection<dynamic> col, Id id, OutgoingMessage object) {
  object.id = id;
}

extension OutgoingMessageQueryWhereSort
    on QueryBuilder<OutgoingMessage, OutgoingMessage, QWhere> {
  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OutgoingMessageQueryWhere
    on QueryBuilder<OutgoingMessage, OutgoingMessage, QWhereClause> {
  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OutgoingMessageQueryFilter
    on QueryBuilder<OutgoingMessage, OutgoingMessage, QFilterCondition> {
  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      failedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'failedAt',
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      failedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'failedAt',
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      failedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'failedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      failedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'failedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      failedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'failedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      failedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'failedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      recipientDeviceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipientDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      recipientDeviceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recipientDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      recipientDeviceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recipientDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      recipientDeviceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recipientDeviceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      recipientDeviceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recipientDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      recipientDeviceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recipientDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      recipientDeviceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recipientDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      recipientDeviceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recipientDeviceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      recipientDeviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipientDeviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      recipientDeviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recipientDeviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      senderDeviceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      senderDeviceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'senderDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      senderDeviceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'senderDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      senderDeviceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'senderDeviceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      senderDeviceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'senderDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      senderDeviceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'senderDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      senderDeviceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'senderDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      senderDeviceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'senderDeviceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      senderDeviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderDeviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      senderDeviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'senderDeviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      sentAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sentAt',
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      sentAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sentAt',
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      sentAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      sentAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      sentAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      sentAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sentAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      statusEqualTo(OutgoingStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      statusGreaterThan(
    OutgoingStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      statusLessThan(
    OutgoingStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterFilterCondition>
      statusBetween(
    OutgoingStatus lower,
    OutgoingStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OutgoingMessageQueryObject
    on QueryBuilder<OutgoingMessage, OutgoingMessage, QFilterCondition> {}

extension OutgoingMessageQueryLinks
    on QueryBuilder<OutgoingMessage, OutgoingMessage, QFilterCondition> {}

extension OutgoingMessageQuerySortBy
    on QueryBuilder<OutgoingMessage, OutgoingMessage, QSortBy> {
  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      sortByFailedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedAt', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      sortByFailedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedAt', Sort.desc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      sortByRecipientDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientDeviceId', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      sortByRecipientDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientDeviceId', Sort.desc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      sortBySenderDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderDeviceId', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      sortBySenderDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderDeviceId', Sort.desc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy> sortBySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      sortBySentAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.desc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension OutgoingMessageQuerySortThenBy
    on QueryBuilder<OutgoingMessage, OutgoingMessage, QSortThenBy> {
  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      thenByFailedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedAt', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      thenByFailedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedAt', Sort.desc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      thenByRecipientDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientDeviceId', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      thenByRecipientDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientDeviceId', Sort.desc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      thenBySenderDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderDeviceId', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      thenBySenderDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderDeviceId', Sort.desc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy> thenBySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      thenBySentAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.desc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension OutgoingMessageQueryWhereDistinct
    on QueryBuilder<OutgoingMessage, OutgoingMessage, QDistinct> {
  QueryBuilder<OutgoingMessage, OutgoingMessage, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QDistinct>
      distinctByFailedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'failedAt');
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QDistinct>
      distinctByRecipientDeviceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recipientDeviceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QDistinct>
      distinctBySenderDeviceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'senderDeviceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QDistinct> distinctBySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sentAt');
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingMessage, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }
}

extension OutgoingMessageQueryProperty
    on QueryBuilder<OutgoingMessage, OutgoingMessage, QQueryProperty> {
  QueryBuilder<OutgoingMessage, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OutgoingMessage, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<OutgoingMessage, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OutgoingMessage, DateTime?, QQueryOperations>
      failedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'failedAt');
    });
  }

  QueryBuilder<OutgoingMessage, String, QQueryOperations>
      recipientDeviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recipientDeviceId');
    });
  }

  QueryBuilder<OutgoingMessage, String, QQueryOperations>
      senderDeviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'senderDeviceId');
    });
  }

  QueryBuilder<OutgoingMessage, DateTime?, QQueryOperations> sentAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sentAt');
    });
  }

  QueryBuilder<OutgoingMessage, OutgoingStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
