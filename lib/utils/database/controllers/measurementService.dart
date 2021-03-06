import 'package:bloodpressurelog/utils/database/controllers/serviceInterface.dart';
import 'package:bloodpressurelog/utils/database/dbProvider.dart';
import 'package:bloodpressurelog/utils/database/models/measurement.dart';

class MeasurementService implements ServiceInterface<Measurement> {
  DBProvider dbProvider;

  MeasurementService() {
    this.dbProvider = new DBProvider();
  }

  @override
  Future<List<Measurement>> readAll() async {
    try {
      var connection = await this.dbProvider.database;

      var queryResult = await connection.query(Measurement.tableName,
          where: "dateDelete IS NULL");

      List<Measurement> listResult = queryResult.isNotEmpty
          ? queryResult.map((e) => Measurement.fromJson(e)).toList()
          : [];

      return listResult;
    } catch (ex) {
      print(ex);
      return <Measurement>[];
    }
  }

  Future<List<Measurement>> readFilter(int action) async {
    try {
      var connection = await this.dbProvider.database;

      var queryResult;

      if (action == 0) {
        queryResult = await connection.query(Measurement.tableName,
            where:
                "DATE(dateTimeMeasurement) >= DATE('now', 'weekday 0', '-7 days') AND dateDelete IS NULL");
      } else if (action == 1) {
        queryResult = await connection.query(Measurement.tableName,
            where:
                "strftime('%m', dateTimeMeasurement) = strftime('%m', date('now')) AND dateDelete IS NULL");
      } else if (action == 2) {
        queryResult = await connection.query(Measurement.tableName,
            where:
                "strftime('%Y', dateTimeMeasurement) = strftime('%Y', date('now')) AND dateDelete IS NULL");
      } else {
        queryResult = await connection.query(Measurement.tableName,
            where: "dateDelete IS NULL");
      }

      List<Measurement> listResult = queryResult.isNotEmpty
          ? queryResult
              .map<Measurement>((e) => Measurement.fromJson(e))
              .toList()
          : [];

      return listResult;
    } catch (ex) {
      print(ex);
      return <Measurement>[];
    }
  }

  @override
  Future<Measurement> readByID(int id) async {
    try {
      var connection = await this.dbProvider.database;

      var queryResult = await connection.query(Measurement.tableName,
          where: " idMeasurement = ? AND dateDelete IS NULL", whereArgs: [id]);

      List<Measurement> listResult = queryResult.isNotEmpty
          ? queryResult.map((e) => Measurement.fromJson(e)).toList()
          : [];

      return listResult.isNotEmpty ? listResult.first : null;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  @override
  Future<bool> insert(Measurement data) async {
    try {
      var connection = await this.dbProvider.database;

      data.dateInsert = DateTime.now();
      data.dateUpdate = null;
      data.dateDelete = null;

      var queryResult =
          await connection.insert(Measurement.tableName, data.toJson());

      return queryResult > 0;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  Future<bool> insertBulk(List<Measurement> toInsert) async {
    try {
      var connection = await this.dbProvider.database;

      toInsert.forEach((data) async {
        data.idMeasurement = null;
        data.dateInsert = DateTime.now();
        data.dateUpdate = null;
        data.dateDelete = null;

        await connection.insert(Measurement.tableName, data.toJson());
      });

      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  @override
  Future<bool> update(Measurement data) async {
    try {
      var connection = await this.dbProvider.database;

      data.dateUpdate = DateTime.now();
      data.dateDelete = null;

      var queryResult = await connection.update(
          Measurement.tableName, data.toJson(),
          where: "idMeasurement = ?", whereArgs: [data.idMeasurement]);

      return queryResult > 0;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  @override
  Future<bool> delete(Measurement data) async {
    try {
      var connection = await this.dbProvider.database;

      data.dateDelete = DateTime.now();

      var queryResult = await connection.update(
          Measurement.tableName, data.toJson(),
          where: "idMeasurement = ?", whereArgs: [data.idMeasurement]);

      return queryResult > 0;
    } catch (ex) {
      print(ex);
      return false;
    }
  }
}
