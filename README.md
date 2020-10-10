# Vragen SDK
The easiest way to ask your users a few questions.

![Example screenshot of a question](/Resources/Screenshot.png)

## Installation
### Swift Package Manager
Add the following as a dependency to your `Package.swift`.
```swift
.package(url: "https://github.com/MartinMetselaar/vragen-sdk.git", from: "1.0.0"),
```

## Usage
The [vragen-api](https://github.com/MartinMetselaar/vragen-api) contains a way to retrieve a survey and submit answers. 

### Setup
We first need to let the SDK know what the server of your [vragen-api](https://github.com/MartinMetselaar/vragen-api) is and the token. This could for example be done in the [application(_:didFinishLaunchingWithOptions:)](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622921-application) or [scene(_:willConnectTo:options:)](https://developer.apple.com/documentation/uikit/uiscenedelegate/3197914-scene).

```swift
let server = URL(string: "https://vragenapi.example.org")!
let token = "customer-token-from-your-server"

VragenSDK.set(server: server, token: token)
```
**NOTE:** This token should be the `CONSUMER_TOKEN`. You should not publish (by using) your `ADMIN_TOKEN` because people could use it to edit and download your data.

The next step is to present the `SurveyViewController` which displays the survey.

```swift
let surveyId = UUID(uuidString: "your-uuid-survey-identifier")!
let userId = "user19302"
let controller = SurveyViewController(identifier: surveyId, userId: userId)
present(controller, animated: true, completion: nil)
```
**NOTE:** The `userId` parameter in `SurveyViewController` is optional. If you provide the userId you can connect multiple surveys from the same user together. If you only care about the answers and want the users to stay anonymous a `nil` provided userId will generate a new `UUID` for every time the user will answer a survey. Even when it is done twice.

You are done.

## Custom interface
Want to create your own visual interface? You can use the [vragen-sdk-network](https://github.com/MartinMetselaar/vragen-sdk-network) to implement your own interface.
