import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:review_service/src/review_service/memory_review_settings_source.dart';
import 'package:review_service/src/review_service/review_condition_builder.dart';
import 'package:review_service/src/review_service/review_prompter.dart';
import 'package:review_service/src/review_service/review_service.dart';
import 'package:review_service/src/review_service/review_settings.dart';

import 'review_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ReviewPrompter>()])
void main() {
  /// We need this because we are using maxInteger in the test cases.
  const int maxInteger =  0x7FFFFFFFFFFFFFFF;

  late MockReviewPrompter reviewPrompterMock;

  var testCases = [
    {
      'reviewSettings': ReviewSettings(),
      'areConditionsSatisfied': false,
    },
    {
      'reviewSettings':  ReviewSettings(
        firstApplicationLaunch: DateTime.fromMillisecondsSinceEpoch(0),
        applicationLaunchCount: maxInteger,
        primaryActionCompletedCount: maxInteger,
        requestCount: 1,
        lastRequest: DateTime.now(),
      ),
      'areConditionsSatisfied': false,
    },
    {
      'reviewSettings': ReviewSettings(
        firstApplicationLaunch: DateTime.fromMillisecondsSinceEpoch(0),
        applicationLaunchCount: maxInteger,
        primaryActionCompletedCount: maxInteger,
      ),
      'areConditionsSatisfied': true,
    },
  ];

    setUp(() {
      reviewPrompterMock = MockReviewPrompter();

      when(reviewPrompterMock.tryPrompt()).thenAnswer((_) async {});
    });

    for (var testCase in testCases) {
      test('Prompt Review When Conditions Are Satisfied', () async {
      // Arrange.
      var reviewConditionsBuilder = ReviewConditionsBuilderImplementation.defaultBuilder();
      var reviewSettingsSource = MemoryReviewSettingsSource<ReviewSettings>(() => ReviewSettings());

      await reviewSettingsSource.write(testCase['reviewSettings'] as ReviewSettings);

      var reviewService = ReviewService<ReviewSettings>(
        logger: Logger(),
        reviewPrompter: reviewPrompterMock,
        reviewSettingsSource: reviewSettingsSource,
        reviewConditionsBuilder: reviewConditionsBuilder
      );

      // Act.
      await reviewService.tryRequestReview();

      // Assert.
      var areConditionsSatisfied = testCase['areConditionsSatisfied'] as bool;

      if (areConditionsSatisfied) {
        verify(reviewPrompterMock.tryPrompt()).called(1);
      } else {
        verifyNever(reviewPrompterMock.tryPrompt());
      }
    });
    }
    
}
