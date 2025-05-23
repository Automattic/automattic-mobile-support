import Foundation
import SwiftUI

public struct SupportForm: View {

    /// Main ViewModel to drive the view.
    ///
    @StateObject
    var viewModel: SupportFormViewModel

    public init(viewModel: SupportFormViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: .zero) {

            // Scrollable Form
            ScrollView {
                VStack(alignment: .leading, spacing: Layout.sectionSpacing) {

                    Text(viewModel.dataProvider.areasTitle)
                        .padding([.horizontal, .top])

                    areaPicker

                    // Info Section
                    VStack(alignment: .leading, spacing: Layout.subSectionsSpacing) {
                        Text(Localization.letsGetItSorted)
                        Text(Localization.tellUsInfo)
                    }

                    // Subject Text Field
                    VStack(alignment: .leading, spacing: Layout.subSectionsSpacing) {
                        Text(Localization.subject)
//                            .foregroundColor(Color(.gray))

                        TextField("", text: $viewModel.subject)
                            .padding(Layout.subjectInsets)
//                            .background(Color(.gray))
                            .overlay(
                                RoundedRectangle(cornerRadius: Layout.cornerRadius).stroke(Color(.separator))
                            )
                            .cornerRadius(Layout.cornerRadius)
                    }

                    // Site Address Text Field
                    VStack(alignment: .leading, spacing: Layout.subSectionsSpacing) {
                        Text(Localization.siteAddress)
//                            .foregroundColor(Color(.text))
//                            .subheadlineStyle()

                        TextField("", text: $viewModel.siteAddress)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.URL)
//                            .bodyStyle()
                            .padding(Layout.subjectInsets)
//                            .background(Color(.listForeground(modal: false)))
                            .overlay(
                                RoundedRectangle(cornerRadius: Layout.cornerRadius).stroke(Color(.separator))
                            )
                            .cornerRadius(Layout.cornerRadius)
                    }

                    // Description Text Editor
                    VStack(alignment: .leading, spacing: Layout.subSectionsSpacing) {
                        Text(Localization.message)
//                            .foregroundColor(Color(.text))
//                            .subheadlineStyle()

                        TextEditor(text: $viewModel.description)
//                            .bodyStyle()
                            .frame(minHeight: Layout.minimuEditorSize)
                            .overlay(
                                RoundedRectangle(cornerRadius: Layout.cornerRadius).stroke(Color(.separator))
                            )
                            .cornerRadius(Layout.cornerRadius)
                    }
                }
                .padding()
            }

            // Submit Request Footer
            VStack() {
                Divider()

                Button {
                    viewModel.submitSupportRequest()
                } label: {
                    Text(Localization.submitRequest)
                }
                .buttonStyle(PrimaryLoadingButtonStyle(isLoading: viewModel.showLoadingIndicator))
                .disabled(viewModel.submitButtonDisabled)
                .padding()
            }
//            .background(Color(.listForeground(modal: false)))
        }
//        .background(Color(.listBackground))
        .navigationTitle(Localization.title)
        .navigationBarTitleDisplayMode(.inline)
//        .wooNavigationBarStyle()
        .onAppear {
            viewModel.onViewAppear()
        }
//        .alert(viewModel.errorMessage, isPresented: $viewModel.shouldShowErrorAlert) {
//            Button(Localization.gotIt) {
//                viewModel.shouldShowErrorAlert = false
//            }
//        }
//        .alert(Localization.supportRequestSent, isPresented: $viewModel.shouldShowSuccessAlert) {
//            Button(Localization.gotIt) {
//                viewModel.shouldShowSuccessAlert = false
//                isPresented = false
//                onDismiss?()
//            }
//        } message: {
//            Text(Localization.supportRequestSentMessage)
//        }
//        .alert(Localization.IdentityInput.title, isPresented: $viewModel.shouldShowIdentityInput) {
//            TextField(Localization.IdentityInput.email, text: $viewModel.contactEmailAddress)
//            TextField(Localization.IdentityInput.name, text: $viewModel.contactName)
//            Button(Localization.IdentityInput.cancel) {
//                isPresented = false
//                onDismiss?()
//            }
//            Button(Localization.IdentityInput.ok) {
//                Task {
////                    await viewModel.submitIdentityInfo()
//                }
//            }
////            .disabled(viewModel.identitySubmitButtonDisabled)
//        }
    }

    @ViewBuilder
    var areaPicker: some View {
        // Area List
        VStack(alignment: .leading, spacing: .zero) {
            ForEach(viewModel.dataProvider.areas, id: \.id) { area in
                HStack(alignment: .center, spacing: Layout.radioButtonSpacing) {
                    // Radio-Button emulation
                    Circle()
                        .stroke(Color(.separator), lineWidth: Layout.radioButtonBorderWidth)
                        .frame(width: Layout.radioButtonSize, height: Layout.radioButtonSize)
                        .background(
                            // Use a clear color for non-selected radio buttons.
                            Circle()
                                .fill( viewModel.isAreaSelected(area) ? Color(.blue) : .clear)
                                .padding(Layout.radioButtonBorderWidth)
                        )

                    Text(area.title)
//                                    .headlineStyle()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading) // Needed to make tap area the whole width
//                .background(Color(.listForeground(modal: false)))
                .onTapGesture {
                    viewModel.selectArea(area)
                }

                Divider()
                    .padding(.leading)
                   // .renderedIf(index < viewModel.areas.count - 1) // Don't render the last divider
            }
        }
        .cornerRadius(Layout.cornerRadius)
        .padding(.bottom)
    }
}

// MARK: Constants
private extension SupportForm {
    enum Localization {
        static let title = NSLocalizedString("Contact Support", comment: "Title of the view for contacting support.")
        static let iNeedHelp = NSLocalizedString("I need help with", comment: "Text on the support form to refer to what area the user has problem with.")
        static let letsGetItSorted = NSLocalizedString("Let’s get this sorted", comment: "Title to let the user know what do we want on the support screen.")
        static let tellUsInfo = NSLocalizedString(["Let us know your site address (URL) and tell us as much as you can about the problem,",
                                                  " and we will be in touch soon."].joined(),
                                                  comment: "Message info on the support screen.")
        static let subject = NSLocalizedString("Subject", comment: "Subject title on the support form")
        static let siteAddress = NSLocalizedString("Site Address", comment: "Site Address title on the support form")
        static let message = NSLocalizedString("Message", comment: "Message on the support form")
        static let submitRequest = NSLocalizedString("Submit Support Request", comment: "Button title to submit a support request.")

        static let supportRequestSent = NSLocalizedString(
            "supportForm.supportRequestSent",
            value: "Request Sent!",
            comment: "Title for the alert after the support request is created."
        )
        static let supportRequestSentMessage = NSLocalizedString(
            "supportForm.supportRequestSentMessage",
            value: "Your support request has landed safely in our inbox. We will reply via email as quickly as we can.",
            comment: "Message for the alert after the support request is created."
        )
        static let gotIt = NSLocalizedString(
            "supportForm.gotIt",
            value: "Got It",
            comment: "Button to dismiss the alert when a support request."
        )
        enum IdentityInput {
            static let title = NSLocalizedString(
                "supportForm.identityInput.title",
                value: "Please enter your email address and user name",
                comment: "Title of the input alert for identity info to be used in the support form"
            )
            static let email = NSLocalizedString(
                "supportForm.identityInput.email",
                value: "Email",
                comment: "Placeholder of the email field on the input alert for identity info to be used in the support form"
            )
            static let name = NSLocalizedString(
                "supportForm.identityInput.name",
                value: "Name",
                comment: "Placeholder of the name field on the input alert for identity info to be used in the support form"
            )
            static let cancel = NSLocalizedString(
                "supportForm.identityInput.cancel",
                value: "Cancel",
                comment: "Button to dismiss the input alert for identity info to be used in the support form"
            )
            static let ok = NSLocalizedString(
                "supportForm.identityInput.ok",
                value: "OK",
                comment: "Button to submit details on the input alert for identity info to be used in the support form"
            )
        }
    }

    enum Layout {
        static let sectionSpacing: CGFloat = 16
        static let radioButtonSpacing: CGFloat = 12
        static let radioButtonBorderWidth: CGFloat = 2
        static let radioButtonSize: CGFloat = 20
        static let subSectionsSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 8
        static let subjectInsets = EdgeInsets(top: 8, leading: 5, bottom: 8, trailing: 5)
        static let minimuEditorSize: CGFloat = 300
    }
}

// MARK: Previews
struct SupportFormProvider: PreviewProvider {

    let delegate = MockSupportFormDelegate()

    static var previews: some View {
        NavigationView {
            SupportForm(viewModel: SupportFormViewModel(
                dataProvider: MockSupportFormDataProvider(),
                delegate: MockSupportFormDelegate()
            ))
        }
    }
}

struct MockSupportFormDataProvider: SupportFormDataProvider {
    var areas: [SupportFormArea] {
        [
            "Application",
            "Jetpack Connection"
        ]
    }
}

actor MockSupportFormDelegate: SupportFormDelegate {
    nonisolated func userDid(_ action: SupportFormAction) {
        debugPrint(action)
    }
    
    func supportFormSubmitted() async throws {
        debugPrint("Form submitted")
    }
}

/// Adds a primary button style while showing a progress view or checkmark on top of the button when required.
///
struct PrimaryLoadingButtonStyle: PrimitiveButtonStyle {
    /// Set to show a progress view or checkmark within the button.
    ///
    enum State {
        case loading
        case success
        case idle
    }

    var state: State = .idle

    init(isLoading: Bool) {
        if isLoading {
            state = .loading
        } else {
            state = .idle
        }
    }

    init(state: State) {
        self.state = state
    }

    /// Returns a `ProgressView` if the view is loading. Return nil otherwise
    ///
    private var progressViewOverlay: ProgressView<EmptyView, EmptyView>? {
        state == .loading ? ProgressView() : nil
    }

    private var checkmark: some View {
        state == .success ? Image(systemName: "checkmark.circle").font(.title2).foregroundStyle(Color(.white)) : nil
    }

    func makeBody(configuration: Configuration) -> some View {
        /// Only send trigger if the view is not loading.
        ///
        return Button(configuration)
//            .buttonStyle(PrimaryButtonStyle(hideContent: state != .idle))
            .onTapGesture { dispatchTrigger(configuration) }
            .disabled(state != .idle)
            .overlay(progressViewOverlay)
            .overlay(checkmark)
    }

    /// Only dispatch events while the view is not loading.
    ///
    private func dispatchTrigger(_ configuration: Configuration) {
        guard state == .idle else { return }
        configuration.trigger()
    }
}
