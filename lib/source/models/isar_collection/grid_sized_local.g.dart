// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grid_sized_local.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGridSizedLocalCollection on Isar {
  IsarCollection<GridSizedLocal> get gridSizedLocals => this.collection();
}

const GridSizedLocalSchema = CollectionSchema(
  name: r'GridSizedLocal',
  id: -4664164755775346674,
  properties: {
    r'currentSelected': PropertySchema(
      id: 0,
      name: r'currentSelected',
      type: IsarType.bool,
    ),
    r'duplicateCount': PropertySchema(
      id: 1,
      name: r'duplicateCount',
      type: IsarType.long,
    ),
    r'gridSizeX': PropertySchema(
      id: 2,
      name: r'gridSizeX',
      type: IsarType.long,
    ),
    r'gridSizeY': PropertySchema(
      id: 3,
      name: r'gridSizeY',
      type: IsarType.long,
    ),
    r'hideModel': PropertySchema(
      id: 4,
      name: r'hideModel',
      type: IsarType.bool,
    ),
    r'listDataJson': PropertySchema(
      id: 5,
      name: r'listDataJson',
      type: IsarType.stringList,
    ),
    r'title': PropertySchema(
      id: 6,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _gridSizedLocalEstimateSize,
  serialize: _gridSizedLocalSerialize,
  deserialize: _gridSizedLocalDeserialize,
  deserializeProp: _gridSizedLocalDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _gridSizedLocalGetId,
  getLinks: _gridSizedLocalGetLinks,
  attach: _gridSizedLocalAttach,
  version: '3.1.0+1',
);

int _gridSizedLocalEstimateSize(
  GridSizedLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.listDataJson;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _gridSizedLocalSerialize(
  GridSizedLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.currentSelected);
  writer.writeLong(offsets[1], object.duplicateCount);
  writer.writeLong(offsets[2], object.gridSizeX);
  writer.writeLong(offsets[3], object.gridSizeY);
  writer.writeBool(offsets[4], object.hideModel);
  writer.writeStringList(offsets[5], object.listDataJson);
  writer.writeString(offsets[6], object.title);
}

GridSizedLocal _gridSizedLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GridSizedLocal();
  object.currentSelected = reader.readBool(offsets[0]);
  object.duplicateCount = reader.readLong(offsets[1]);
  object.gridSizeX = reader.readLongOrNull(offsets[2]);
  object.gridSizeY = reader.readLongOrNull(offsets[3]);
  object.hideModel = reader.readBoolOrNull(offsets[4]);
  object.id = id;
  object.listDataJson = reader.readStringList(offsets[5]);
  object.title = reader.readStringOrNull(offsets[6]);
  return object;
}

P _gridSizedLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset)) as P;
    case 5:
      return (reader.readStringList(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gridSizedLocalGetId(GridSizedLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gridSizedLocalGetLinks(GridSizedLocal object) {
  return [];
}

void _gridSizedLocalAttach(
    IsarCollection<dynamic> col, Id id, GridSizedLocal object) {
  object.id = id;
}

extension GridSizedLocalQueryWhereSort
    on QueryBuilder<GridSizedLocal, GridSizedLocal, QWhere> {
  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GridSizedLocalQueryWhere
    on QueryBuilder<GridSizedLocal, GridSizedLocal, QWhereClause> {
  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterWhereClause> idBetween(
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

extension GridSizedLocalQueryFilter
    on QueryBuilder<GridSizedLocal, GridSizedLocal, QFilterCondition> {
  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      currentSelectedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentSelected',
        value: value,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      duplicateCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duplicateCount',
        value: value,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      duplicateCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duplicateCount',
        value: value,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      duplicateCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duplicateCount',
        value: value,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      duplicateCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duplicateCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      gridSizeXIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gridSizeX',
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      gridSizeXIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gridSizeX',
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      gridSizeXEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gridSizeX',
        value: value,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      gridSizeXGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gridSizeX',
        value: value,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      gridSizeXLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gridSizeX',
        value: value,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      gridSizeXBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gridSizeX',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      gridSizeYIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gridSizeY',
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      gridSizeYIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gridSizeY',
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      gridSizeYEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gridSizeY',
        value: value,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      gridSizeYGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gridSizeY',
        value: value,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      gridSizeYLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gridSizeY',
        value: value,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      gridSizeYBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gridSizeY',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      hideModelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hideModel',
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      hideModelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hideModel',
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      hideModelEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hideModel',
        value: value,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
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

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
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

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'listDataJson',
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'listDataJson',
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'listDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'listDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'listDataJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'listDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'listDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'listDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'listDataJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listDataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'listDataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'listDataJson',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'listDataJson',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'listDataJson',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'listDataJson',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'listDataJson',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      listDataJsonLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'listDataJson',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension GridSizedLocalQueryObject
    on QueryBuilder<GridSizedLocal, GridSizedLocal, QFilterCondition> {}

extension GridSizedLocalQueryLinks
    on QueryBuilder<GridSizedLocal, GridSizedLocal, QFilterCondition> {}

extension GridSizedLocalQuerySortBy
    on QueryBuilder<GridSizedLocal, GridSizedLocal, QSortBy> {
  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      sortByCurrentSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSelected', Sort.asc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      sortByCurrentSelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSelected', Sort.desc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      sortByDuplicateCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duplicateCount', Sort.asc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      sortByDuplicateCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duplicateCount', Sort.desc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy> sortByGridSizeX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSizeX', Sort.asc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      sortByGridSizeXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSizeX', Sort.desc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy> sortByGridSizeY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSizeY', Sort.asc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      sortByGridSizeYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSizeY', Sort.desc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy> sortByHideModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideModel', Sort.asc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      sortByHideModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideModel', Sort.desc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension GridSizedLocalQuerySortThenBy
    on QueryBuilder<GridSizedLocal, GridSizedLocal, QSortThenBy> {
  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      thenByCurrentSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSelected', Sort.asc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      thenByCurrentSelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSelected', Sort.desc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      thenByDuplicateCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duplicateCount', Sort.asc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      thenByDuplicateCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duplicateCount', Sort.desc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy> thenByGridSizeX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSizeX', Sort.asc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      thenByGridSizeXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSizeX', Sort.desc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy> thenByGridSizeY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSizeY', Sort.asc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      thenByGridSizeYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSizeY', Sort.desc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy> thenByHideModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideModel', Sort.asc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy>
      thenByHideModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideModel', Sort.desc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension GridSizedLocalQueryWhereDistinct
    on QueryBuilder<GridSizedLocal, GridSizedLocal, QDistinct> {
  QueryBuilder<GridSizedLocal, GridSizedLocal, QDistinct>
      distinctByCurrentSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentSelected');
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QDistinct>
      distinctByDuplicateCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duplicateCount');
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QDistinct>
      distinctByGridSizeX() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gridSizeX');
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QDistinct>
      distinctByGridSizeY() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gridSizeY');
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QDistinct>
      distinctByHideModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hideModel');
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QDistinct>
      distinctByListDataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'listDataJson');
    });
  }

  QueryBuilder<GridSizedLocal, GridSizedLocal, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension GridSizedLocalQueryProperty
    on QueryBuilder<GridSizedLocal, GridSizedLocal, QQueryProperty> {
  QueryBuilder<GridSizedLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GridSizedLocal, bool, QQueryOperations>
      currentSelectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentSelected');
    });
  }

  QueryBuilder<GridSizedLocal, int, QQueryOperations> duplicateCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duplicateCount');
    });
  }

  QueryBuilder<GridSizedLocal, int?, QQueryOperations> gridSizeXProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gridSizeX');
    });
  }

  QueryBuilder<GridSizedLocal, int?, QQueryOperations> gridSizeYProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gridSizeY');
    });
  }

  QueryBuilder<GridSizedLocal, bool?, QQueryOperations> hideModelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hideModel');
    });
  }

  QueryBuilder<GridSizedLocal, List<String>?, QQueryOperations>
      listDataJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'listDataJson');
    });
  }

  QueryBuilder<GridSizedLocal, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
