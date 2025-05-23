import Foundation

public struct SupportFormArea: Identifiable, Equatable, ExpressibleByStringLiteral {
    let title: String

    public init(title: String) {
        self.title = title
    }

    public init(stringLiteral value: StringLiteralType) {
        self.title = value
    }

    public var id: String {
        self.title
    }
}

public struct SupportFormTag: Identifiable {
    public let key: String
    public let value: String

    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }

    public var id: String {
        key
    }
}

/// View Model for the support form.
///
@MainActor
public final class SupportFormViewModel: ObservableObject {

    /// Variable that holds the area of support for better routing.
    ///
    @Published var area: SupportFormArea?

    /// Variable that holds the subject of the ticket.
    ///
    @Published var subject = ""

    /// Variable that holds the siteAddress of the ticket.
    ///
    @Published var siteAddress = ""

    /// Variable that holds the description of the ticket.
    ///
    @Published var description = ""

    /// Determines if the loading indicator should be visible or not.
    ///
    @Published var showLoadingIndicator = false

    /// Provides the data rendered in the form
    ///
    let dataProvider: SupportFormDataProvider

    /// Publishes events this form can generate
    ///
    private let delegate: SupportFormDelegate

    /// Defines when the submit button should be enabled or not.
    ///
    var submitButtonDisabled: Bool {
        area == nil || subject.isEmpty || siteAddress.isEmpty || description.isEmpty
    }

    @Published var contactName: String = ""
    @Published var contactEmailAddress: String = ""
    @Published var shouldShowIdentityInput = false
    @Published var shouldShowErrorAlert = false
    @Published var shouldShowSuccessAlert = false

    private var error: Error?

    public init(
        dataProvider: SupportFormDataProvider,
        delegate: SupportFormDelegate
    ) {
        self.dataProvider = dataProvider
        self.delegate = delegate
    }

    /// Tracks when the support form is viewed.
    ///
    func onViewAppear() {
        delegate.userDid(.viewSupportForm)
    }

    /// Selects an area.
    ///
    func selectArea(_ area: SupportFormArea) {
        self.area = area
    }

    /// Determines if the given area is selected.
    ///
    func isAreaSelected(_ area: SupportFormArea) -> Bool {
        self.area == area
    }

    /// Submits the support request using the Zendesk Provider.
    ///
    func submitSupportRequest() {
        guard let area else { return }

        showLoadingIndicator = true

        Task {
            try await delegate.supportFormSubmitted()
        }

//        zendeskProvider.createSupportRequest(formID: area.datasource.formID,
//                                             customFields: area.datasource.customFields(siteAddress: siteAddress),
//                                             tags: assembleTags(),
//                                             subject: subject,
//                                             description: description) { [weak self] result in
//            guard let self else { return }
//            self.showLoadingIndicator = false
//
//            // Analytics
//            switch result {
//            case .success:
//                self.analyticsProvider.track(.supportNewRequestCreated)
//                self.shouldShowSuccessAlert = true
//            case .failure(let error):
//                self.analyticsProvider.track(.supportNewRequestFailed)
//                self.error = error
//                self.shouldShowErrorAlert = true
//            }
//        }
    }
}
