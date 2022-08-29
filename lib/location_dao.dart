import 'package:background_geolocation_sample/location.dart';
import 'package:floor/floor.dart';

@dao
abstract class LocationDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(Location location);

  @Query('SELECT * FROM track_points ORDER BY id DESC LIMIT 1')
  Future<Location?> getLastEntry();

  @Query('SELECT * FROM track_points')
  Future<List<Location>?> getAll();

  @Query('SELECT * FROM track_points WHERE isMatched == 0')
  Future<List<Location>?> getAllUnMapMatchedLocations();

  @Query('SELECT * FROM track_points WHERE isMatched == 1')
  Future<List<Location>?> getAllMapMatchedLocations();

  @Query('Delete FROM track_points')
  Future<void> clear();
}
