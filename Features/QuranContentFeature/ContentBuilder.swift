//
//  ContentBuilder.swift
//  Quran
//
//  Created by Afifi, Mohamed on 9/1/19.
//  Copyright © 2019 Quran.com. All rights reserved.
//

import AnnotationsService
import AppDependencies
import QuranImageFeature
import QuranTranslationFeature
import ReadingService
import UIKit

@MainActor
public struct ContentBuilder {
    // MARK: Lifecycle

    public init(container: AppDependencies, highlightsService: QuranHighlightsService) {
        self.container = container
        self.highlightsService = highlightsService
    }

    // MARK: Public

    public func build(withListener listener: ContentListener, input: QuranInput) -> (ContentViewController, ContentViewModel) {
        let quran = ReadingPreferences.shared.reading.quran
        let noteService = container.noteService()
        let lastPageService = LastPageService(persistence: container.lastPagePersistence)
        let lastPageUpdater = LastPageUpdater(service: lastPageService)
        let interactorDeps = ContentViewModel.Deps(
            analytics: container.analytics,
            noteService: noteService,
            lastPageUpdater: lastPageUpdater,
            quran: quran,
            highlightsService: highlightsService,
            imageDataSourceBuilder: ContentImageBuilder(container: container, highlightsService: highlightsService),
            translationDataSourceBuilder: ContentTranslationBuilder(container: container, highlightsService: highlightsService)
        )
        let viewModel = ContentViewModel(deps: interactorDeps, input: input)

        let viewController = ContentViewController(viewModel: viewModel)

        viewModel.listener = listener
        return (viewController, viewModel)
    }

    // MARK: Private

    private let container: AppDependencies
    private let highlightsService: QuranHighlightsService
}
