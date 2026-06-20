// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PuzzleRowsTable extends PuzzleRows
    with TableInfo<$PuzzleRowsTable, PuzzleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PuzzleRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _givensJsonMeta = const VerificationMeta(
    'givensJson',
  );
  @override
  late final GeneratedColumn<String> givensJson = GeneratedColumn<String>(
    'givens_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _solutionJsonMeta = const VerificationMeta(
    'solutionJson',
  );
  @override
  late final GeneratedColumn<String> solutionJson = GeneratedColumn<String>(
    'solution_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyScoreMeta = const VerificationMeta(
    'difficultyScore',
  );
  @override
  late final GeneratedColumn<int> difficultyScore = GeneratedColumn<int>(
    'difficulty_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTimeSecondsMeta = const VerificationMeta(
    'targetTimeSeconds',
  );
  @override
  late final GeneratedColumn<int> targetTimeSeconds = GeneratedColumn<int>(
    'target_time_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medianTimeSecondsMeta = const VerificationMeta(
    'medianTimeSeconds',
  );
  @override
  late final GeneratedColumn<int> medianTimeSeconds = GeneratedColumn<int>(
    'median_time_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requiredTechniquesJsonMeta =
      const VerificationMeta('requiredTechniquesJson');
  @override
  late final GeneratedColumn<String> requiredTechniquesJson =
      GeneratedColumn<String>(
        'required_techniques_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _solvePathJsonMeta = const VerificationMeta(
    'solvePathJson',
  );
  @override
  late final GeneratedColumn<String> solvePathJson = GeneratedColumn<String>(
    'solve_path_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rankedEligibleMeta = const VerificationMeta(
    'rankedEligible',
  );
  @override
  late final GeneratedColumn<bool> rankedEligible = GeneratedColumn<bool>(
    'ranked_eligible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ranked_eligible" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _challengeIdMeta = const VerificationMeta(
    'challengeId',
  );
  @override
  late final GeneratedColumn<String> challengeId = GeneratedColumn<String>(
    'challenge_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    givensJson,
    solutionJson,
    difficulty,
    difficultyScore,
    targetTimeSeconds,
    medianTimeSeconds,
    requiredTechniquesJson,
    solvePathJson,
    rankedEligible,
    challengeId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'puzzle_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<PuzzleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('givens_json')) {
      context.handle(
        _givensJsonMeta,
        givensJson.isAcceptableOrUnknown(data['givens_json']!, _givensJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_givensJsonMeta);
    }
    if (data.containsKey('solution_json')) {
      context.handle(
        _solutionJsonMeta,
        solutionJson.isAcceptableOrUnknown(
          data['solution_json']!,
          _solutionJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_solutionJsonMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('difficulty_score')) {
      context.handle(
        _difficultyScoreMeta,
        difficultyScore.isAcceptableOrUnknown(
          data['difficulty_score']!,
          _difficultyScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_difficultyScoreMeta);
    }
    if (data.containsKey('target_time_seconds')) {
      context.handle(
        _targetTimeSecondsMeta,
        targetTimeSeconds.isAcceptableOrUnknown(
          data['target_time_seconds']!,
          _targetTimeSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTimeSecondsMeta);
    }
    if (data.containsKey('median_time_seconds')) {
      context.handle(
        _medianTimeSecondsMeta,
        medianTimeSeconds.isAcceptableOrUnknown(
          data['median_time_seconds']!,
          _medianTimeSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medianTimeSecondsMeta);
    }
    if (data.containsKey('required_techniques_json')) {
      context.handle(
        _requiredTechniquesJsonMeta,
        requiredTechniquesJson.isAcceptableOrUnknown(
          data['required_techniques_json']!,
          _requiredTechniquesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requiredTechniquesJsonMeta);
    }
    if (data.containsKey('solve_path_json')) {
      context.handle(
        _solvePathJsonMeta,
        solvePathJson.isAcceptableOrUnknown(
          data['solve_path_json']!,
          _solvePathJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_solvePathJsonMeta);
    }
    if (data.containsKey('ranked_eligible')) {
      context.handle(
        _rankedEligibleMeta,
        rankedEligible.isAcceptableOrUnknown(
          data['ranked_eligible']!,
          _rankedEligibleMeta,
        ),
      );
    }
    if (data.containsKey('challenge_id')) {
      context.handle(
        _challengeIdMeta,
        challengeId.isAcceptableOrUnknown(
          data['challenge_id']!,
          _challengeIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PuzzleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PuzzleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      givensJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}givens_json'],
      )!,
      solutionJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}solution_json'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      difficultyScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty_score'],
      )!,
      targetTimeSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_time_seconds'],
      )!,
      medianTimeSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}median_time_seconds'],
      )!,
      requiredTechniquesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}required_techniques_json'],
      )!,
      solvePathJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}solve_path_json'],
      )!,
      rankedEligible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ranked_eligible'],
      )!,
      challengeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challenge_id'],
      ),
    );
  }

  @override
  $PuzzleRowsTable createAlias(String alias) {
    return $PuzzleRowsTable(attachedDatabase, alias);
  }
}

class PuzzleRow extends DataClass implements Insertable<PuzzleRow> {
  final String id;
  final String givensJson;
  final String solutionJson;
  final String difficulty;
  final int difficultyScore;
  final int targetTimeSeconds;
  final int medianTimeSeconds;
  final String requiredTechniquesJson;
  final String solvePathJson;
  final bool rankedEligible;
  final String? challengeId;
  const PuzzleRow({
    required this.id,
    required this.givensJson,
    required this.solutionJson,
    required this.difficulty,
    required this.difficultyScore,
    required this.targetTimeSeconds,
    required this.medianTimeSeconds,
    required this.requiredTechniquesJson,
    required this.solvePathJson,
    required this.rankedEligible,
    this.challengeId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['givens_json'] = Variable<String>(givensJson);
    map['solution_json'] = Variable<String>(solutionJson);
    map['difficulty'] = Variable<String>(difficulty);
    map['difficulty_score'] = Variable<int>(difficultyScore);
    map['target_time_seconds'] = Variable<int>(targetTimeSeconds);
    map['median_time_seconds'] = Variable<int>(medianTimeSeconds);
    map['required_techniques_json'] = Variable<String>(requiredTechniquesJson);
    map['solve_path_json'] = Variable<String>(solvePathJson);
    map['ranked_eligible'] = Variable<bool>(rankedEligible);
    if (!nullToAbsent || challengeId != null) {
      map['challenge_id'] = Variable<String>(challengeId);
    }
    return map;
  }

  PuzzleRowsCompanion toCompanion(bool nullToAbsent) {
    return PuzzleRowsCompanion(
      id: Value(id),
      givensJson: Value(givensJson),
      solutionJson: Value(solutionJson),
      difficulty: Value(difficulty),
      difficultyScore: Value(difficultyScore),
      targetTimeSeconds: Value(targetTimeSeconds),
      medianTimeSeconds: Value(medianTimeSeconds),
      requiredTechniquesJson: Value(requiredTechniquesJson),
      solvePathJson: Value(solvePathJson),
      rankedEligible: Value(rankedEligible),
      challengeId: challengeId == null && nullToAbsent
          ? const Value.absent()
          : Value(challengeId),
    );
  }

  factory PuzzleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PuzzleRow(
      id: serializer.fromJson<String>(json['id']),
      givensJson: serializer.fromJson<String>(json['givensJson']),
      solutionJson: serializer.fromJson<String>(json['solutionJson']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      difficultyScore: serializer.fromJson<int>(json['difficultyScore']),
      targetTimeSeconds: serializer.fromJson<int>(json['targetTimeSeconds']),
      medianTimeSeconds: serializer.fromJson<int>(json['medianTimeSeconds']),
      requiredTechniquesJson: serializer.fromJson<String>(
        json['requiredTechniquesJson'],
      ),
      solvePathJson: serializer.fromJson<String>(json['solvePathJson']),
      rankedEligible: serializer.fromJson<bool>(json['rankedEligible']),
      challengeId: serializer.fromJson<String?>(json['challengeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'givensJson': serializer.toJson<String>(givensJson),
      'solutionJson': serializer.toJson<String>(solutionJson),
      'difficulty': serializer.toJson<String>(difficulty),
      'difficultyScore': serializer.toJson<int>(difficultyScore),
      'targetTimeSeconds': serializer.toJson<int>(targetTimeSeconds),
      'medianTimeSeconds': serializer.toJson<int>(medianTimeSeconds),
      'requiredTechniquesJson': serializer.toJson<String>(
        requiredTechniquesJson,
      ),
      'solvePathJson': serializer.toJson<String>(solvePathJson),
      'rankedEligible': serializer.toJson<bool>(rankedEligible),
      'challengeId': serializer.toJson<String?>(challengeId),
    };
  }

  PuzzleRow copyWith({
    String? id,
    String? givensJson,
    String? solutionJson,
    String? difficulty,
    int? difficultyScore,
    int? targetTimeSeconds,
    int? medianTimeSeconds,
    String? requiredTechniquesJson,
    String? solvePathJson,
    bool? rankedEligible,
    Value<String?> challengeId = const Value.absent(),
  }) => PuzzleRow(
    id: id ?? this.id,
    givensJson: givensJson ?? this.givensJson,
    solutionJson: solutionJson ?? this.solutionJson,
    difficulty: difficulty ?? this.difficulty,
    difficultyScore: difficultyScore ?? this.difficultyScore,
    targetTimeSeconds: targetTimeSeconds ?? this.targetTimeSeconds,
    medianTimeSeconds: medianTimeSeconds ?? this.medianTimeSeconds,
    requiredTechniquesJson:
        requiredTechniquesJson ?? this.requiredTechniquesJson,
    solvePathJson: solvePathJson ?? this.solvePathJson,
    rankedEligible: rankedEligible ?? this.rankedEligible,
    challengeId: challengeId.present ? challengeId.value : this.challengeId,
  );
  PuzzleRow copyWithCompanion(PuzzleRowsCompanion data) {
    return PuzzleRow(
      id: data.id.present ? data.id.value : this.id,
      givensJson: data.givensJson.present
          ? data.givensJson.value
          : this.givensJson,
      solutionJson: data.solutionJson.present
          ? data.solutionJson.value
          : this.solutionJson,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      difficultyScore: data.difficultyScore.present
          ? data.difficultyScore.value
          : this.difficultyScore,
      targetTimeSeconds: data.targetTimeSeconds.present
          ? data.targetTimeSeconds.value
          : this.targetTimeSeconds,
      medianTimeSeconds: data.medianTimeSeconds.present
          ? data.medianTimeSeconds.value
          : this.medianTimeSeconds,
      requiredTechniquesJson: data.requiredTechniquesJson.present
          ? data.requiredTechniquesJson.value
          : this.requiredTechniquesJson,
      solvePathJson: data.solvePathJson.present
          ? data.solvePathJson.value
          : this.solvePathJson,
      rankedEligible: data.rankedEligible.present
          ? data.rankedEligible.value
          : this.rankedEligible,
      challengeId: data.challengeId.present
          ? data.challengeId.value
          : this.challengeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PuzzleRow(')
          ..write('id: $id, ')
          ..write('givensJson: $givensJson, ')
          ..write('solutionJson: $solutionJson, ')
          ..write('difficulty: $difficulty, ')
          ..write('difficultyScore: $difficultyScore, ')
          ..write('targetTimeSeconds: $targetTimeSeconds, ')
          ..write('medianTimeSeconds: $medianTimeSeconds, ')
          ..write('requiredTechniquesJson: $requiredTechniquesJson, ')
          ..write('solvePathJson: $solvePathJson, ')
          ..write('rankedEligible: $rankedEligible, ')
          ..write('challengeId: $challengeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    givensJson,
    solutionJson,
    difficulty,
    difficultyScore,
    targetTimeSeconds,
    medianTimeSeconds,
    requiredTechniquesJson,
    solvePathJson,
    rankedEligible,
    challengeId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PuzzleRow &&
          other.id == this.id &&
          other.givensJson == this.givensJson &&
          other.solutionJson == this.solutionJson &&
          other.difficulty == this.difficulty &&
          other.difficultyScore == this.difficultyScore &&
          other.targetTimeSeconds == this.targetTimeSeconds &&
          other.medianTimeSeconds == this.medianTimeSeconds &&
          other.requiredTechniquesJson == this.requiredTechniquesJson &&
          other.solvePathJson == this.solvePathJson &&
          other.rankedEligible == this.rankedEligible &&
          other.challengeId == this.challengeId);
}

class PuzzleRowsCompanion extends UpdateCompanion<PuzzleRow> {
  final Value<String> id;
  final Value<String> givensJson;
  final Value<String> solutionJson;
  final Value<String> difficulty;
  final Value<int> difficultyScore;
  final Value<int> targetTimeSeconds;
  final Value<int> medianTimeSeconds;
  final Value<String> requiredTechniquesJson;
  final Value<String> solvePathJson;
  final Value<bool> rankedEligible;
  final Value<String?> challengeId;
  final Value<int> rowid;
  const PuzzleRowsCompanion({
    this.id = const Value.absent(),
    this.givensJson = const Value.absent(),
    this.solutionJson = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.difficultyScore = const Value.absent(),
    this.targetTimeSeconds = const Value.absent(),
    this.medianTimeSeconds = const Value.absent(),
    this.requiredTechniquesJson = const Value.absent(),
    this.solvePathJson = const Value.absent(),
    this.rankedEligible = const Value.absent(),
    this.challengeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PuzzleRowsCompanion.insert({
    required String id,
    required String givensJson,
    required String solutionJson,
    required String difficulty,
    required int difficultyScore,
    required int targetTimeSeconds,
    required int medianTimeSeconds,
    required String requiredTechniquesJson,
    required String solvePathJson,
    this.rankedEligible = const Value.absent(),
    this.challengeId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       givensJson = Value(givensJson),
       solutionJson = Value(solutionJson),
       difficulty = Value(difficulty),
       difficultyScore = Value(difficultyScore),
       targetTimeSeconds = Value(targetTimeSeconds),
       medianTimeSeconds = Value(medianTimeSeconds),
       requiredTechniquesJson = Value(requiredTechniquesJson),
       solvePathJson = Value(solvePathJson);
  static Insertable<PuzzleRow> custom({
    Expression<String>? id,
    Expression<String>? givensJson,
    Expression<String>? solutionJson,
    Expression<String>? difficulty,
    Expression<int>? difficultyScore,
    Expression<int>? targetTimeSeconds,
    Expression<int>? medianTimeSeconds,
    Expression<String>? requiredTechniquesJson,
    Expression<String>? solvePathJson,
    Expression<bool>? rankedEligible,
    Expression<String>? challengeId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (givensJson != null) 'givens_json': givensJson,
      if (solutionJson != null) 'solution_json': solutionJson,
      if (difficulty != null) 'difficulty': difficulty,
      if (difficultyScore != null) 'difficulty_score': difficultyScore,
      if (targetTimeSeconds != null) 'target_time_seconds': targetTimeSeconds,
      if (medianTimeSeconds != null) 'median_time_seconds': medianTimeSeconds,
      if (requiredTechniquesJson != null)
        'required_techniques_json': requiredTechniquesJson,
      if (solvePathJson != null) 'solve_path_json': solvePathJson,
      if (rankedEligible != null) 'ranked_eligible': rankedEligible,
      if (challengeId != null) 'challenge_id': challengeId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PuzzleRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? givensJson,
    Value<String>? solutionJson,
    Value<String>? difficulty,
    Value<int>? difficultyScore,
    Value<int>? targetTimeSeconds,
    Value<int>? medianTimeSeconds,
    Value<String>? requiredTechniquesJson,
    Value<String>? solvePathJson,
    Value<bool>? rankedEligible,
    Value<String?>? challengeId,
    Value<int>? rowid,
  }) {
    return PuzzleRowsCompanion(
      id: id ?? this.id,
      givensJson: givensJson ?? this.givensJson,
      solutionJson: solutionJson ?? this.solutionJson,
      difficulty: difficulty ?? this.difficulty,
      difficultyScore: difficultyScore ?? this.difficultyScore,
      targetTimeSeconds: targetTimeSeconds ?? this.targetTimeSeconds,
      medianTimeSeconds: medianTimeSeconds ?? this.medianTimeSeconds,
      requiredTechniquesJson:
          requiredTechniquesJson ?? this.requiredTechniquesJson,
      solvePathJson: solvePathJson ?? this.solvePathJson,
      rankedEligible: rankedEligible ?? this.rankedEligible,
      challengeId: challengeId ?? this.challengeId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (givensJson.present) {
      map['givens_json'] = Variable<String>(givensJson.value);
    }
    if (solutionJson.present) {
      map['solution_json'] = Variable<String>(solutionJson.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (difficultyScore.present) {
      map['difficulty_score'] = Variable<int>(difficultyScore.value);
    }
    if (targetTimeSeconds.present) {
      map['target_time_seconds'] = Variable<int>(targetTimeSeconds.value);
    }
    if (medianTimeSeconds.present) {
      map['median_time_seconds'] = Variable<int>(medianTimeSeconds.value);
    }
    if (requiredTechniquesJson.present) {
      map['required_techniques_json'] = Variable<String>(
        requiredTechniquesJson.value,
      );
    }
    if (solvePathJson.present) {
      map['solve_path_json'] = Variable<String>(solvePathJson.value);
    }
    if (rankedEligible.present) {
      map['ranked_eligible'] = Variable<bool>(rankedEligible.value);
    }
    if (challengeId.present) {
      map['challenge_id'] = Variable<String>(challengeId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PuzzleRowsCompanion(')
          ..write('id: $id, ')
          ..write('givensJson: $givensJson, ')
          ..write('solutionJson: $solutionJson, ')
          ..write('difficulty: $difficulty, ')
          ..write('difficultyScore: $difficultyScore, ')
          ..write('targetTimeSeconds: $targetTimeSeconds, ')
          ..write('medianTimeSeconds: $medianTimeSeconds, ')
          ..write('requiredTechniquesJson: $requiredTechniquesJson, ')
          ..write('solvePathJson: $solvePathJson, ')
          ..write('rankedEligible: $rankedEligible, ')
          ..write('challengeId: $challengeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttemptRowsTable extends AttemptRows
    with TableInfo<$AttemptRowsTable, AttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttemptRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _puzzleIdMeta = const VerificationMeta(
    'puzzleId',
  );
  @override
  late final GeneratedColumn<String> puzzleId = GeneratedColumn<String>(
    'puzzle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isRetryMeta = const VerificationMeta(
    'isRetry',
  );
  @override
  late final GeneratedColumn<bool> isRetry = GeneratedColumn<bool>(
    'is_retry',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_retry" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _attemptNumberMeta = const VerificationMeta(
    'attemptNumber',
  );
  @override
  late final GeneratedColumn<int> attemptNumber = GeneratedColumn<int>(
    'attempt_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elapsedSecondsMeta = const VerificationMeta(
    'elapsedSeconds',
  );
  @override
  late final GeneratedColumn<int> elapsedSeconds = GeneratedColumn<int>(
    'elapsed_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorCountMeta = const VerificationMeta(
    'errorCount',
  );
  @override
  late final GeneratedColumn<int> errorCount = GeneratedColumn<int>(
    'error_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hintNudgeCountMeta = const VerificationMeta(
    'hintNudgeCount',
  );
  @override
  late final GeneratedColumn<int> hintNudgeCount = GeneratedColumn<int>(
    'hint_nudge_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hintExplanationCountMeta =
      const VerificationMeta('hintExplanationCount');
  @override
  late final GeneratedColumn<int> hintExplanationCount = GeneratedColumn<int>(
    'hint_explanation_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hintRevealCountMeta = const VerificationMeta(
    'hintRevealCount',
  );
  @override
  late final GeneratedColumn<int> hintRevealCount = GeneratedColumn<int>(
    'hint_reveal_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _autoCheckEnabledMeta = const VerificationMeta(
    'autoCheckEnabled',
  );
  @override
  late final GeneratedColumn<bool> autoCheckEnabled = GeneratedColumn<bool>(
    'auto_check_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_check_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _mistakeRevealEnabledMeta =
      const VerificationMeta('mistakeRevealEnabled');
  @override
  late final GeneratedColumn<bool> mistakeRevealEnabled = GeneratedColumn<bool>(
    'mistake_reveal_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mistake_reveal_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _cleanSolveMeta = const VerificationMeta(
    'cleanSolve',
  );
  @override
  late final GeneratedColumn<bool> cleanSolve = GeneratedColumn<bool>(
    'clean_solve',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("clean_solve" IN (0, 1))',
    ),
  );
  static const VerificationMeta _rankedEligibleMeta = const VerificationMeta(
    'rankedEligible',
  );
  @override
  late final GeneratedColumn<bool> rankedEligible = GeneratedColumn<bool>(
    'ranked_eligible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ranked_eligible" IN (0, 1))',
    ),
  );
  static const VerificationMeta _scoreTotalMeta = const VerificationMeta(
    'scoreTotal',
  );
  @override
  late final GeneratedColumn<int> scoreTotal = GeneratedColumn<int>(
    'score_total',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scoreBaseMeta = const VerificationMeta(
    'scoreBase',
  );
  @override
  late final GeneratedColumn<int> scoreBase = GeneratedColumn<int>(
    'score_base',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accuracyMultiplierMeta =
      const VerificationMeta('accuracyMultiplier');
  @override
  late final GeneratedColumn<double> accuracyMultiplier =
      GeneratedColumn<double>(
        'accuracy_multiplier',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _timeBonusMeta = const VerificationMeta(
    'timeBonus',
  );
  @override
  late final GeneratedColumn<int> timeBonus = GeneratedColumn<int>(
    'time_bonus',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _efficiencyBonusMeta = const VerificationMeta(
    'efficiencyBonus',
  );
  @override
  late final GeneratedColumn<int> efficiencyBonus = GeneratedColumn<int>(
    'efficiency_bonus',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cleanSolveBonusMeta = const VerificationMeta(
    'cleanSolveBonus',
  );
  @override
  late final GeneratedColumn<int> cleanSolveBonus = GeneratedColumn<int>(
    'clean_solve_bonus',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scoringVersionMeta = const VerificationMeta(
    'scoringVersion',
  );
  @override
  late final GeneratedColumn<int> scoringVersion = GeneratedColumn<int>(
    'scoring_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accuracyFactorsJsonMeta =
      const VerificationMeta('accuracyFactorsJson');
  @override
  late final GeneratedColumn<String> accuracyFactorsJson =
      GeneratedColumn<String>(
        'accuracy_factors_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _moveHistoryJsonMeta = const VerificationMeta(
    'moveHistoryJson',
  );
  @override
  late final GeneratedColumn<String> moveHistoryJson = GeneratedColumn<String>(
    'move_history_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    puzzleId,
    isRetry,
    attemptNumber,
    elapsedSeconds,
    errorCount,
    hintNudgeCount,
    hintExplanationCount,
    hintRevealCount,
    autoCheckEnabled,
    mistakeRevealEnabled,
    completed,
    cleanSolve,
    rankedEligible,
    scoreTotal,
    scoreBase,
    accuracyMultiplier,
    timeBonus,
    efficiencyBonus,
    cleanSolveBonus,
    scoringVersion,
    accuracyFactorsJson,
    moveHistoryJson,
    startedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attempt_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttemptRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('puzzle_id')) {
      context.handle(
        _puzzleIdMeta,
        puzzleId.isAcceptableOrUnknown(data['puzzle_id']!, _puzzleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_puzzleIdMeta);
    }
    if (data.containsKey('is_retry')) {
      context.handle(
        _isRetryMeta,
        isRetry.isAcceptableOrUnknown(data['is_retry']!, _isRetryMeta),
      );
    }
    if (data.containsKey('attempt_number')) {
      context.handle(
        _attemptNumberMeta,
        attemptNumber.isAcceptableOrUnknown(
          data['attempt_number']!,
          _attemptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attemptNumberMeta);
    }
    if (data.containsKey('elapsed_seconds')) {
      context.handle(
        _elapsedSecondsMeta,
        elapsedSeconds.isAcceptableOrUnknown(
          data['elapsed_seconds']!,
          _elapsedSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_elapsedSecondsMeta);
    }
    if (data.containsKey('error_count')) {
      context.handle(
        _errorCountMeta,
        errorCount.isAcceptableOrUnknown(data['error_count']!, _errorCountMeta),
      );
    } else if (isInserting) {
      context.missing(_errorCountMeta);
    }
    if (data.containsKey('hint_nudge_count')) {
      context.handle(
        _hintNudgeCountMeta,
        hintNudgeCount.isAcceptableOrUnknown(
          data['hint_nudge_count']!,
          _hintNudgeCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hintNudgeCountMeta);
    }
    if (data.containsKey('hint_explanation_count')) {
      context.handle(
        _hintExplanationCountMeta,
        hintExplanationCount.isAcceptableOrUnknown(
          data['hint_explanation_count']!,
          _hintExplanationCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hintExplanationCountMeta);
    }
    if (data.containsKey('hint_reveal_count')) {
      context.handle(
        _hintRevealCountMeta,
        hintRevealCount.isAcceptableOrUnknown(
          data['hint_reveal_count']!,
          _hintRevealCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hintRevealCountMeta);
    }
    if (data.containsKey('auto_check_enabled')) {
      context.handle(
        _autoCheckEnabledMeta,
        autoCheckEnabled.isAcceptableOrUnknown(
          data['auto_check_enabled']!,
          _autoCheckEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_autoCheckEnabledMeta);
    }
    if (data.containsKey('mistake_reveal_enabled')) {
      context.handle(
        _mistakeRevealEnabledMeta,
        mistakeRevealEnabled.isAcceptableOrUnknown(
          data['mistake_reveal_enabled']!,
          _mistakeRevealEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mistakeRevealEnabledMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    if (data.containsKey('clean_solve')) {
      context.handle(
        _cleanSolveMeta,
        cleanSolve.isAcceptableOrUnknown(data['clean_solve']!, _cleanSolveMeta),
      );
    } else if (isInserting) {
      context.missing(_cleanSolveMeta);
    }
    if (data.containsKey('ranked_eligible')) {
      context.handle(
        _rankedEligibleMeta,
        rankedEligible.isAcceptableOrUnknown(
          data['ranked_eligible']!,
          _rankedEligibleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rankedEligibleMeta);
    }
    if (data.containsKey('score_total')) {
      context.handle(
        _scoreTotalMeta,
        scoreTotal.isAcceptableOrUnknown(data['score_total']!, _scoreTotalMeta),
      );
    }
    if (data.containsKey('score_base')) {
      context.handle(
        _scoreBaseMeta,
        scoreBase.isAcceptableOrUnknown(data['score_base']!, _scoreBaseMeta),
      );
    }
    if (data.containsKey('accuracy_multiplier')) {
      context.handle(
        _accuracyMultiplierMeta,
        accuracyMultiplier.isAcceptableOrUnknown(
          data['accuracy_multiplier']!,
          _accuracyMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('time_bonus')) {
      context.handle(
        _timeBonusMeta,
        timeBonus.isAcceptableOrUnknown(data['time_bonus']!, _timeBonusMeta),
      );
    }
    if (data.containsKey('efficiency_bonus')) {
      context.handle(
        _efficiencyBonusMeta,
        efficiencyBonus.isAcceptableOrUnknown(
          data['efficiency_bonus']!,
          _efficiencyBonusMeta,
        ),
      );
    }
    if (data.containsKey('clean_solve_bonus')) {
      context.handle(
        _cleanSolveBonusMeta,
        cleanSolveBonus.isAcceptableOrUnknown(
          data['clean_solve_bonus']!,
          _cleanSolveBonusMeta,
        ),
      );
    }
    if (data.containsKey('scoring_version')) {
      context.handle(
        _scoringVersionMeta,
        scoringVersion.isAcceptableOrUnknown(
          data['scoring_version']!,
          _scoringVersionMeta,
        ),
      );
    }
    if (data.containsKey('accuracy_factors_json')) {
      context.handle(
        _accuracyFactorsJsonMeta,
        accuracyFactorsJson.isAcceptableOrUnknown(
          data['accuracy_factors_json']!,
          _accuracyFactorsJsonMeta,
        ),
      );
    }
    if (data.containsKey('move_history_json')) {
      context.handle(
        _moveHistoryJsonMeta,
        moveHistoryJson.isAcceptableOrUnknown(
          data['move_history_json']!,
          _moveHistoryJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_moveHistoryJsonMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttemptRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      puzzleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}puzzle_id'],
      )!,
      isRetry: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_retry'],
      )!,
      attemptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_number'],
      )!,
      elapsedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_seconds'],
      )!,
      errorCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}error_count'],
      )!,
      hintNudgeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hint_nudge_count'],
      )!,
      hintExplanationCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hint_explanation_count'],
      )!,
      hintRevealCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hint_reveal_count'],
      )!,
      autoCheckEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_check_enabled'],
      )!,
      mistakeRevealEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mistake_reveal_enabled'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      cleanSolve: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}clean_solve'],
      )!,
      rankedEligible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ranked_eligible'],
      )!,
      scoreTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score_total'],
      ),
      scoreBase: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score_base'],
      ),
      accuracyMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_multiplier'],
      ),
      timeBonus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_bonus'],
      ),
      efficiencyBonus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}efficiency_bonus'],
      ),
      cleanSolveBonus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}clean_solve_bonus'],
      ),
      scoringVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scoring_version'],
      ),
      accuracyFactorsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accuracy_factors_json'],
      ),
      moveHistoryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}move_history_json'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $AttemptRowsTable createAlias(String alias) {
    return $AttemptRowsTable(attachedDatabase, alias);
  }
}

class AttemptRow extends DataClass implements Insertable<AttemptRow> {
  final String id;
  final String puzzleId;
  final bool isRetry;
  final int attemptNumber;
  final int elapsedSeconds;
  final int errorCount;
  final int hintNudgeCount;
  final int hintExplanationCount;
  final int hintRevealCount;
  final bool autoCheckEnabled;
  final bool mistakeRevealEnabled;
  final bool completed;
  final bool cleanSolve;
  final bool rankedEligible;
  final int? scoreTotal;
  final int? scoreBase;
  final double? accuracyMultiplier;
  final int? timeBonus;
  final int? efficiencyBonus;
  final int? cleanSolveBonus;
  final int? scoringVersion;
  final String? accuracyFactorsJson;
  final String moveHistoryJson;
  final DateTime startedAt;
  final DateTime? completedAt;
  const AttemptRow({
    required this.id,
    required this.puzzleId,
    required this.isRetry,
    required this.attemptNumber,
    required this.elapsedSeconds,
    required this.errorCount,
    required this.hintNudgeCount,
    required this.hintExplanationCount,
    required this.hintRevealCount,
    required this.autoCheckEnabled,
    required this.mistakeRevealEnabled,
    required this.completed,
    required this.cleanSolve,
    required this.rankedEligible,
    this.scoreTotal,
    this.scoreBase,
    this.accuracyMultiplier,
    this.timeBonus,
    this.efficiencyBonus,
    this.cleanSolveBonus,
    this.scoringVersion,
    this.accuracyFactorsJson,
    required this.moveHistoryJson,
    required this.startedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['puzzle_id'] = Variable<String>(puzzleId);
    map['is_retry'] = Variable<bool>(isRetry);
    map['attempt_number'] = Variable<int>(attemptNumber);
    map['elapsed_seconds'] = Variable<int>(elapsedSeconds);
    map['error_count'] = Variable<int>(errorCount);
    map['hint_nudge_count'] = Variable<int>(hintNudgeCount);
    map['hint_explanation_count'] = Variable<int>(hintExplanationCount);
    map['hint_reveal_count'] = Variable<int>(hintRevealCount);
    map['auto_check_enabled'] = Variable<bool>(autoCheckEnabled);
    map['mistake_reveal_enabled'] = Variable<bool>(mistakeRevealEnabled);
    map['completed'] = Variable<bool>(completed);
    map['clean_solve'] = Variable<bool>(cleanSolve);
    map['ranked_eligible'] = Variable<bool>(rankedEligible);
    if (!nullToAbsent || scoreTotal != null) {
      map['score_total'] = Variable<int>(scoreTotal);
    }
    if (!nullToAbsent || scoreBase != null) {
      map['score_base'] = Variable<int>(scoreBase);
    }
    if (!nullToAbsent || accuracyMultiplier != null) {
      map['accuracy_multiplier'] = Variable<double>(accuracyMultiplier);
    }
    if (!nullToAbsent || timeBonus != null) {
      map['time_bonus'] = Variable<int>(timeBonus);
    }
    if (!nullToAbsent || efficiencyBonus != null) {
      map['efficiency_bonus'] = Variable<int>(efficiencyBonus);
    }
    if (!nullToAbsent || cleanSolveBonus != null) {
      map['clean_solve_bonus'] = Variable<int>(cleanSolveBonus);
    }
    if (!nullToAbsent || scoringVersion != null) {
      map['scoring_version'] = Variable<int>(scoringVersion);
    }
    if (!nullToAbsent || accuracyFactorsJson != null) {
      map['accuracy_factors_json'] = Variable<String>(accuracyFactorsJson);
    }
    map['move_history_json'] = Variable<String>(moveHistoryJson);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  AttemptRowsCompanion toCompanion(bool nullToAbsent) {
    return AttemptRowsCompanion(
      id: Value(id),
      puzzleId: Value(puzzleId),
      isRetry: Value(isRetry),
      attemptNumber: Value(attemptNumber),
      elapsedSeconds: Value(elapsedSeconds),
      errorCount: Value(errorCount),
      hintNudgeCount: Value(hintNudgeCount),
      hintExplanationCount: Value(hintExplanationCount),
      hintRevealCount: Value(hintRevealCount),
      autoCheckEnabled: Value(autoCheckEnabled),
      mistakeRevealEnabled: Value(mistakeRevealEnabled),
      completed: Value(completed),
      cleanSolve: Value(cleanSolve),
      rankedEligible: Value(rankedEligible),
      scoreTotal: scoreTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(scoreTotal),
      scoreBase: scoreBase == null && nullToAbsent
          ? const Value.absent()
          : Value(scoreBase),
      accuracyMultiplier: accuracyMultiplier == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracyMultiplier),
      timeBonus: timeBonus == null && nullToAbsent
          ? const Value.absent()
          : Value(timeBonus),
      efficiencyBonus: efficiencyBonus == null && nullToAbsent
          ? const Value.absent()
          : Value(efficiencyBonus),
      cleanSolveBonus: cleanSolveBonus == null && nullToAbsent
          ? const Value.absent()
          : Value(cleanSolveBonus),
      scoringVersion: scoringVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(scoringVersion),
      accuracyFactorsJson: accuracyFactorsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracyFactorsJson),
      moveHistoryJson: Value(moveHistoryJson),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory AttemptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttemptRow(
      id: serializer.fromJson<String>(json['id']),
      puzzleId: serializer.fromJson<String>(json['puzzleId']),
      isRetry: serializer.fromJson<bool>(json['isRetry']),
      attemptNumber: serializer.fromJson<int>(json['attemptNumber']),
      elapsedSeconds: serializer.fromJson<int>(json['elapsedSeconds']),
      errorCount: serializer.fromJson<int>(json['errorCount']),
      hintNudgeCount: serializer.fromJson<int>(json['hintNudgeCount']),
      hintExplanationCount: serializer.fromJson<int>(
        json['hintExplanationCount'],
      ),
      hintRevealCount: serializer.fromJson<int>(json['hintRevealCount']),
      autoCheckEnabled: serializer.fromJson<bool>(json['autoCheckEnabled']),
      mistakeRevealEnabled: serializer.fromJson<bool>(
        json['mistakeRevealEnabled'],
      ),
      completed: serializer.fromJson<bool>(json['completed']),
      cleanSolve: serializer.fromJson<bool>(json['cleanSolve']),
      rankedEligible: serializer.fromJson<bool>(json['rankedEligible']),
      scoreTotal: serializer.fromJson<int?>(json['scoreTotal']),
      scoreBase: serializer.fromJson<int?>(json['scoreBase']),
      accuracyMultiplier: serializer.fromJson<double?>(
        json['accuracyMultiplier'],
      ),
      timeBonus: serializer.fromJson<int?>(json['timeBonus']),
      efficiencyBonus: serializer.fromJson<int?>(json['efficiencyBonus']),
      cleanSolveBonus: serializer.fromJson<int?>(json['cleanSolveBonus']),
      scoringVersion: serializer.fromJson<int?>(json['scoringVersion']),
      accuracyFactorsJson: serializer.fromJson<String?>(
        json['accuracyFactorsJson'],
      ),
      moveHistoryJson: serializer.fromJson<String>(json['moveHistoryJson']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'puzzleId': serializer.toJson<String>(puzzleId),
      'isRetry': serializer.toJson<bool>(isRetry),
      'attemptNumber': serializer.toJson<int>(attemptNumber),
      'elapsedSeconds': serializer.toJson<int>(elapsedSeconds),
      'errorCount': serializer.toJson<int>(errorCount),
      'hintNudgeCount': serializer.toJson<int>(hintNudgeCount),
      'hintExplanationCount': serializer.toJson<int>(hintExplanationCount),
      'hintRevealCount': serializer.toJson<int>(hintRevealCount),
      'autoCheckEnabled': serializer.toJson<bool>(autoCheckEnabled),
      'mistakeRevealEnabled': serializer.toJson<bool>(mistakeRevealEnabled),
      'completed': serializer.toJson<bool>(completed),
      'cleanSolve': serializer.toJson<bool>(cleanSolve),
      'rankedEligible': serializer.toJson<bool>(rankedEligible),
      'scoreTotal': serializer.toJson<int?>(scoreTotal),
      'scoreBase': serializer.toJson<int?>(scoreBase),
      'accuracyMultiplier': serializer.toJson<double?>(accuracyMultiplier),
      'timeBonus': serializer.toJson<int?>(timeBonus),
      'efficiencyBonus': serializer.toJson<int?>(efficiencyBonus),
      'cleanSolveBonus': serializer.toJson<int?>(cleanSolveBonus),
      'scoringVersion': serializer.toJson<int?>(scoringVersion),
      'accuracyFactorsJson': serializer.toJson<String?>(accuracyFactorsJson),
      'moveHistoryJson': serializer.toJson<String>(moveHistoryJson),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  AttemptRow copyWith({
    String? id,
    String? puzzleId,
    bool? isRetry,
    int? attemptNumber,
    int? elapsedSeconds,
    int? errorCount,
    int? hintNudgeCount,
    int? hintExplanationCount,
    int? hintRevealCount,
    bool? autoCheckEnabled,
    bool? mistakeRevealEnabled,
    bool? completed,
    bool? cleanSolve,
    bool? rankedEligible,
    Value<int?> scoreTotal = const Value.absent(),
    Value<int?> scoreBase = const Value.absent(),
    Value<double?> accuracyMultiplier = const Value.absent(),
    Value<int?> timeBonus = const Value.absent(),
    Value<int?> efficiencyBonus = const Value.absent(),
    Value<int?> cleanSolveBonus = const Value.absent(),
    Value<int?> scoringVersion = const Value.absent(),
    Value<String?> accuracyFactorsJson = const Value.absent(),
    String? moveHistoryJson,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => AttemptRow(
    id: id ?? this.id,
    puzzleId: puzzleId ?? this.puzzleId,
    isRetry: isRetry ?? this.isRetry,
    attemptNumber: attemptNumber ?? this.attemptNumber,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    errorCount: errorCount ?? this.errorCount,
    hintNudgeCount: hintNudgeCount ?? this.hintNudgeCount,
    hintExplanationCount: hintExplanationCount ?? this.hintExplanationCount,
    hintRevealCount: hintRevealCount ?? this.hintRevealCount,
    autoCheckEnabled: autoCheckEnabled ?? this.autoCheckEnabled,
    mistakeRevealEnabled: mistakeRevealEnabled ?? this.mistakeRevealEnabled,
    completed: completed ?? this.completed,
    cleanSolve: cleanSolve ?? this.cleanSolve,
    rankedEligible: rankedEligible ?? this.rankedEligible,
    scoreTotal: scoreTotal.present ? scoreTotal.value : this.scoreTotal,
    scoreBase: scoreBase.present ? scoreBase.value : this.scoreBase,
    accuracyMultiplier: accuracyMultiplier.present
        ? accuracyMultiplier.value
        : this.accuracyMultiplier,
    timeBonus: timeBonus.present ? timeBonus.value : this.timeBonus,
    efficiencyBonus: efficiencyBonus.present
        ? efficiencyBonus.value
        : this.efficiencyBonus,
    cleanSolveBonus: cleanSolveBonus.present
        ? cleanSolveBonus.value
        : this.cleanSolveBonus,
    scoringVersion: scoringVersion.present
        ? scoringVersion.value
        : this.scoringVersion,
    accuracyFactorsJson: accuracyFactorsJson.present
        ? accuracyFactorsJson.value
        : this.accuracyFactorsJson,
    moveHistoryJson: moveHistoryJson ?? this.moveHistoryJson,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  AttemptRow copyWithCompanion(AttemptRowsCompanion data) {
    return AttemptRow(
      id: data.id.present ? data.id.value : this.id,
      puzzleId: data.puzzleId.present ? data.puzzleId.value : this.puzzleId,
      isRetry: data.isRetry.present ? data.isRetry.value : this.isRetry,
      attemptNumber: data.attemptNumber.present
          ? data.attemptNumber.value
          : this.attemptNumber,
      elapsedSeconds: data.elapsedSeconds.present
          ? data.elapsedSeconds.value
          : this.elapsedSeconds,
      errorCount: data.errorCount.present
          ? data.errorCount.value
          : this.errorCount,
      hintNudgeCount: data.hintNudgeCount.present
          ? data.hintNudgeCount.value
          : this.hintNudgeCount,
      hintExplanationCount: data.hintExplanationCount.present
          ? data.hintExplanationCount.value
          : this.hintExplanationCount,
      hintRevealCount: data.hintRevealCount.present
          ? data.hintRevealCount.value
          : this.hintRevealCount,
      autoCheckEnabled: data.autoCheckEnabled.present
          ? data.autoCheckEnabled.value
          : this.autoCheckEnabled,
      mistakeRevealEnabled: data.mistakeRevealEnabled.present
          ? data.mistakeRevealEnabled.value
          : this.mistakeRevealEnabled,
      completed: data.completed.present ? data.completed.value : this.completed,
      cleanSolve: data.cleanSolve.present
          ? data.cleanSolve.value
          : this.cleanSolve,
      rankedEligible: data.rankedEligible.present
          ? data.rankedEligible.value
          : this.rankedEligible,
      scoreTotal: data.scoreTotal.present
          ? data.scoreTotal.value
          : this.scoreTotal,
      scoreBase: data.scoreBase.present ? data.scoreBase.value : this.scoreBase,
      accuracyMultiplier: data.accuracyMultiplier.present
          ? data.accuracyMultiplier.value
          : this.accuracyMultiplier,
      timeBonus: data.timeBonus.present ? data.timeBonus.value : this.timeBonus,
      efficiencyBonus: data.efficiencyBonus.present
          ? data.efficiencyBonus.value
          : this.efficiencyBonus,
      cleanSolveBonus: data.cleanSolveBonus.present
          ? data.cleanSolveBonus.value
          : this.cleanSolveBonus,
      scoringVersion: data.scoringVersion.present
          ? data.scoringVersion.value
          : this.scoringVersion,
      accuracyFactorsJson: data.accuracyFactorsJson.present
          ? data.accuracyFactorsJson.value
          : this.accuracyFactorsJson,
      moveHistoryJson: data.moveHistoryJson.present
          ? data.moveHistoryJson.value
          : this.moveHistoryJson,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttemptRow(')
          ..write('id: $id, ')
          ..write('puzzleId: $puzzleId, ')
          ..write('isRetry: $isRetry, ')
          ..write('attemptNumber: $attemptNumber, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('errorCount: $errorCount, ')
          ..write('hintNudgeCount: $hintNudgeCount, ')
          ..write('hintExplanationCount: $hintExplanationCount, ')
          ..write('hintRevealCount: $hintRevealCount, ')
          ..write('autoCheckEnabled: $autoCheckEnabled, ')
          ..write('mistakeRevealEnabled: $mistakeRevealEnabled, ')
          ..write('completed: $completed, ')
          ..write('cleanSolve: $cleanSolve, ')
          ..write('rankedEligible: $rankedEligible, ')
          ..write('scoreTotal: $scoreTotal, ')
          ..write('scoreBase: $scoreBase, ')
          ..write('accuracyMultiplier: $accuracyMultiplier, ')
          ..write('timeBonus: $timeBonus, ')
          ..write('efficiencyBonus: $efficiencyBonus, ')
          ..write('cleanSolveBonus: $cleanSolveBonus, ')
          ..write('scoringVersion: $scoringVersion, ')
          ..write('accuracyFactorsJson: $accuracyFactorsJson, ')
          ..write('moveHistoryJson: $moveHistoryJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    puzzleId,
    isRetry,
    attemptNumber,
    elapsedSeconds,
    errorCount,
    hintNudgeCount,
    hintExplanationCount,
    hintRevealCount,
    autoCheckEnabled,
    mistakeRevealEnabled,
    completed,
    cleanSolve,
    rankedEligible,
    scoreTotal,
    scoreBase,
    accuracyMultiplier,
    timeBonus,
    efficiencyBonus,
    cleanSolveBonus,
    scoringVersion,
    accuracyFactorsJson,
    moveHistoryJson,
    startedAt,
    completedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttemptRow &&
          other.id == this.id &&
          other.puzzleId == this.puzzleId &&
          other.isRetry == this.isRetry &&
          other.attemptNumber == this.attemptNumber &&
          other.elapsedSeconds == this.elapsedSeconds &&
          other.errorCount == this.errorCount &&
          other.hintNudgeCount == this.hintNudgeCount &&
          other.hintExplanationCount == this.hintExplanationCount &&
          other.hintRevealCount == this.hintRevealCount &&
          other.autoCheckEnabled == this.autoCheckEnabled &&
          other.mistakeRevealEnabled == this.mistakeRevealEnabled &&
          other.completed == this.completed &&
          other.cleanSolve == this.cleanSolve &&
          other.rankedEligible == this.rankedEligible &&
          other.scoreTotal == this.scoreTotal &&
          other.scoreBase == this.scoreBase &&
          other.accuracyMultiplier == this.accuracyMultiplier &&
          other.timeBonus == this.timeBonus &&
          other.efficiencyBonus == this.efficiencyBonus &&
          other.cleanSolveBonus == this.cleanSolveBonus &&
          other.scoringVersion == this.scoringVersion &&
          other.accuracyFactorsJson == this.accuracyFactorsJson &&
          other.moveHistoryJson == this.moveHistoryJson &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class AttemptRowsCompanion extends UpdateCompanion<AttemptRow> {
  final Value<String> id;
  final Value<String> puzzleId;
  final Value<bool> isRetry;
  final Value<int> attemptNumber;
  final Value<int> elapsedSeconds;
  final Value<int> errorCount;
  final Value<int> hintNudgeCount;
  final Value<int> hintExplanationCount;
  final Value<int> hintRevealCount;
  final Value<bool> autoCheckEnabled;
  final Value<bool> mistakeRevealEnabled;
  final Value<bool> completed;
  final Value<bool> cleanSolve;
  final Value<bool> rankedEligible;
  final Value<int?> scoreTotal;
  final Value<int?> scoreBase;
  final Value<double?> accuracyMultiplier;
  final Value<int?> timeBonus;
  final Value<int?> efficiencyBonus;
  final Value<int?> cleanSolveBonus;
  final Value<int?> scoringVersion;
  final Value<String?> accuracyFactorsJson;
  final Value<String> moveHistoryJson;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const AttemptRowsCompanion({
    this.id = const Value.absent(),
    this.puzzleId = const Value.absent(),
    this.isRetry = const Value.absent(),
    this.attemptNumber = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.errorCount = const Value.absent(),
    this.hintNudgeCount = const Value.absent(),
    this.hintExplanationCount = const Value.absent(),
    this.hintRevealCount = const Value.absent(),
    this.autoCheckEnabled = const Value.absent(),
    this.mistakeRevealEnabled = const Value.absent(),
    this.completed = const Value.absent(),
    this.cleanSolve = const Value.absent(),
    this.rankedEligible = const Value.absent(),
    this.scoreTotal = const Value.absent(),
    this.scoreBase = const Value.absent(),
    this.accuracyMultiplier = const Value.absent(),
    this.timeBonus = const Value.absent(),
    this.efficiencyBonus = const Value.absent(),
    this.cleanSolveBonus = const Value.absent(),
    this.scoringVersion = const Value.absent(),
    this.accuracyFactorsJson = const Value.absent(),
    this.moveHistoryJson = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttemptRowsCompanion.insert({
    required String id,
    required String puzzleId,
    this.isRetry = const Value.absent(),
    required int attemptNumber,
    required int elapsedSeconds,
    required int errorCount,
    required int hintNudgeCount,
    required int hintExplanationCount,
    required int hintRevealCount,
    required bool autoCheckEnabled,
    required bool mistakeRevealEnabled,
    required bool completed,
    required bool cleanSolve,
    required bool rankedEligible,
    this.scoreTotal = const Value.absent(),
    this.scoreBase = const Value.absent(),
    this.accuracyMultiplier = const Value.absent(),
    this.timeBonus = const Value.absent(),
    this.efficiencyBonus = const Value.absent(),
    this.cleanSolveBonus = const Value.absent(),
    this.scoringVersion = const Value.absent(),
    this.accuracyFactorsJson = const Value.absent(),
    required String moveHistoryJson,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       puzzleId = Value(puzzleId),
       attemptNumber = Value(attemptNumber),
       elapsedSeconds = Value(elapsedSeconds),
       errorCount = Value(errorCount),
       hintNudgeCount = Value(hintNudgeCount),
       hintExplanationCount = Value(hintExplanationCount),
       hintRevealCount = Value(hintRevealCount),
       autoCheckEnabled = Value(autoCheckEnabled),
       mistakeRevealEnabled = Value(mistakeRevealEnabled),
       completed = Value(completed),
       cleanSolve = Value(cleanSolve),
       rankedEligible = Value(rankedEligible),
       moveHistoryJson = Value(moveHistoryJson),
       startedAt = Value(startedAt);
  static Insertable<AttemptRow> custom({
    Expression<String>? id,
    Expression<String>? puzzleId,
    Expression<bool>? isRetry,
    Expression<int>? attemptNumber,
    Expression<int>? elapsedSeconds,
    Expression<int>? errorCount,
    Expression<int>? hintNudgeCount,
    Expression<int>? hintExplanationCount,
    Expression<int>? hintRevealCount,
    Expression<bool>? autoCheckEnabled,
    Expression<bool>? mistakeRevealEnabled,
    Expression<bool>? completed,
    Expression<bool>? cleanSolve,
    Expression<bool>? rankedEligible,
    Expression<int>? scoreTotal,
    Expression<int>? scoreBase,
    Expression<double>? accuracyMultiplier,
    Expression<int>? timeBonus,
    Expression<int>? efficiencyBonus,
    Expression<int>? cleanSolveBonus,
    Expression<int>? scoringVersion,
    Expression<String>? accuracyFactorsJson,
    Expression<String>? moveHistoryJson,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (puzzleId != null) 'puzzle_id': puzzleId,
      if (isRetry != null) 'is_retry': isRetry,
      if (attemptNumber != null) 'attempt_number': attemptNumber,
      if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
      if (errorCount != null) 'error_count': errorCount,
      if (hintNudgeCount != null) 'hint_nudge_count': hintNudgeCount,
      if (hintExplanationCount != null)
        'hint_explanation_count': hintExplanationCount,
      if (hintRevealCount != null) 'hint_reveal_count': hintRevealCount,
      if (autoCheckEnabled != null) 'auto_check_enabled': autoCheckEnabled,
      if (mistakeRevealEnabled != null)
        'mistake_reveal_enabled': mistakeRevealEnabled,
      if (completed != null) 'completed': completed,
      if (cleanSolve != null) 'clean_solve': cleanSolve,
      if (rankedEligible != null) 'ranked_eligible': rankedEligible,
      if (scoreTotal != null) 'score_total': scoreTotal,
      if (scoreBase != null) 'score_base': scoreBase,
      if (accuracyMultiplier != null) 'accuracy_multiplier': accuracyMultiplier,
      if (timeBonus != null) 'time_bonus': timeBonus,
      if (efficiencyBonus != null) 'efficiency_bonus': efficiencyBonus,
      if (cleanSolveBonus != null) 'clean_solve_bonus': cleanSolveBonus,
      if (scoringVersion != null) 'scoring_version': scoringVersion,
      if (accuracyFactorsJson != null)
        'accuracy_factors_json': accuracyFactorsJson,
      if (moveHistoryJson != null) 'move_history_json': moveHistoryJson,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttemptRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? puzzleId,
    Value<bool>? isRetry,
    Value<int>? attemptNumber,
    Value<int>? elapsedSeconds,
    Value<int>? errorCount,
    Value<int>? hintNudgeCount,
    Value<int>? hintExplanationCount,
    Value<int>? hintRevealCount,
    Value<bool>? autoCheckEnabled,
    Value<bool>? mistakeRevealEnabled,
    Value<bool>? completed,
    Value<bool>? cleanSolve,
    Value<bool>? rankedEligible,
    Value<int?>? scoreTotal,
    Value<int?>? scoreBase,
    Value<double?>? accuracyMultiplier,
    Value<int?>? timeBonus,
    Value<int?>? efficiencyBonus,
    Value<int?>? cleanSolveBonus,
    Value<int?>? scoringVersion,
    Value<String?>? accuracyFactorsJson,
    Value<String>? moveHistoryJson,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return AttemptRowsCompanion(
      id: id ?? this.id,
      puzzleId: puzzleId ?? this.puzzleId,
      isRetry: isRetry ?? this.isRetry,
      attemptNumber: attemptNumber ?? this.attemptNumber,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      errorCount: errorCount ?? this.errorCount,
      hintNudgeCount: hintNudgeCount ?? this.hintNudgeCount,
      hintExplanationCount: hintExplanationCount ?? this.hintExplanationCount,
      hintRevealCount: hintRevealCount ?? this.hintRevealCount,
      autoCheckEnabled: autoCheckEnabled ?? this.autoCheckEnabled,
      mistakeRevealEnabled: mistakeRevealEnabled ?? this.mistakeRevealEnabled,
      completed: completed ?? this.completed,
      cleanSolve: cleanSolve ?? this.cleanSolve,
      rankedEligible: rankedEligible ?? this.rankedEligible,
      scoreTotal: scoreTotal ?? this.scoreTotal,
      scoreBase: scoreBase ?? this.scoreBase,
      accuracyMultiplier: accuracyMultiplier ?? this.accuracyMultiplier,
      timeBonus: timeBonus ?? this.timeBonus,
      efficiencyBonus: efficiencyBonus ?? this.efficiencyBonus,
      cleanSolveBonus: cleanSolveBonus ?? this.cleanSolveBonus,
      scoringVersion: scoringVersion ?? this.scoringVersion,
      accuracyFactorsJson: accuracyFactorsJson ?? this.accuracyFactorsJson,
      moveHistoryJson: moveHistoryJson ?? this.moveHistoryJson,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (puzzleId.present) {
      map['puzzle_id'] = Variable<String>(puzzleId.value);
    }
    if (isRetry.present) {
      map['is_retry'] = Variable<bool>(isRetry.value);
    }
    if (attemptNumber.present) {
      map['attempt_number'] = Variable<int>(attemptNumber.value);
    }
    if (elapsedSeconds.present) {
      map['elapsed_seconds'] = Variable<int>(elapsedSeconds.value);
    }
    if (errorCount.present) {
      map['error_count'] = Variable<int>(errorCount.value);
    }
    if (hintNudgeCount.present) {
      map['hint_nudge_count'] = Variable<int>(hintNudgeCount.value);
    }
    if (hintExplanationCount.present) {
      map['hint_explanation_count'] = Variable<int>(hintExplanationCount.value);
    }
    if (hintRevealCount.present) {
      map['hint_reveal_count'] = Variable<int>(hintRevealCount.value);
    }
    if (autoCheckEnabled.present) {
      map['auto_check_enabled'] = Variable<bool>(autoCheckEnabled.value);
    }
    if (mistakeRevealEnabled.present) {
      map['mistake_reveal_enabled'] = Variable<bool>(
        mistakeRevealEnabled.value,
      );
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (cleanSolve.present) {
      map['clean_solve'] = Variable<bool>(cleanSolve.value);
    }
    if (rankedEligible.present) {
      map['ranked_eligible'] = Variable<bool>(rankedEligible.value);
    }
    if (scoreTotal.present) {
      map['score_total'] = Variable<int>(scoreTotal.value);
    }
    if (scoreBase.present) {
      map['score_base'] = Variable<int>(scoreBase.value);
    }
    if (accuracyMultiplier.present) {
      map['accuracy_multiplier'] = Variable<double>(accuracyMultiplier.value);
    }
    if (timeBonus.present) {
      map['time_bonus'] = Variable<int>(timeBonus.value);
    }
    if (efficiencyBonus.present) {
      map['efficiency_bonus'] = Variable<int>(efficiencyBonus.value);
    }
    if (cleanSolveBonus.present) {
      map['clean_solve_bonus'] = Variable<int>(cleanSolveBonus.value);
    }
    if (scoringVersion.present) {
      map['scoring_version'] = Variable<int>(scoringVersion.value);
    }
    if (accuracyFactorsJson.present) {
      map['accuracy_factors_json'] = Variable<String>(
        accuracyFactorsJson.value,
      );
    }
    if (moveHistoryJson.present) {
      map['move_history_json'] = Variable<String>(moveHistoryJson.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttemptRowsCompanion(')
          ..write('id: $id, ')
          ..write('puzzleId: $puzzleId, ')
          ..write('isRetry: $isRetry, ')
          ..write('attemptNumber: $attemptNumber, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('errorCount: $errorCount, ')
          ..write('hintNudgeCount: $hintNudgeCount, ')
          ..write('hintExplanationCount: $hintExplanationCount, ')
          ..write('hintRevealCount: $hintRevealCount, ')
          ..write('autoCheckEnabled: $autoCheckEnabled, ')
          ..write('mistakeRevealEnabled: $mistakeRevealEnabled, ')
          ..write('completed: $completed, ')
          ..write('cleanSolve: $cleanSolve, ')
          ..write('rankedEligible: $rankedEligible, ')
          ..write('scoreTotal: $scoreTotal, ')
          ..write('scoreBase: $scoreBase, ')
          ..write('accuracyMultiplier: $accuracyMultiplier, ')
          ..write('timeBonus: $timeBonus, ')
          ..write('efficiencyBonus: $efficiencyBonus, ')
          ..write('cleanSolveBonus: $cleanSolveBonus, ')
          ..write('scoringVersion: $scoringVersion, ')
          ..write('accuracyFactorsJson: $accuracyFactorsJson, ')
          ..write('moveHistoryJson: $moveHistoryJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CurrentProgressRowsTable extends CurrentProgressRows
    with TableInfo<$CurrentProgressRowsTable, CurrentProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrentProgressRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _puzzleIdMeta = const VerificationMeta(
    'puzzleId',
  );
  @override
  late final GeneratedColumn<String> puzzleId = GeneratedColumn<String>(
    'puzzle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valuesJsonMeta = const VerificationMeta(
    'valuesJson',
  );
  @override
  late final GeneratedColumn<String> valuesJson = GeneratedColumn<String>(
    'values_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesJsonMeta = const VerificationMeta(
    'notesJson',
  );
  @override
  late final GeneratedColumn<String> notesJson = GeneratedColumn<String>(
    'notes_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elapsedSecondsMeta = const VerificationMeta(
    'elapsedSeconds',
  );
  @override
  late final GeneratedColumn<int> elapsedSeconds = GeneratedColumn<int>(
    'elapsed_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    puzzleId,
    valuesJson,
    notesJson,
    elapsedSeconds,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'current_progress_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<CurrentProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('puzzle_id')) {
      context.handle(
        _puzzleIdMeta,
        puzzleId.isAcceptableOrUnknown(data['puzzle_id']!, _puzzleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_puzzleIdMeta);
    }
    if (data.containsKey('values_json')) {
      context.handle(
        _valuesJsonMeta,
        valuesJson.isAcceptableOrUnknown(data['values_json']!, _valuesJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valuesJsonMeta);
    }
    if (data.containsKey('notes_json')) {
      context.handle(
        _notesJsonMeta,
        notesJson.isAcceptableOrUnknown(data['notes_json']!, _notesJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_notesJsonMeta);
    }
    if (data.containsKey('elapsed_seconds')) {
      context.handle(
        _elapsedSecondsMeta,
        elapsedSeconds.isAcceptableOrUnknown(
          data['elapsed_seconds']!,
          _elapsedSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_elapsedSecondsMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {puzzleId};
  @override
  CurrentProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurrentProgressRow(
      puzzleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}puzzle_id'],
      )!,
      valuesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}values_json'],
      )!,
      notesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes_json'],
      )!,
      elapsedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_seconds'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CurrentProgressRowsTable createAlias(String alias) {
    return $CurrentProgressRowsTable(attachedDatabase, alias);
  }
}

class CurrentProgressRow extends DataClass
    implements Insertable<CurrentProgressRow> {
  final String puzzleId;
  final String valuesJson;
  final String notesJson;
  final int elapsedSeconds;
  final DateTime updatedAt;
  const CurrentProgressRow({
    required this.puzzleId,
    required this.valuesJson,
    required this.notesJson,
    required this.elapsedSeconds,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['puzzle_id'] = Variable<String>(puzzleId);
    map['values_json'] = Variable<String>(valuesJson);
    map['notes_json'] = Variable<String>(notesJson);
    map['elapsed_seconds'] = Variable<int>(elapsedSeconds);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CurrentProgressRowsCompanion toCompanion(bool nullToAbsent) {
    return CurrentProgressRowsCompanion(
      puzzleId: Value(puzzleId),
      valuesJson: Value(valuesJson),
      notesJson: Value(notesJson),
      elapsedSeconds: Value(elapsedSeconds),
      updatedAt: Value(updatedAt),
    );
  }

  factory CurrentProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurrentProgressRow(
      puzzleId: serializer.fromJson<String>(json['puzzleId']),
      valuesJson: serializer.fromJson<String>(json['valuesJson']),
      notesJson: serializer.fromJson<String>(json['notesJson']),
      elapsedSeconds: serializer.fromJson<int>(json['elapsedSeconds']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'puzzleId': serializer.toJson<String>(puzzleId),
      'valuesJson': serializer.toJson<String>(valuesJson),
      'notesJson': serializer.toJson<String>(notesJson),
      'elapsedSeconds': serializer.toJson<int>(elapsedSeconds),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CurrentProgressRow copyWith({
    String? puzzleId,
    String? valuesJson,
    String? notesJson,
    int? elapsedSeconds,
    DateTime? updatedAt,
  }) => CurrentProgressRow(
    puzzleId: puzzleId ?? this.puzzleId,
    valuesJson: valuesJson ?? this.valuesJson,
    notesJson: notesJson ?? this.notesJson,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CurrentProgressRow copyWithCompanion(CurrentProgressRowsCompanion data) {
    return CurrentProgressRow(
      puzzleId: data.puzzleId.present ? data.puzzleId.value : this.puzzleId,
      valuesJson: data.valuesJson.present
          ? data.valuesJson.value
          : this.valuesJson,
      notesJson: data.notesJson.present ? data.notesJson.value : this.notesJson,
      elapsedSeconds: data.elapsedSeconds.present
          ? data.elapsedSeconds.value
          : this.elapsedSeconds,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurrentProgressRow(')
          ..write('puzzleId: $puzzleId, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('notesJson: $notesJson, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(puzzleId, valuesJson, notesJson, elapsedSeconds, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurrentProgressRow &&
          other.puzzleId == this.puzzleId &&
          other.valuesJson == this.valuesJson &&
          other.notesJson == this.notesJson &&
          other.elapsedSeconds == this.elapsedSeconds &&
          other.updatedAt == this.updatedAt);
}

class CurrentProgressRowsCompanion extends UpdateCompanion<CurrentProgressRow> {
  final Value<String> puzzleId;
  final Value<String> valuesJson;
  final Value<String> notesJson;
  final Value<int> elapsedSeconds;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CurrentProgressRowsCompanion({
    this.puzzleId = const Value.absent(),
    this.valuesJson = const Value.absent(),
    this.notesJson = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurrentProgressRowsCompanion.insert({
    required String puzzleId,
    required String valuesJson,
    required String notesJson,
    required int elapsedSeconds,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : puzzleId = Value(puzzleId),
       valuesJson = Value(valuesJson),
       notesJson = Value(notesJson),
       elapsedSeconds = Value(elapsedSeconds),
       updatedAt = Value(updatedAt);
  static Insertable<CurrentProgressRow> custom({
    Expression<String>? puzzleId,
    Expression<String>? valuesJson,
    Expression<String>? notesJson,
    Expression<int>? elapsedSeconds,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (puzzleId != null) 'puzzle_id': puzzleId,
      if (valuesJson != null) 'values_json': valuesJson,
      if (notesJson != null) 'notes_json': notesJson,
      if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurrentProgressRowsCompanion copyWith({
    Value<String>? puzzleId,
    Value<String>? valuesJson,
    Value<String>? notesJson,
    Value<int>? elapsedSeconds,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CurrentProgressRowsCompanion(
      puzzleId: puzzleId ?? this.puzzleId,
      valuesJson: valuesJson ?? this.valuesJson,
      notesJson: notesJson ?? this.notesJson,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (puzzleId.present) {
      map['puzzle_id'] = Variable<String>(puzzleId.value);
    }
    if (valuesJson.present) {
      map['values_json'] = Variable<String>(valuesJson.value);
    }
    if (notesJson.present) {
      map['notes_json'] = Variable<String>(notesJson.value);
    }
    if (elapsedSeconds.present) {
      map['elapsed_seconds'] = Variable<int>(elapsedSeconds.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrentProgressRowsCompanion(')
          ..write('puzzleId: $puzzleId, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('notesJson: $notesJson, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PuzzleRowsTable puzzleRows = $PuzzleRowsTable(this);
  late final $AttemptRowsTable attemptRows = $AttemptRowsTable(this);
  late final $CurrentProgressRowsTable currentProgressRows =
      $CurrentProgressRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    puzzleRows,
    attemptRows,
    currentProgressRows,
  ];
}

typedef $$PuzzleRowsTableCreateCompanionBuilder =
    PuzzleRowsCompanion Function({
      required String id,
      required String givensJson,
      required String solutionJson,
      required String difficulty,
      required int difficultyScore,
      required int targetTimeSeconds,
      required int medianTimeSeconds,
      required String requiredTechniquesJson,
      required String solvePathJson,
      Value<bool> rankedEligible,
      Value<String?> challengeId,
      Value<int> rowid,
    });
typedef $$PuzzleRowsTableUpdateCompanionBuilder =
    PuzzleRowsCompanion Function({
      Value<String> id,
      Value<String> givensJson,
      Value<String> solutionJson,
      Value<String> difficulty,
      Value<int> difficultyScore,
      Value<int> targetTimeSeconds,
      Value<int> medianTimeSeconds,
      Value<String> requiredTechniquesJson,
      Value<String> solvePathJson,
      Value<bool> rankedEligible,
      Value<String?> challengeId,
      Value<int> rowid,
    });

class $$PuzzleRowsTableFilterComposer
    extends Composer<_$AppDatabase, $PuzzleRowsTable> {
  $$PuzzleRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get givensJson => $composableBuilder(
    column: $table.givensJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get solutionJson => $composableBuilder(
    column: $table.solutionJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficultyScore => $composableBuilder(
    column: $table.difficultyScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetTimeSeconds => $composableBuilder(
    column: $table.targetTimeSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get medianTimeSeconds => $composableBuilder(
    column: $table.medianTimeSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requiredTechniquesJson => $composableBuilder(
    column: $table.requiredTechniquesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get solvePathJson => $composableBuilder(
    column: $table.solvePathJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rankedEligible => $composableBuilder(
    column: $table.rankedEligible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get challengeId => $composableBuilder(
    column: $table.challengeId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PuzzleRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $PuzzleRowsTable> {
  $$PuzzleRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get givensJson => $composableBuilder(
    column: $table.givensJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get solutionJson => $composableBuilder(
    column: $table.solutionJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficultyScore => $composableBuilder(
    column: $table.difficultyScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetTimeSeconds => $composableBuilder(
    column: $table.targetTimeSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get medianTimeSeconds => $composableBuilder(
    column: $table.medianTimeSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requiredTechniquesJson => $composableBuilder(
    column: $table.requiredTechniquesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get solvePathJson => $composableBuilder(
    column: $table.solvePathJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rankedEligible => $composableBuilder(
    column: $table.rankedEligible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get challengeId => $composableBuilder(
    column: $table.challengeId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PuzzleRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PuzzleRowsTable> {
  $$PuzzleRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get givensJson => $composableBuilder(
    column: $table.givensJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get solutionJson => $composableBuilder(
    column: $table.solutionJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get difficultyScore => $composableBuilder(
    column: $table.difficultyScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetTimeSeconds => $composableBuilder(
    column: $table.targetTimeSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get medianTimeSeconds => $composableBuilder(
    column: $table.medianTimeSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requiredTechniquesJson => $composableBuilder(
    column: $table.requiredTechniquesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get solvePathJson => $composableBuilder(
    column: $table.solvePathJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get rankedEligible => $composableBuilder(
    column: $table.rankedEligible,
    builder: (column) => column,
  );

  GeneratedColumn<String> get challengeId => $composableBuilder(
    column: $table.challengeId,
    builder: (column) => column,
  );
}

class $$PuzzleRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PuzzleRowsTable,
          PuzzleRow,
          $$PuzzleRowsTableFilterComposer,
          $$PuzzleRowsTableOrderingComposer,
          $$PuzzleRowsTableAnnotationComposer,
          $$PuzzleRowsTableCreateCompanionBuilder,
          $$PuzzleRowsTableUpdateCompanionBuilder,
          (
            PuzzleRow,
            BaseReferences<_$AppDatabase, $PuzzleRowsTable, PuzzleRow>,
          ),
          PuzzleRow,
          PrefetchHooks Function()
        > {
  $$PuzzleRowsTableTableManager(_$AppDatabase db, $PuzzleRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PuzzleRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PuzzleRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PuzzleRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> givensJson = const Value.absent(),
                Value<String> solutionJson = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<int> difficultyScore = const Value.absent(),
                Value<int> targetTimeSeconds = const Value.absent(),
                Value<int> medianTimeSeconds = const Value.absent(),
                Value<String> requiredTechniquesJson = const Value.absent(),
                Value<String> solvePathJson = const Value.absent(),
                Value<bool> rankedEligible = const Value.absent(),
                Value<String?> challengeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PuzzleRowsCompanion(
                id: id,
                givensJson: givensJson,
                solutionJson: solutionJson,
                difficulty: difficulty,
                difficultyScore: difficultyScore,
                targetTimeSeconds: targetTimeSeconds,
                medianTimeSeconds: medianTimeSeconds,
                requiredTechniquesJson: requiredTechniquesJson,
                solvePathJson: solvePathJson,
                rankedEligible: rankedEligible,
                challengeId: challengeId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String givensJson,
                required String solutionJson,
                required String difficulty,
                required int difficultyScore,
                required int targetTimeSeconds,
                required int medianTimeSeconds,
                required String requiredTechniquesJson,
                required String solvePathJson,
                Value<bool> rankedEligible = const Value.absent(),
                Value<String?> challengeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PuzzleRowsCompanion.insert(
                id: id,
                givensJson: givensJson,
                solutionJson: solutionJson,
                difficulty: difficulty,
                difficultyScore: difficultyScore,
                targetTimeSeconds: targetTimeSeconds,
                medianTimeSeconds: medianTimeSeconds,
                requiredTechniquesJson: requiredTechniquesJson,
                solvePathJson: solvePathJson,
                rankedEligible: rankedEligible,
                challengeId: challengeId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PuzzleRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PuzzleRowsTable,
      PuzzleRow,
      $$PuzzleRowsTableFilterComposer,
      $$PuzzleRowsTableOrderingComposer,
      $$PuzzleRowsTableAnnotationComposer,
      $$PuzzleRowsTableCreateCompanionBuilder,
      $$PuzzleRowsTableUpdateCompanionBuilder,
      (PuzzleRow, BaseReferences<_$AppDatabase, $PuzzleRowsTable, PuzzleRow>),
      PuzzleRow,
      PrefetchHooks Function()
    >;
typedef $$AttemptRowsTableCreateCompanionBuilder =
    AttemptRowsCompanion Function({
      required String id,
      required String puzzleId,
      Value<bool> isRetry,
      required int attemptNumber,
      required int elapsedSeconds,
      required int errorCount,
      required int hintNudgeCount,
      required int hintExplanationCount,
      required int hintRevealCount,
      required bool autoCheckEnabled,
      required bool mistakeRevealEnabled,
      required bool completed,
      required bool cleanSolve,
      required bool rankedEligible,
      Value<int?> scoreTotal,
      Value<int?> scoreBase,
      Value<double?> accuracyMultiplier,
      Value<int?> timeBonus,
      Value<int?> efficiencyBonus,
      Value<int?> cleanSolveBonus,
      Value<int?> scoringVersion,
      Value<String?> accuracyFactorsJson,
      required String moveHistoryJson,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$AttemptRowsTableUpdateCompanionBuilder =
    AttemptRowsCompanion Function({
      Value<String> id,
      Value<String> puzzleId,
      Value<bool> isRetry,
      Value<int> attemptNumber,
      Value<int> elapsedSeconds,
      Value<int> errorCount,
      Value<int> hintNudgeCount,
      Value<int> hintExplanationCount,
      Value<int> hintRevealCount,
      Value<bool> autoCheckEnabled,
      Value<bool> mistakeRevealEnabled,
      Value<bool> completed,
      Value<bool> cleanSolve,
      Value<bool> rankedEligible,
      Value<int?> scoreTotal,
      Value<int?> scoreBase,
      Value<double?> accuracyMultiplier,
      Value<int?> timeBonus,
      Value<int?> efficiencyBonus,
      Value<int?> cleanSolveBonus,
      Value<int?> scoringVersion,
      Value<String?> accuracyFactorsJson,
      Value<String> moveHistoryJson,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

class $$AttemptRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AttemptRowsTable> {
  $$AttemptRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get puzzleId => $composableBuilder(
    column: $table.puzzleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRetry => $composableBuilder(
    column: $table.isRetry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get errorCount => $composableBuilder(
    column: $table.errorCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hintNudgeCount => $composableBuilder(
    column: $table.hintNudgeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hintExplanationCount => $composableBuilder(
    column: $table.hintExplanationCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hintRevealCount => $composableBuilder(
    column: $table.hintRevealCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoCheckEnabled => $composableBuilder(
    column: $table.autoCheckEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mistakeRevealEnabled => $composableBuilder(
    column: $table.mistakeRevealEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cleanSolve => $composableBuilder(
    column: $table.cleanSolve,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rankedEligible => $composableBuilder(
    column: $table.rankedEligible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scoreTotal => $composableBuilder(
    column: $table.scoreTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scoreBase => $composableBuilder(
    column: $table.scoreBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyMultiplier => $composableBuilder(
    column: $table.accuracyMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeBonus => $composableBuilder(
    column: $table.timeBonus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get efficiencyBonus => $composableBuilder(
    column: $table.efficiencyBonus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cleanSolveBonus => $composableBuilder(
    column: $table.cleanSolveBonus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scoringVersion => $composableBuilder(
    column: $table.scoringVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accuracyFactorsJson => $composableBuilder(
    column: $table.accuracyFactorsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moveHistoryJson => $composableBuilder(
    column: $table.moveHistoryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttemptRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttemptRowsTable> {
  $$AttemptRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get puzzleId => $composableBuilder(
    column: $table.puzzleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRetry => $composableBuilder(
    column: $table.isRetry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get errorCount => $composableBuilder(
    column: $table.errorCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hintNudgeCount => $composableBuilder(
    column: $table.hintNudgeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hintExplanationCount => $composableBuilder(
    column: $table.hintExplanationCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hintRevealCount => $composableBuilder(
    column: $table.hintRevealCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoCheckEnabled => $composableBuilder(
    column: $table.autoCheckEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mistakeRevealEnabled => $composableBuilder(
    column: $table.mistakeRevealEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cleanSolve => $composableBuilder(
    column: $table.cleanSolve,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rankedEligible => $composableBuilder(
    column: $table.rankedEligible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scoreTotal => $composableBuilder(
    column: $table.scoreTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scoreBase => $composableBuilder(
    column: $table.scoreBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyMultiplier => $composableBuilder(
    column: $table.accuracyMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeBonus => $composableBuilder(
    column: $table.timeBonus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get efficiencyBonus => $composableBuilder(
    column: $table.efficiencyBonus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cleanSolveBonus => $composableBuilder(
    column: $table.cleanSolveBonus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scoringVersion => $composableBuilder(
    column: $table.scoringVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accuracyFactorsJson => $composableBuilder(
    column: $table.accuracyFactorsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moveHistoryJson => $composableBuilder(
    column: $table.moveHistoryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttemptRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttemptRowsTable> {
  $$AttemptRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get puzzleId =>
      $composableBuilder(column: $table.puzzleId, builder: (column) => column);

  GeneratedColumn<bool> get isRetry =>
      $composableBuilder(column: $table.isRetry, builder: (column) => column);

  GeneratedColumn<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get errorCount => $composableBuilder(
    column: $table.errorCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hintNudgeCount => $composableBuilder(
    column: $table.hintNudgeCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hintExplanationCount => $composableBuilder(
    column: $table.hintExplanationCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hintRevealCount => $composableBuilder(
    column: $table.hintRevealCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoCheckEnabled => $composableBuilder(
    column: $table.autoCheckEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mistakeRevealEnabled => $composableBuilder(
    column: $table.mistakeRevealEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<bool> get cleanSolve => $composableBuilder(
    column: $table.cleanSolve,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get rankedEligible => $composableBuilder(
    column: $table.rankedEligible,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scoreTotal => $composableBuilder(
    column: $table.scoreTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scoreBase =>
      $composableBuilder(column: $table.scoreBase, builder: (column) => column);

  GeneratedColumn<double> get accuracyMultiplier => $composableBuilder(
    column: $table.accuracyMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeBonus =>
      $composableBuilder(column: $table.timeBonus, builder: (column) => column);

  GeneratedColumn<int> get efficiencyBonus => $composableBuilder(
    column: $table.efficiencyBonus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cleanSolveBonus => $composableBuilder(
    column: $table.cleanSolveBonus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scoringVersion => $composableBuilder(
    column: $table.scoringVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accuracyFactorsJson => $composableBuilder(
    column: $table.accuracyFactorsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moveHistoryJson => $composableBuilder(
    column: $table.moveHistoryJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$AttemptRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttemptRowsTable,
          AttemptRow,
          $$AttemptRowsTableFilterComposer,
          $$AttemptRowsTableOrderingComposer,
          $$AttemptRowsTableAnnotationComposer,
          $$AttemptRowsTableCreateCompanionBuilder,
          $$AttemptRowsTableUpdateCompanionBuilder,
          (
            AttemptRow,
            BaseReferences<_$AppDatabase, $AttemptRowsTable, AttemptRow>,
          ),
          AttemptRow,
          PrefetchHooks Function()
        > {
  $$AttemptRowsTableTableManager(_$AppDatabase db, $AttemptRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttemptRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttemptRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttemptRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> puzzleId = const Value.absent(),
                Value<bool> isRetry = const Value.absent(),
                Value<int> attemptNumber = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                Value<int> errorCount = const Value.absent(),
                Value<int> hintNudgeCount = const Value.absent(),
                Value<int> hintExplanationCount = const Value.absent(),
                Value<int> hintRevealCount = const Value.absent(),
                Value<bool> autoCheckEnabled = const Value.absent(),
                Value<bool> mistakeRevealEnabled = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<bool> cleanSolve = const Value.absent(),
                Value<bool> rankedEligible = const Value.absent(),
                Value<int?> scoreTotal = const Value.absent(),
                Value<int?> scoreBase = const Value.absent(),
                Value<double?> accuracyMultiplier = const Value.absent(),
                Value<int?> timeBonus = const Value.absent(),
                Value<int?> efficiencyBonus = const Value.absent(),
                Value<int?> cleanSolveBonus = const Value.absent(),
                Value<int?> scoringVersion = const Value.absent(),
                Value<String?> accuracyFactorsJson = const Value.absent(),
                Value<String> moveHistoryJson = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttemptRowsCompanion(
                id: id,
                puzzleId: puzzleId,
                isRetry: isRetry,
                attemptNumber: attemptNumber,
                elapsedSeconds: elapsedSeconds,
                errorCount: errorCount,
                hintNudgeCount: hintNudgeCount,
                hintExplanationCount: hintExplanationCount,
                hintRevealCount: hintRevealCount,
                autoCheckEnabled: autoCheckEnabled,
                mistakeRevealEnabled: mistakeRevealEnabled,
                completed: completed,
                cleanSolve: cleanSolve,
                rankedEligible: rankedEligible,
                scoreTotal: scoreTotal,
                scoreBase: scoreBase,
                accuracyMultiplier: accuracyMultiplier,
                timeBonus: timeBonus,
                efficiencyBonus: efficiencyBonus,
                cleanSolveBonus: cleanSolveBonus,
                scoringVersion: scoringVersion,
                accuracyFactorsJson: accuracyFactorsJson,
                moveHistoryJson: moveHistoryJson,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String puzzleId,
                Value<bool> isRetry = const Value.absent(),
                required int attemptNumber,
                required int elapsedSeconds,
                required int errorCount,
                required int hintNudgeCount,
                required int hintExplanationCount,
                required int hintRevealCount,
                required bool autoCheckEnabled,
                required bool mistakeRevealEnabled,
                required bool completed,
                required bool cleanSolve,
                required bool rankedEligible,
                Value<int?> scoreTotal = const Value.absent(),
                Value<int?> scoreBase = const Value.absent(),
                Value<double?> accuracyMultiplier = const Value.absent(),
                Value<int?> timeBonus = const Value.absent(),
                Value<int?> efficiencyBonus = const Value.absent(),
                Value<int?> cleanSolveBonus = const Value.absent(),
                Value<int?> scoringVersion = const Value.absent(),
                Value<String?> accuracyFactorsJson = const Value.absent(),
                required String moveHistoryJson,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttemptRowsCompanion.insert(
                id: id,
                puzzleId: puzzleId,
                isRetry: isRetry,
                attemptNumber: attemptNumber,
                elapsedSeconds: elapsedSeconds,
                errorCount: errorCount,
                hintNudgeCount: hintNudgeCount,
                hintExplanationCount: hintExplanationCount,
                hintRevealCount: hintRevealCount,
                autoCheckEnabled: autoCheckEnabled,
                mistakeRevealEnabled: mistakeRevealEnabled,
                completed: completed,
                cleanSolve: cleanSolve,
                rankedEligible: rankedEligible,
                scoreTotal: scoreTotal,
                scoreBase: scoreBase,
                accuracyMultiplier: accuracyMultiplier,
                timeBonus: timeBonus,
                efficiencyBonus: efficiencyBonus,
                cleanSolveBonus: cleanSolveBonus,
                scoringVersion: scoringVersion,
                accuracyFactorsJson: accuracyFactorsJson,
                moveHistoryJson: moveHistoryJson,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttemptRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttemptRowsTable,
      AttemptRow,
      $$AttemptRowsTableFilterComposer,
      $$AttemptRowsTableOrderingComposer,
      $$AttemptRowsTableAnnotationComposer,
      $$AttemptRowsTableCreateCompanionBuilder,
      $$AttemptRowsTableUpdateCompanionBuilder,
      (
        AttemptRow,
        BaseReferences<_$AppDatabase, $AttemptRowsTable, AttemptRow>,
      ),
      AttemptRow,
      PrefetchHooks Function()
    >;
typedef $$CurrentProgressRowsTableCreateCompanionBuilder =
    CurrentProgressRowsCompanion Function({
      required String puzzleId,
      required String valuesJson,
      required String notesJson,
      required int elapsedSeconds,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CurrentProgressRowsTableUpdateCompanionBuilder =
    CurrentProgressRowsCompanion Function({
      Value<String> puzzleId,
      Value<String> valuesJson,
      Value<String> notesJson,
      Value<int> elapsedSeconds,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CurrentProgressRowsTableFilterComposer
    extends Composer<_$AppDatabase, $CurrentProgressRowsTable> {
  $$CurrentProgressRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get puzzleId => $composableBuilder(
    column: $table.puzzleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notesJson => $composableBuilder(
    column: $table.notesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CurrentProgressRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrentProgressRowsTable> {
  $$CurrentProgressRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get puzzleId => $composableBuilder(
    column: $table.puzzleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notesJson => $composableBuilder(
    column: $table.notesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CurrentProgressRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrentProgressRowsTable> {
  $$CurrentProgressRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get puzzleId =>
      $composableBuilder(column: $table.puzzleId, builder: (column) => column);

  GeneratedColumn<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notesJson =>
      $composableBuilder(column: $table.notesJson, builder: (column) => column);

  GeneratedColumn<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CurrentProgressRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CurrentProgressRowsTable,
          CurrentProgressRow,
          $$CurrentProgressRowsTableFilterComposer,
          $$CurrentProgressRowsTableOrderingComposer,
          $$CurrentProgressRowsTableAnnotationComposer,
          $$CurrentProgressRowsTableCreateCompanionBuilder,
          $$CurrentProgressRowsTableUpdateCompanionBuilder,
          (
            CurrentProgressRow,
            BaseReferences<
              _$AppDatabase,
              $CurrentProgressRowsTable,
              CurrentProgressRow
            >,
          ),
          CurrentProgressRow,
          PrefetchHooks Function()
        > {
  $$CurrentProgressRowsTableTableManager(
    _$AppDatabase db,
    $CurrentProgressRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrentProgressRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrentProgressRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CurrentProgressRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> puzzleId = const Value.absent(),
                Value<String> valuesJson = const Value.absent(),
                Value<String> notesJson = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurrentProgressRowsCompanion(
                puzzleId: puzzleId,
                valuesJson: valuesJson,
                notesJson: notesJson,
                elapsedSeconds: elapsedSeconds,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String puzzleId,
                required String valuesJson,
                required String notesJson,
                required int elapsedSeconds,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CurrentProgressRowsCompanion.insert(
                puzzleId: puzzleId,
                valuesJson: valuesJson,
                notesJson: notesJson,
                elapsedSeconds: elapsedSeconds,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CurrentProgressRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CurrentProgressRowsTable,
      CurrentProgressRow,
      $$CurrentProgressRowsTableFilterComposer,
      $$CurrentProgressRowsTableOrderingComposer,
      $$CurrentProgressRowsTableAnnotationComposer,
      $$CurrentProgressRowsTableCreateCompanionBuilder,
      $$CurrentProgressRowsTableUpdateCompanionBuilder,
      (
        CurrentProgressRow,
        BaseReferences<
          _$AppDatabase,
          $CurrentProgressRowsTable,
          CurrentProgressRow
        >,
      ),
      CurrentProgressRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PuzzleRowsTableTableManager get puzzleRows =>
      $$PuzzleRowsTableTableManager(_db, _db.puzzleRows);
  $$AttemptRowsTableTableManager get attemptRows =>
      $$AttemptRowsTableTableManager(_db, _db.attemptRows);
  $$CurrentProgressRowsTableTableManager get currentProgressRows =>
      $$CurrentProgressRowsTableTableManager(_db, _db.currentProgressRows);
}
