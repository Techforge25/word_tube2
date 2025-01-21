// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grid_local.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGridLocalCollection on Isar {
  IsarCollection<GridLocal> get gridLocals => this.collection();
}

const GridLocalSchema = CollectionSchema(
  name: r'GridLocal',
  id: -2402869827015056200,
  properties: {
    r'hideImage': PropertySchema(
      id: 0,
      name: r'hideImage',
      type: IsarType.bool,
    ),
    r'hidetitle': PropertySchema(
      id: 1,
      name: r'hidetitle',
      type: IsarType.bool,
    ),
    r'imagepath': PropertySchema(
      id: 2,
      name: r'imagepath',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 3,
      name: r'title',
      type: IsarType.string,
    ),
    r'videosPath': PropertySchema(
      id: 4,
      name: r'videosPath',
      type: IsarType.stringList,
    )
  },
  estimateSize: _gridLocalEstimateSize,
  serialize: _gridLocalSerialize,
  deserialize: _gridLocalDeserialize,
  deserializeProp: _gridLocalDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _gridLocalGetId,
  getLinks: _gridLocalGetLinks,
  attach: _gridLocalAttach,
  version: '3.1.0+1',
);

int _gridLocalEstimateSize(
  GridLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.imagepath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.videosPath;
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
  return bytesCount;
}

void _gridLocalSerialize(
  GridLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.hideImage);
  writer.writeBool(offsets[1], object.hidetitle);
  writer.writeString(offsets[2], object.imagepath);
  writer.writeString(offsets[3], object.title);
  writer.writeStringList(offsets[4], object.videosPath);
}

GridLocal _gridLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GridLocal();
  object.hideImage = reader.readBoolOrNull(offsets[0]);
  object.hidetitle = reader.readBoolOrNull(offsets[1]);
  object.id = id;
  object.imagepath = reader.readStringOrNull(offsets[2]);
  object.title = reader.readStringOrNull(offsets[3]);
  object.videosPath = reader.readStringList(offsets[4]);
  return object;
}

P _gridLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gridLocalGetId(GridLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gridLocalGetLinks(GridLocal object) {
  return [];
}

void _gridLocalAttach(IsarCollection<dynamic> col, Id id, GridLocal object) {
  object.id = id;
}

extension GridLocalQueryWhereSort
    on QueryBuilder<GridLocal, GridLocal, QWhere> {
  QueryBuilder<GridLocal, GridLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GridLocalQueryWhere
    on QueryBuilder<GridLocal, GridLocal, QWhereClause> {
  QueryBuilder<GridLocal, GridLocal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<GridLocal, GridLocal, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterWhereClause> idBetween(
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

extension GridLocalQueryFilter
    on QueryBuilder<GridLocal, GridLocal, QFilterCondition> {
  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> hideImageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hideImage',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      hideImageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hideImage',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> hideImageEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hideImage',
        value: value,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> hidetitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hidetitle',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      hidetitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hidetitle',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> hidetitleEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hidetitle',
        value: value,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> imagepathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imagepath',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      imagepathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imagepath',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> imagepathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      imagepathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> imagepathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> imagepathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagepath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> imagepathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> imagepathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> imagepathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> imagepathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagepath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> imagepathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagepath',
        value: '',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      imagepathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagepath',
        value: '',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> titleGreaterThan(
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

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> titleStartsWith(
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

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition> videosPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'videosPath',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'videosPath',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videosPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'videosPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'videosPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'videosPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'videosPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'videosPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'videosPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'videosPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videosPath',
        value: '',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'videosPath',
        value: '',
      ));
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'videosPath',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'videosPath',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'videosPath',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'videosPath',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'videosPath',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterFilterCondition>
      videosPathLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'videosPath',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension GridLocalQueryObject
    on QueryBuilder<GridLocal, GridLocal, QFilterCondition> {}

extension GridLocalQueryLinks
    on QueryBuilder<GridLocal, GridLocal, QFilterCondition> {}

extension GridLocalQuerySortBy on QueryBuilder<GridLocal, GridLocal, QSortBy> {
  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> sortByHideImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideImage', Sort.asc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> sortByHideImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideImage', Sort.desc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> sortByHidetitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hidetitle', Sort.asc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> sortByHidetitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hidetitle', Sort.desc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> sortByImagepath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagepath', Sort.asc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> sortByImagepathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagepath', Sort.desc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension GridLocalQuerySortThenBy
    on QueryBuilder<GridLocal, GridLocal, QSortThenBy> {
  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> thenByHideImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideImage', Sort.asc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> thenByHideImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideImage', Sort.desc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> thenByHidetitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hidetitle', Sort.asc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> thenByHidetitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hidetitle', Sort.desc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> thenByImagepath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagepath', Sort.asc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> thenByImagepathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagepath', Sort.desc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension GridLocalQueryWhereDistinct
    on QueryBuilder<GridLocal, GridLocal, QDistinct> {
  QueryBuilder<GridLocal, GridLocal, QDistinct> distinctByHideImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hideImage');
    });
  }

  QueryBuilder<GridLocal, GridLocal, QDistinct> distinctByHidetitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hidetitle');
    });
  }

  QueryBuilder<GridLocal, GridLocal, QDistinct> distinctByImagepath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagepath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GridLocal, GridLocal, QDistinct> distinctByVideosPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videosPath');
    });
  }
}

extension GridLocalQueryProperty
    on QueryBuilder<GridLocal, GridLocal, QQueryProperty> {
  QueryBuilder<GridLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GridLocal, bool?, QQueryOperations> hideImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hideImage');
    });
  }

  QueryBuilder<GridLocal, bool?, QQueryOperations> hidetitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hidetitle');
    });
  }

  QueryBuilder<GridLocal, String?, QQueryOperations> imagepathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagepath');
    });
  }

  QueryBuilder<GridLocal, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<GridLocal, List<String>?, QQueryOperations>
      videosPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videosPath');
    });
  }
}
