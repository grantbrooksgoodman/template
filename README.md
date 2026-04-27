# Template

A structured iOS app template built on the [AppSubsystem](https://github.com/grantbrooksgoodman/app-subsystem) framework.

Template provides a preconfigured project with navigation, localization, theming, logging, and dependency injection built in. Replace the included sample content with your own features to start building your app.

---

## Table of Contents

- [Overview](#overview)
- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [App Lifecycle](#app-lifecycle)
- [Delegate Configuration](#delegate-configuration)
- [Key Concepts](#key-concepts)
    - [Navigation](#navigation)
    - [Localization](#localization)
    - [Theming](#theming)
    - [Logging](#logging)
- [Additional Extension Points](#additional-extension-points)
    - [Cache Domains](#cache-domains)
    - [Developer Mode Actions](#developer-mode-actions)
    - [Exception Catalog](#exception-catalog)
    - [Observables](#observables)
    - [Root Sheet](#root-sheet)
    - [Runtime Storage](#runtime-storage)
    - [User Defaults](#user-defaults)

---

## Overview

Template demonstrates the conventions and architecture of an AppSubsystem-based iOS app. The project is organized into three top-level source directories:

- [**Bundle**](Sources/Bundle) – App-level configuration: delegate conformances, theme definitions, localized string keys, and navigator implementations.
- [**Navigation**](Sources/Navigation) – The root navigation coordinator, navigation state, and the app's root SwiftUI view.
- [**Modules**](Sources/Modules) – Feature content, organized by module. Sample views and reducers are included as reference implementations.

The template includes a complete sample feature flow – splash screen, content pages, and detail views – that demonstrates every major subsystem capability. These files serve as working examples of the patterns described below. Remove or replace them when you begin building your own app.

---

## Requirements

| Platform | Minimum Version |
| --- | --- |
| iOS | 17.0 |

---

## Getting Started

1. Clone or duplicate this repository.
2. Open `Template.xcworkspace` in Xcode.
3. Update the build metadata in [`Application`](Sources/Application.swift) – set `appStoreBuildNumber`, `buildMilestone`, `codeName`, and `finalName` to match your app's release cycle.
4. Replace the sample content in `Sources/Modules/Content/Sample` with your own feature modules.
5. Update [`RootNavigatorState`](Sources/Navigation/RootNavigator.swift) to define the top-level destinations for your app.
6. Build and run.

---

## Project Structure

```
Sources/
├── Application.swift               # Bootstrap configuration
├── Bundle/
│   ├── Delegates/
│   │   ├── AppDelegate.swift        # App entry point
│   │   └── SceneDelegate.swift      # Window scene lifecycle
│   ├── Navigators/
│   │   └── SampleContentNavigator.swift  # Reference child navigator
│   ├── Themes/
│   │   ├── CustomColors.swift            # Theme color extensions
│   │   └── UIThemes.swift                # Custom theme definitions
│   ├── CacheDomains.swift                # App-specific cache domains
│   ├── DevModeActions.swift              # Developer Mode menu actions
│   ├── ExceptionCatalog.swift            # Error codes and reporting
│   ├── LocalizedStringKeys.swift         # Pre-localized string keys
│   ├── LoggerDomains.swift               # Logger domain subscriptions
│   ├── Observables.swift                 # Reactive value declarations
│   ├── RootSheet.swift                   # Root-level sheet definitions
│   ├── StoredItemKeys.swift              # In-memory storage keys
│   ├── TranslatedLabelStringCollection.swift  # On-the-fly translation strings
│   └── UserDefaultsKeys.swift            # Permanent UserDefaults keys
├── Navigation/
│   ├── NavigationCoordinatorDependency.swift  # Coordinator dependency key
│   ├── RootNavigationService.swift       # Top-level route dispatch
│   ├── RootNavigator.swift               # Root navigation state and routing
│   └── RootView.swift                    # Root SwiftUI view
├── Modules/
│   └── Content/
│       ├── Sample/                  # Replace with your features
│       └── Shared/                  # Shared views (e.g., splash screen)
└── Resources/
    ├── Audio/
    ├── Images/
    ├── Other/
    └── Property Lists/
        ├── Info.plist
        └── LocalizedStrings.plist
```

---

## App Lifecycle

The app launches through a standard UIKit scene-based lifecycle:

1. [`AppDelegate`](Sources/Bundle/Delegates/AppDelegate.swift) receives `application(_:didFinishLaunchingWithOptions:)` and calls `Application.initialize()`.
2. [`Application`](Sources/Application.swift) registers all delegates with the subsystem, then calls `AppSubsystem.initialize(...)` to configure build metadata and enable framework services. This call may only occur once per launch.
3. [`SceneDelegate`](Sources/Bundle/Delegates/SceneDelegate.swift) receives `scene(_:willConnectTo:options:)` and creates the root window by calling `RootWindowScene.instantiate(_:rootView:)` with [`RootView`](Sources/Navigation/RootView.swift) as its content.
4. [`RootView`](Sources/Navigation/RootView.swift) observes the navigation coordinator and renders the appropriate top-level screen based on the current navigation state.

---

## Delegate Configuration

AppSubsystem uses a delegate pattern to let apps customize framework behavior without subclassing. Each delegate conforms to a protocol declared by AppSubsystem and is registered during initialization in [`Application`](Sources/Application.swift).

The template provides conformances for every delegate slot. Most start empty – add your values as your app requires them:

| Delegate | Purpose |
| --- | --- |
| [`CacheDomainListDelegate`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Foundation/Protocols/Public/Delegates/CacheDomainListDelegate.swift) | Registers app-specific cache domains for memory-pressure cleanup. |
| [`DevModeAppActionDelegate`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Developer%20Mode/Protocols/DevModeAppActionDelegate.swift) | Adds actions to the Developer Mode menu in pre-release builds. |
| [`ExceptionMetadataDelegate`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Foundation/Protocols/Public/Delegates/ExceptionMetadataDelegate.swift) | Controls which exceptions are reportable and provides user-facing error descriptions. |
| [`LoggerDomainSubscriptionDelegate`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Foundation/Protocols/Public/Delegates/LoggerDomainSubscriptionDelegate.swift) | Configures which logger domains produce output and which are excluded from the session record. |
| [`PermanentUserDefaultsKeyDelegate`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Foundation/Protocols/Public/Delegates/PermanentUserDefaultsKeyDelegate.swift) | Declares `UserDefaults` keys that survive a reset. |
| [`UIThemeListDelegate`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Foundation/Protocols/Public/Delegates/UIThemeListDelegate.swift) | Registers custom UI themes alongside the subsystem's built-in themes. |

Pass `nil` for any delegate your app does not need. Delegates that are not registered fall back to the subsystem's default behavior.

---

## Key Concepts

### Navigation

The template uses AppSubsystem's coordinator-based navigation system. Navigation state is centralized in a single [`NavigationCoordinator`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Navigation/Services/NavigationCoordinator.swift) that owns typed state and dispatches routes through a [`Navigating`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Navigation/Protocols/NavigatingProtocol.swift)-conforming service.

#### Key Types

- [`RootNavigationService`](Sources/Navigation/RootNavigationService.swift) – The top-level [`Navigating`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Navigation/Protocols/NavigatingProtocol.swift) conformance. Defines the complete set of `Route` cases and delegates each to the appropriate navigator.
- [`RootNavigatorState`](Sources/Navigation/RootNavigator.swift) – The root [`NavigatorState`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Navigation/Protocols/NavigatorStateProtocol.swift). Tracks three presentation channels (stack, sheet, modal) and holds nested state for each child navigation flow.
- [`RootNavigator`](Sources/Navigation/RootNavigator.swift) – Applies root-level routes to `RootNavigatorState`.
- [`NavigationCoordinatorDependency`](Sources/Navigation/NavigationCoordinatorDependency.swift) – The [`DependencyKey`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Dependency%20Injection/Protocols/DependencyKey.swift) that lazily creates and stores the coordinator. Access it through the `\.navigation` key path.
- [`RootView`](Sources/Navigation/RootView.swift) – The root SwiftUI view. Observes the coordinator and switches between top-level destinations based on the current modal state.

#### Accessing the Coordinator

Use the [`@Dependency`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Dependency%20Injection/Models/Dependency.swift) or [`@ObservedDependency`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Dependency%20Injection/Models/ObservedDependency.swift) property wrappers to access the navigation coordinator:

```swift
// In a SwiftUI view:
@ObservedDependency(\.navigation) private var navigation: Navigation

// In a reducer or service:
@Dependency(\.navigation) private var navigation: Navigation
```

Dispatch routes by calling `navigate(to:)` on the coordinator:

```swift
navigation.navigate(to: .root(.modal(.home)))
```

#### Adding a Feature Flow

To introduce a new feature flow:

1. Create a [`NavigatorState`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Navigation/Protocols/NavigatorStateProtocol.swift) struct with [`Paths`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Navigation/Protocols/NavigatorStateProtocol.swift)-conforming enums for each presentation channel the flow uses. See [`SampleContentNavigator`](Sources/Bundle/Navigators/SampleContentNavigator.swift) for a reference implementation.
2. Create a navigator enum with a static `navigate(to:on:)` method.
3. Add a route enum as a nested type on `RootNavigationService.Route`.
4. Add a case to `RootNavigationService.Route` and delegate to your navigator inside `navigate(to:on:)`.
5. Add a nested `NavigatorState` property to [`RootNavigatorState`](Sources/Navigation/RootNavigator.swift).

---

### Localization

The template supports two complementary localization mechanisms:

#### Pre-Localized Strings

[`LocalizedStringKey`](Sources/Bundle/LocalizedStringKeys.swift) defines the app's localization keys. Each case maps to a top-level key in the app's localized strings property list – the camel case case name is converted to snake case, so `helloWorld` resolves to the property list key `hello_world`.

A constrained extension on [`Localized`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Localization/Models/Public/Localized.swift) provides a convenience initializer that defaults to `.app()` as the source. This reads from a property list in the main bundle named `LocalizedStrings` by default – the template includes one at [`LocalizedStrings.plist`](Sources/Resources/Property%20Lists/LocalizedStrings.plist). You can supply a different [`LocalizationSource`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Localization/Models/Public/LocalizationSource.swift) to control the bundle and property list name the subsystem resolves strings from.

```swift
@Localized(.helloWorld) var greeting: String
```

To add a new pre-localized string, add a case to `LocalizedStringKey` and a corresponding entry to the property list with translations for each supported language. AppSubsystem's [`Localization`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Localization/Services/Public/Localization.swift) enum provides a development-time utility for populating a localized strings property list.

The app's property list is separate from AppSubsystem's. To resolve a key from the subsystem's built-in strings – such as "Cancel" or "Done" – add a case whose `referent` matches a subsystem key and pass `.subsystem` as the source. For the full list of subsystem-provided keys, see [`SubsystemStringKey`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Localization/Models/Internal/SubsystemStringKey.swift) in [AppSubsystem](https://github.com/grantbrooksgoodman/app-subsystem).

#### On-the-Fly Translation

For strings that are translated at runtime, define a [`TranslatedLabelStringKey`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Foundation/Protocols/Public/TranslatedLabelStrings.swift)-conforming enum for each view and expose it through [`TranslatedLabelStringCollection`](Sources/Bundle/TranslatedLabelStringCollection.swift):

```swift
static func settingsView(
    _ key: SettingsViewStringKey
) -> TranslatedLabelStringCollection {
    .init(key.rawValue)
}
```

---

### Theming

The template integrates AppSubsystem's dynamic theming system. Themes map semantic color slots ([`ColoredItemType`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Theming/Models/ColoredItemType.swift)) to concrete colors, and the active theme can be changed at runtime.

Define custom themes in [`UIThemes`](Sources/Bundle/Themes/UIThemes.swift):

```swift
extension UITheme {
    static let ocean: UITheme = .init(
        name: "Ocean",
        items: [
            .init(.accent, set: .init(.systemTeal)),
        ]
    )
}
```

To use theme colors in your views, define semantic color slots, `UIColor` accessors, and SwiftUI `Color` accessors in [`CustomColors`](Sources/Bundle/Themes/CustomColors.swift):

```swift
extension ColoredItemType {
    static let cardBackground: ColoredItemType = .init("cardBackground")
}

extension UIColor {
    static var cardBackground: UIColor {
        ThemeService.currentTheme.color(for: .cardBackground)
    }
}

extension Color {
    static var cardBackground: Color { .init(uiColor: .cardBackground) }
}
```

---

### Logging

Configure logger subscriptions in [`LoggerDomains`](Sources/Bundle/LoggerDomains.swift). Only messages logged to a subscribed domain produce output. Define app-specific domains as static properties on [`LoggerDomain`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Foundation/Models/Public/Key%20Domains/LoggerDomain.swift):

```swift
extension LoggerDomain {
    static let networking: LoggerDomain = .init("networking")
}
```

Add the domain to the `subscribedDomains` array so the logger receives its output. Optionally, add domains to `domainsExcludedFromSessionRecord` to exclude their messages from the on-disk session log while continuing to display them in the console.

---

## Additional Extension Points

### Cache Domains

[`CacheDomains`](Sources/Bundle/CacheDomains.swift) registers app-specific cache domains. Each domain represents an independent cache that can be cleared programmatically or during memory-pressure cleanup. Define a [`CacheDomain`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Foundation/Models/Public/Key%20Domains/CacheDomain.swift) with a name and a closure that clears the cache, then add it to the `appCacheDomains` array.

### Developer Mode Actions

[`DevModeActions`](Sources/Bundle/DevModeActions.swift) defines actions that appear in the Developer Mode action sheet. These are available only in pre-release builds. Define [`DevModeAction`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Developer%20Mode/Models/Public/DevModeAction.swift) instances and include them in the `appActions` array.

### Exception Catalog

[`ExceptionCatalog`](Sources/Bundle/ExceptionCatalog.swift) catalogs app-specific error codes and configures exception reporting behavior. Define known error codes as static [`AppException`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Foundation/Models/Public/Key%20Domains/AppException.swift) properties. Customize the [`ExceptionMetadataDelegate`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Foundation/Protocols/Public/Delegates/ExceptionMetadataDelegate.swift) to control which errors are reportable and to supply user-facing descriptions for known error conditions.

### Observables

[`Observables`](Sources/Bundle/Observables.swift) declares app-specific [`Observable`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Observable/Models/Observable.swift) values for reactive cross-scope communication. Use a typed observable to share a changing value, or [`Observable<Nil>`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Observable/Models/Observable.swift) to broadcast an event with no payload. Conform to the [`Observer`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Observable/Protocols/ObserverProtocol.swift) protocol to receive updates.

### Root Sheet

[`RootSheet`](Sources/Bundle/RootSheet.swift) defines views for presentation on the root sheet, which presents content above all other views in the hierarchy regardless of navigation depth. Define named sheets as static properties and present them using `RootSheets.present(_:onDismiss:)`.

### Runtime Storage

[`StoredItemKeys`](Sources/Bundle/StoredItemKeys.swift) defines keys for [`RuntimeStorage`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Foundation/Services/Public/RuntimeStorage.swift), a thread-safe in-memory key-value store. Values persist only for the lifetime of the current launch and are not written to disk. Define keys as static [`StoredItemKey`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Foundation/Models/Public/Key%20Domains/StoredItemKey.swift) properties and add typed convenience accessors on [`RuntimeStorage`](https://github.com/grantbrooksgoodman/app-subsystem/blob/main/Sources/Modules/Foundation/Services/Public/RuntimeStorage.swift).

### User Defaults

[`UserDefaultsKeys`](Sources/Bundle/UserDefaultsKeys.swift) declares which `UserDefaults` keys should survive a reset. Register keys as permanent when they store critical app state – such as authentication tokens or installation identifiers – that must be preserved when the user or subsystem resets `UserDefaults`.

---

© NEOTechnica Corporation. All rights reserved.
