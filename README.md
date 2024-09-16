# Review Service

This repository introduces abstractions around native review capabilities to ease code sharing and testability.
It also introduces business logic to quickly configure conditions and state tracking to prompt for reviews at the right moment.

To be replaced by the actual pub.dev tags once merged.
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE) ![Version]() ![Downloads]()

## Before Getting Started

Before getting started, please read the [Android](https://developer.android.com/guide/playcore/in-app-review) and [iOS](https://developer.apple.com/design/human-interface-guidelines/ratings-and-reviews) application review documentation.

## Getting Started

1. Add the `review_service` package to your project.

2. Create an instance of `ReviewService`. We'll cover dependency injection in details later on in this documentation.
   ```dart
   var reviewConditionsBuilder = ReviewConditionsBuilderImplementation
      .empty()
      .minimumPrimaryActionsCompleted(1);

   var reviewPrompter = LoggingReviewPrompter();
   var reviewSettingsSource = MemoryReviewSettingsSource<ReviewSettings>(() => const ReviewSettings());

   var reviewService = ReviewService<ReviewSettings>(
      logger: Logger(),
      reviewPrompter: reviewPrompter,
      reviewSettingsSource: reviewSettingsSource,
      reviewConditionsBuilder: reviewConditionsBuilder);

   ```

3. Use the service.
   - Update the review settings based on application events.
      ```dart
      late ReviewService<ReviewSettings> _reviewService;

      Future<void> doPrimaryAction() async {
         // Do Primary Action.

         // Track this action.
         await _reviewService.trackPrimaryActionCompleted();
      }

      ```
   - Use the service to request review.
      ```dart
      late ReviewService<ReviewSettings> _reviewService;

      Future<void> onCompletedImportantFlow() async {
      // Do Meaningful Task.

      // Check if all conditions are satisfied and prompt for review if they are.
      await _reviewService.tryRequestReview();
      }
      ```

## Next Steps

### Persisting Review Settings

`MemoryReviewSettingsSource` is great for automated testing but should not be the implementation of choice for real use-cases. Instead, you should create your own implementation that persists data on the device (so that review settings don't reset when you kill the app).

```dart
/// Storage implementation of <see cref="ReviewSettingsSource{TReviewSettings}"/>.
sealed class StorageReviewSettingsSource<ReviewSettings> extends ReviewSettings
    implements ReviewSettingsSource<ReviewSettings> {
  @override
  Future<ReviewSettings> read() {
    // TODO: Return stored review settings.
    return Future.value(ReviewSettings());
  }

  @override
  Future<void> write(ReviewSettings reviewSettings) {
    // TODO: Update stored review settings.
    return Future.value();
  }
}
```

### Using Dependency Injection

Here is a simple code that does dependency injection using `get_it`.

```dart
   GetIt getIt = GetIt.instance;

   // Register the ReviewPrompter implementation with GetIt
   getIt.registerSingleton<ReviewPrompter>(ReviewPrompter());
```

## Features

Now that everything is setup, Let's see what else we can do!

### Track Application Events

To track the provided review settings you can use the following `ReviewService` extensions.
> 💡 The review request count and the last review request are automatically tracked by the service.

TODO: Change the github links to the dart package once merged 
- [TrackApplicationLaunched](https://github.com/nventive/ReviewService/blob/a78e37c7e9b6fbe07ba1fec5d0f2b3b2f31bf356/src/ReviewService.Abstractions/ReviewService.Extensions.cs#L20) : Tracks that the application was launched (Also tracks if it's the first launch).
- [TrackPrimaryActionCompleted](https://github.com/nventive/ReviewService/blob/a78e37c7e9b6fbe07ba1fec5d0f2b3b2f31bf356/src/ReviewService.Abstractions/ReviewService.Extensions.cs#L45) : Tracks that a primary action was completed.
- [TrackSecondaryActionCompleted](https://github.com/nventive/ReviewService/blob/a78e37c7e9b6fbe07ba1fec5d0f2b3b2f31bf356/src/ReviewService.Abstractions/ReviewService.Extensions.cs#L61) : Tracks that a secondary action was completed.

#### Built-in Tracking Data
TODO: Change the github links to the dart package once merged
- [PrimaryActionCompletedCount](https://github.com/nventive/ReviewService/blob/1484f946c60e2bf1cb86b27faa60c148a1e56d45/src/ReviewService.Abstractions/ReviewSettings.cs#L13) : The number of primary actions completed.
- [SecondaryActionCompletedCount](https://github.com/nventive/ReviewService/blob/1484f946c60e2bf1cb86b27faa60c148a1e56d45/src/ReviewService.Abstractions/ReviewSettings.cs#L18) : The number of secondary actions completed.
- [ApplicationLaunchCount](https://github.com/nventive/ReviewService/blob/1484f946c60e2bf1cb86b27faa60c148a1e56d45/src/ReviewService.Abstractions/ReviewSettings.cs#L23) : The number of times the application has been launched.
- [FirstApplicationLaunch](https://github.com/nventive/ReviewService/blob/1484f946c60e2bf1cb86b27faa60c148a1e56d45/src/ReviewService.Abstractions/ReviewSettings.cs#L28) : When the application first started.
- [RequestCount](https://github.com/nventive/ReviewService/blob/1484f946c60e2bf1cb86b27faa60c148a1e56d45/src/ReviewService.Abstractions/ReviewSettings.cs#L33) : The number of review requested.
- [LastRequest](https://github.com/nventive/ReviewService/blob/1484f946c60e2bf1cb86b27faa60c148a1e56d45/src/ReviewService.Abstractions/ReviewSettings.cs#L38) : When the last review was requested.

### Configure Conditions

If you want to use our default review conditions, you can use `ReviewConditionsBuilder.defaultBuilder()` and pass it to the `ReviewService` constructor, or register it as a transient dependency when using dependency injection. Please note that our review conditions are also generic, so they can be used with custom review settings too.

The `ReviewConditionsBuilder.Default()` extension method uses the following conditions.
- **3** application launches required.
- **2** completed primary actions.
- **5** days since the first application launch.
- **15** days since the last review request.

#### Built-in Conditions
TODO: Change the github links to the dart package once merged
- [MinimumPrimaryActionsCompleted](https://github.com/nventive/ReviewService/blob/a78e37c7e9b6fbe07ba1fec5d0f2b3b2f31bf356/src/ReviewService.Abstractions/ReviewConditionsBuilder.Extensions.cs#L17) : Make sure that it prompts for review only if the number of completed primary actions meets the minimum.
- [MinimumSecondaryActionsCompleted](https://github.com/nventive/ReviewService/blob/a78e37c7e9b6fbe07ba1fec5d0f2b3b2f31bf356/src/ReviewService.Abstractions/ReviewConditionsBuilder.Extensions.cs#L33) : Make sure that it prompts for review only if the number of completed secondary actions meets the minimum.
- [MinimumApplicationLaunchCount](https://github.com/nventive/ReviewService/blob/a78e37c7e9b6fbe07ba1fec5d0f2b3b2f31bf356/src/ReviewService.Abstractions/ReviewConditionsBuilder.Extensions.cs#L49) : Make sure that it prompts for review only if the number of times the application has been launched meets the required minimum.
- [MinimumElapsedTimeSinceApplicationFirstLaunch](https://github.com/nventive/ReviewService/blob/a78e37c7e9b6fbe07ba1fec5d0f2b3b2f31bf356/src/ReviewService.Abstractions/ReviewConditionsBuilder.Extensions.cs#L65) : Make sure that it prompts for review only if the elapsed time since the first application launch meets the required minimum.
- [MinimumElapsedTimeSinceLastReviewRequest](https://github.com/nventive/ReviewService/blob/1484f946c60e2bf1cb86b27faa60c148a1e56d45/src/ReviewService.Abstractions/ReviewConditionsBuilder.Extensions.cs#L83) : Make sure that it prompts for review only if the elapsed time since the last review request meets the required minimum.
- [Custom](https://github.com/nventive/ReviewService/blob/1484f946c60e2bf1cb86b27faa60c148a1e56d45/src/ReviewService.Abstractions/ReviewConditionsBuilder.Extensions.cs#L99) : Custom condition made with a synchronous lambda function.
- [CustomAsync](https://github.com/nventive/ReviewService/blob/1484f946c60e2bf1cb86b27faa60c148a1e56d45/src/ReviewService.Abstractions/ReviewConditionsBuilder.Extensions.cs#L113) : Custom asynchronous condition made with an asynchronous lambda function.

### Add Custom Conditions

To create custom review conditions, you have to use `ReviewConditionsBuilder.custom` and `ReviewConditionsBuilder.customAsync` and provide them with a function directly instead of a condition. Also you can create extensions for `ReviewConditionsBuilder` and add a new condition to the builder. To create a review condition, you can use both `SynchronousReviewCondition` and `AsynchronousReviewCondition` you need to provide them with a function.

```dart
/// Extensions for ReviewConditionsBuilder<TReviewSettings>.
extension ReviewConditionsBuilderExtensions
    on ReviewConditionsBuilder<ReviewSettingsCustom> {
  /// The application onboarding must be completed.
  ReviewConditionsBuilder applicationOnboardingCompleted(
      ReviewConditionsBuilder builder) {
    builder.conditions.add(SynchronousReviewCondition<ReviewSettingsCustom>((reviewSettings, currentDateTime) => reviewSettings.hasCompletedOnboarding == true));
    return builder;
  }
}
```

Here is a simple code that uses the builder extensions for review conditions.

 ```dart
   var reviewConditionsBuilder = ReviewConditionsBuilder.empty()
      .minimumPrimaryActionsCompleted(1)
      .minimumSecondaryActionsCompleted(1)
      .minimumApplicationLaunchCount(1)
      .minimumElapsedTimeSinceApplicationFirstLaunch(Duration(days: 1))
      .custom((reviewSettings, currentDateTime) {
   return reviewSettings.primaryActionCompletedCount +
            reviewSettings.secondaryActionCompletedCount >=
         2;
   });

```

It's possible to customize the review conditions used by the service by using `ReviewConditionsBuilder` and passing it to the `ReviewService` constructor or by injecting it as a transient when using dependency injection.

```dart
var reviewConditionsBuilder =
    ReviewConditionsBuilder.empty<ReviewSettingsCustom>()
        .minimumPrimaryActionsCompleted(3)
        .minimumApplicationLaunchCount(3)
        .minimumElapsedTimeSinceApplicationFirstLaunch(Duration(days: 5))
        .custom((reviewSettings, currentDateTime) {
  return reviewSettings.primaryActionCompletedCount +
          reviewSettings.secondaryActionCompletedCount >=
      2;
});

```

### Add Custom Tracking Data

First let's declare a new `ReviewSettings` named `CustomReviewSettings` with a `favoriteJokesCount` to track how many jokes were favorited in an hypothetical dad jokes application

```dart 
  class CustomReviewSettings extends ReviewSettings {
    final int favoriteJokesCount;

    const CustomReviewSettings({
      this.favoriteJokesCount = 0,
      super.primaryActionCompletedCount = 0,
      super.secondaryActionCompletedCount = 0,
      super.applicationLaunchCount = 0,
      super.firstApplicationLaunch,
      super.requestCount = 0,
      super.lastRequest,
    });

    @override
    CustomReviewSettings copyWith({
      int? primaryActionCompletedCount,
      int? secondaryActionCompletedCount,
      int? applicationLaunchCount,
      DateTime? firstApplicationLaunch,
      int? requestCount,
      DateTime? lastRequest,
    }) {
      return CustomReviewSettings(
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
        favoriteJokesCount: favoriteJokesCount,
      );
    }

    CustomReviewSettings copyWithFavorite(int favoriteCount) {
      return CustomReviewSettings(
        primaryActionCompletedCount: super.primaryActionCompletedCount,
        secondaryActionCompletedCount: super.secondaryActionCompletedCount,
        applicationLaunchCount: super.applicationLaunchCount,
        firstApplicationLaunch: super.firstApplicationLaunch,
        requestCount: super.requestCount,
        lastRequest: super.lastRequest,
        favoriteJokesCount: favoriteCount,
      );
    }
  }
```

> ⚠ Notes : 
> 1. It's important you define a `copyWith` that overrides the one from the `ReviewSettings` class while returning the newly added property. This ensures that the calls made to the `copyWith` method of `ReviewSettings` will be overriden by your implementation
> 2. You need to define a `copyWith` method that returns the superclass `ReviewSettings` value along with your new property passed as a parameter. This method will be used when you will track your review settings further down the line. 

Once you've defined your new custom review settings, it is recommended to add an extension to the `ReviewConditionsBuilder` for uniformity :

```dart
  extension CustomReviewConditionsBuilderExtensions
      on ReviewConditionsBuilder<CustomReviewSettings> {
    ReviewConditionsBuilder<CustomReviewSettings> minimumJokesFavorited(
      int minimumJokesFavorited,
    ) {
      conditions.add(
        SynchronousReviewCondition<CustomReviewSettings>(
          (reviewSettings, currentDateTime) =>
              reviewSettings.favoriteJokesCount >= minimumJokesFavorited,
        ),
      );
      return this;
    }
  }
```

> ⚠ Notes :
> You need to specify that the `ReviewConditionsBuilder` takes your new  `CustomReviewSettings` and not the default `ReviewSettings` since you want to use your newly added property. 

Then you need to register your service with the extended `ReviewConditionsBuilder` and the new review settings like this :
```dart
  var logger = Logger();
  var reviewConditionsBuilder =
      ReviewConditionsBuilderImplementation<CustomReviewSettings>()
          .minimumJokesFavorited(3);

  var reviewSettingsSource =
    GetIt.I.registerSingleton<ReviewSettingsSource<CustomReviewSettings>>(
      MemoryReviewSettingsSource<CustomReviewSettings>(
        () => const CustomReviewSettings(),
      ),
    );

  GetIt.I.registerSingleton(
    ReviewService<CustomReviewSettings>(
      logger: logger,
      reviewPrompter: ReviewPrompter(logger: logger),
      reviewSettingsSource: reviewSettingsSource,
      reviewConditionsBuilder: reviewConditionsBuilder,
    ),
  );
```

> ⚠ Notes :
> 1. You need to specify again that you want the conditions builder the settings source and the service to use your `CustomReviewSettings` and not the generic.  
> 2. We recommend that you define your own interface that wraps `ReviewService<CustomReviewSettings>` to make the usage code leaner and ease any potential refactorings.

  ```dart
    /// This interface wraps ReviewService<CustomReviewSettings> so that you don't have to repeat the generic parameter everywhere that you would use the review service.
    /// In other words, you should use this interface in the app instead of ReviewService<CustomReviewSettings> because it's leaner.
    class CustomReviewService implements ReviewService<CustomReviewSettings> {
      late ReviewService<CustomReviewSettings> _reviewService;

      CustomReviewService(ReviewService<CustomReviewSettings> reviewService) {
        _reviewService = reviewService;
      }

      @override
      Future<bool> getAreConditionsSatisfied() async {
        return await _reviewService.getAreConditionsSatisfied();
      }

      @override
      Future<void> tryRequestReview() async {
        await _reviewService.tryRequestReview();
      }

      @override
      Future<void> updateReviewSettings(
        CustomReviewSettings Function(CustomReviewSettings p1) updateFunction,
      ) async {
        await _reviewService.updateReviewSettings(updateFunction);
      }
    }
  ```

After creating your own implementation of the ReviewService you just need to register it like this :
```dart
  GetIt.I.registerSingleton(
    CustomReviewService(
      ReviewService<CustomReviewSettings>(
        logger: logger,
        reviewPrompter: ReviewPrompter(logger: logger),
        reviewSettingsSource: reviewSettingsSource,
        reviewConditionsBuilder: reviewConditionsBuilder,
      ),
    ),
  );
```

And use it like that :
```dart
  await GetIt.I.get<CustomReviewService>().trackFavoriteJokesCount();
```

Now you're all set to track how many jokes are favorited in your app and prompt for a review once your review conditions are meant (3 favorite jokes in this case).

## Testing

This is what you need to know before testing and debugging this service. Please note that this may change and you should always refer to the [Apple](https://developer.apple.com/documentation/storekit/skstorereviewcontroller/3566727-requestreview#4278434) and [Android](https://developer.android.com/guide/playcore/in-app-review/test) documentation for the most up-to-date information.

### Android

- You can't test this service while debugging the application, the prompt won't show up. To test it, you need to use the [internal application sharing](https://play.google.com/console/about/internalappsharing/) or the internal testing feature in Google Play Console. See [this](https://developer.android.com/guide/playcore/in-app-review/test) for more details.
- You can't use a Google Suite account on Google Play to review an application because the prompt will not show up.

### iOS

- You can test on a real device or on a simulator.
- You can test this service only while debugging the application (It won't show up on TestFlight).

## Acknowledgements

Take a look at [in_app_review](https://github.com/britannio/in_app_review) that we use to prompt for review.

## Breaking Changes

Please consult [BREAKING_CHANGES.md](BREAKING_CHANGES.md) for more information about version
history and compatibility.

## License

This project is licensed under the Apache 2.0 license - see the
[LICENSE](LICENSE) file for details.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on the process for
contributing to this project.

Be mindful of our [Code of Conduct](CODE_OF_CONDUCT.md).