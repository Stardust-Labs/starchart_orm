/// Defines the behaviour of a model when a unique constraint
/// conflict occurs during a save or update
enum OnConflictBehavior {
  /// Return the database to its previous state before the transaction
  /// containing the conflict
  rollback,

  /// Cancel the transaction entirely and throw an exception
  abort,

  /// This is the default state.  
  /// 
  /// Stop the transaction when the conflict occurs and throw an 
  /// exception
  fail,

  /// Ignore the element of the transaction that would cause a
  /// conflict and continue with the rest of the transaction
  ignore,

  /// Replace the conflicting record with the new record
  replace
}
