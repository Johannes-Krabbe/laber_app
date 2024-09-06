// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_message.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRawMessageCollection on Isar {
  IsarCollection<RawMessage> get rawMessages => this.collection();
}

const RawMessageSchema = CollectionSchema(
  name: r'RawMessage',
  id: 6546940355494955126,
  properties: {
    r'apiId': PropertySchema(
      id: 0,
      name: r'apiId',
      type: IsarType.string,
    ),
    r'content': PropertySchema(
      id: 1,
      name: r'content',
      type: IsarType.string,
    ),
    r'senderDeviceId': PropertySchema(
      id: 2,
      name: r'senderDeviceId',
      type: IsarType.string,
    ),
    r'senderUserId': PropertySchema(
      id: 3,
      name: r'senderUserId',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 4,
      name: r'status',
      type: IsarType.byte,
      enumMap: _RawMessagestatusEnumValueMap,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.byte,
      enumMap: _RawMessagetypeEnumValueMap,
    ),
    r'unixTime': PropertySchema(
      id: 6,
      name: r'unixTime',
      type: IsarType.long,
    )
  },
  estimateSize: _rawMessageEstimateSize,
  serialize: _rawMessageSerialize,
  deserialize: _rawMessageDeserialize,
  deserializeProp: _rawMessageDeserializeProp,
  idName: r'id',
  indexes: {
    r'apiId': IndexSchema(
      id: 92618221247000178,
      name: r'apiId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'apiId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'chat': LinkSchema(
      id: -1412029827583531416,
      name: r'chat',
      target: r'Chat',
      single: true,
      linkName: r'messages',
    )
  },
  embeddedSchemas: {},
  getId: _rawMessageGetId,
  getLinks: _rawMessageGetLinks,
  attach: _rawMessageAttach,
  version: '3.1.0+1',
);

int _rawMessageEstimateSize(
  RawMessage object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.apiId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.senderDeviceId.length * 3;
  bytesCount += 3 + object.senderUserId.length * 3;
  return bytesCount;
}

void _rawMessageSerialize(
  RawMessage object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.apiId);
  writer.writeString(offsets[1], object.content);
  writer.writeString(offsets[2], object.senderDeviceId);
  writer.writeString(offsets[3], object.senderUserId);
  writer.writeByte(offsets[4], object.status.index);
  writer.writeByte(offsets[5], object.type.index);
  writer.writeLong(offsets[6], object.unixTime);
}

RawMessage _rawMessageDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RawMessage();
  object.apiId = reader.readStringOrNull(offsets[0]);
  object.content = reader.readString(offsets[1]);
  object.id = id;
  object.senderDeviceId = reader.readString(offsets[2]);
  object.senderUserId = reader.readString(offsets[3]);
  object.status =
      _RawMessagestatusValueEnumMap[reader.readByteOrNull(offsets[4])] ??
          RawMessageStatus.sending;
  object.type =
      _RawMessagetypeValueEnumMap[reader.readByteOrNull(offsets[5])] ??
          RawMessageTypes.initMessage;
  object.unixTime = reader.readLong(offsets[6]);
  return object;
}

P _rawMessageDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (_RawMessagestatusValueEnumMap[reader.readByteOrNull(offset)] ??
          RawMessageStatus.sending) as P;
    case 5:
      return (_RawMessagetypeValueEnumMap[reader.readByteOrNull(offset)] ??
          RawMessageTypes.initMessage) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _RawMessagestatusEnumValueMap = {
  'sending': 0,
  'sent': 1,
  'failed': 2,
  'received': 3,
};
const _RawMessagestatusValueEnumMap = {
  0: RawMessageStatus.sending,
  1: RawMessageStatus.sent,
  2: RawMessageStatus.failed,
  3: RawMessageStatus.received,
};
const _RawMessagetypeEnumValueMap = {
  'initMessage': 0,
  'textMessage': 1,
  'reaction': 2,
};
const _RawMessagetypeValueEnumMap = {
  0: RawMessageTypes.initMessage,
  1: RawMessageTypes.textMessage,
  2: RawMessageTypes.reaction,
};

Id _rawMessageGetId(RawMessage object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _rawMessageGetLinks(RawMessage object) {
  return [object.chat];
}

void _rawMessageAttach(IsarCollection<dynamic> col, Id id, RawMessage object) {
  object.id = id;
  object.chat.attach(col, col.isar.collection<Chat>(), r'chat', id);
}

extension RawMessageQueryWhereSort
    on QueryBuilder<RawMessage, RawMessage, QWhere> {
  QueryBuilder<RawMessage, RawMessage, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RawMessageQueryWhere
    on QueryBuilder<RawMessage, RawMessage, QWhereClause> {
  QueryBuilder<RawMessage, RawMessage, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<RawMessage, RawMessage, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterWhereClause> idBetween(
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

  QueryBuilder<RawMessage, RawMessage, QAfterWhereClause> apiIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'apiId',
        value: [null],
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterWhereClause> apiIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'apiId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterWhereClause> apiIdEqualTo(
      String? apiId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'apiId',
        value: [apiId],
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterWhereClause> apiIdNotEqualTo(
      String? apiId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'apiId',
              lower: [],
              upper: [apiId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'apiId',
              lower: [apiId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'apiId',
              lower: [apiId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'apiId',
              lower: [],
              upper: [apiId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension RawMessageQueryFilter
    on QueryBuilder<RawMessage, RawMessage, QFilterCondition> {
  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> apiIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'apiId',
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> apiIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'apiId',
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> apiIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'apiId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> apiIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'apiId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> apiIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'apiId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> apiIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'apiId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> apiIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'apiId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> apiIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'apiId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> apiIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'apiId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> apiIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'apiId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> apiIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'apiId',
        value: '',
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      apiIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'apiId',
        value: '',
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> contentEqualTo(
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> contentLessThan(
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> contentBetween(
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> contentStartsWith(
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> contentEndsWith(
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> contentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> contentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> idBetween(
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderDeviceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'senderDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderDeviceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'senderDeviceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderDeviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderDeviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderDeviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'senderDeviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderUserIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderUserIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'senderUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderUserIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'senderUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderUserIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'senderUserId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderUserIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'senderUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderUserIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'senderUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderUserIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'senderUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderUserIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'senderUserId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      senderUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'senderUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> statusEqualTo(
      RawMessageStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> statusGreaterThan(
    RawMessageStatus value, {
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> statusLessThan(
    RawMessageStatus value, {
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> statusBetween(
    RawMessageStatus lower,
    RawMessageStatus upper, {
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

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> typeEqualTo(
      RawMessageTypes value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> typeGreaterThan(
    RawMessageTypes value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> typeLessThan(
    RawMessageTypes value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> typeBetween(
    RawMessageTypes lower,
    RawMessageTypes upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> unixTimeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unixTime',
        value: value,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition>
      unixTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unixTime',
        value: value,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> unixTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unixTime',
        value: value,
      ));
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> unixTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unixTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RawMessageQueryObject
    on QueryBuilder<RawMessage, RawMessage, QFilterCondition> {}

extension RawMessageQueryLinks
    on QueryBuilder<RawMessage, RawMessage, QFilterCondition> {
  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> chat(
      FilterQuery<Chat> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'chat');
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterFilterCondition> chatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'chat', 0, true, 0, true);
    });
  }
}

extension RawMessageQuerySortBy
    on QueryBuilder<RawMessage, RawMessage, QSortBy> {
  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> sortByApiId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiId', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> sortByApiIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiId', Sort.desc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> sortBySenderDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderDeviceId', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy>
      sortBySenderDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderDeviceId', Sort.desc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> sortBySenderUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderUserId', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> sortBySenderUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderUserId', Sort.desc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> sortByUnixTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unixTime', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> sortByUnixTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unixTime', Sort.desc);
    });
  }
}

extension RawMessageQuerySortThenBy
    on QueryBuilder<RawMessage, RawMessage, QSortThenBy> {
  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenByApiId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiId', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenByApiIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiId', Sort.desc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenBySenderDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderDeviceId', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy>
      thenBySenderDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderDeviceId', Sort.desc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenBySenderUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderUserId', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenBySenderUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderUserId', Sort.desc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenByUnixTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unixTime', Sort.asc);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QAfterSortBy> thenByUnixTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unixTime', Sort.desc);
    });
  }
}

extension RawMessageQueryWhereDistinct
    on QueryBuilder<RawMessage, RawMessage, QDistinct> {
  QueryBuilder<RawMessage, RawMessage, QDistinct> distinctByApiId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'apiId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QDistinct> distinctBySenderDeviceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'senderDeviceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QDistinct> distinctBySenderUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'senderUserId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawMessage, RawMessage, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<RawMessage, RawMessage, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<RawMessage, RawMessage, QDistinct> distinctByUnixTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unixTime');
    });
  }
}

extension RawMessageQueryProperty
    on QueryBuilder<RawMessage, RawMessage, QQueryProperty> {
  QueryBuilder<RawMessage, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RawMessage, String?, QQueryOperations> apiIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'apiId');
    });
  }

  QueryBuilder<RawMessage, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<RawMessage, String, QQueryOperations> senderDeviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'senderDeviceId');
    });
  }

  QueryBuilder<RawMessage, String, QQueryOperations> senderUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'senderUserId');
    });
  }

  QueryBuilder<RawMessage, RawMessageStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<RawMessage, RawMessageTypes, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<RawMessage, int, QQueryOperations> unixTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unixTime');
    });
  }
}
