/// The review prompt settings used for prompt conditions.
class ReviewSettings {
  /// The number of primary actions completed.
  final int primaryActionCompletedCount;

  /// The number of secondary actions completed.
  final int secondaryActionCompletedCount;

  /// The number of times the application has been launched.
  final int applicationLaunchCount;

  /// When the application first started.
  final DateTime? firstApplicationLaunch;

  /// The number of review requested.
  final int requestCount;

  /// When the last review was requested.
  final DateTime? lastRequest;

  const ReviewSettings({
    this.primaryActionCompletedCount = 0,
    this.secondaryActionCompletedCount = 0,
    this.applicationLaunchCount = 0,
    this.firstApplicationLaunch,
    this.requestCount = 0,
    this.lastRequest,
  });

  ReviewSettings copyWith({
    int? primaryActionCompletedCount,
    int? secondaryActionCompletedCount,
    int? applicationLaunchCount,
    DateTime? firstApplicationLaunch,
    int? requestCount,
    DateTime? lastRequest,
  }) {
    return ReviewSettings(
      primaryActionCompletedCount:
          primaryActionCompletedCount ?? this.primaryActionCompletedCount,
      secondaryActionCompletedCount:
          secondaryActionCompletedCount ?? this.secondaryActionCompletedCount,
      applicationLaunchCount:
          applicationLaunchCount ?? this.applicationLaunchCount,
      firstApplicationLaunch:
          firstApplicationLaunch ?? this.firstApplicationLaunch,
      requestCount: requestCount ?? this.requestCount,
      lastRequest: lastRequest ?? this.lastRequest,
    );
  }
}
