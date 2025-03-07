import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(PosthogPlugin)
public class PosthogPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "PosthogPlugin"
    public let jsName = "Posthog"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "alias", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "capture", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "flush", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "group", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "identify", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "register", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "reset", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "screen", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setup", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "unregister", returnType: CAPPluginReturnPromise)
    ]
    public let tag = "Posthog"
    public let errorAliasMissing = "alias must be provided."
    public let errorApiKeyMissing = "apiKey must be provided."
    public let errorDistinctIdMissing = "distinctId must be provided."
    public let errorEventMissing = "event must be provided."
    public let errorKeyMissing = "key must be provided."
    public let errorScreenTitleMissing = "screenTitle must be provided."
    public let errorTypeMissing = "type must be provided."
    public let errorValueMissing = "value must be provided."
    private var implementation: Posthog?

    override public func load() {
        self.implementation = Posthog(plugin: self)
    }

    @objc func alias(_ call: CAPPluginCall) {
        guard let alias = call.getString("alias") else {
            call.reject(errorAliasMissing)
            return
        }

        let options = AliasOptions(alias: alias)

        implementation?.alias(options)
        call.resolve()
    }

    @objc func capture(_ call: CAPPluginCall) {
        guard let event = call.getString("event") else {
            call.reject(errorEventMissing)
            return
        }
        let properties = call.getObject("properties")

        let options = CaptureOptions(event: event, properties: properties)

        implementation?.capture(options)
        call.resolve()
    }

    @objc func flush(_ call: CAPPluginCall) {
        implementation?.flush()
        call.resolve()
    }

    @objc func group(_ call: CAPPluginCall) {
        guard let type = call.getString("type") else {
            call.reject(errorTypeMissing)
            return
        }
        guard let key = call.getString("key") else {
            call.reject(errorKeyMissing)
            return
        }
        let groupProperties = call.getObject("groupProperties")

        let options = GroupOptions(type: type, key: key, groupProperties: groupProperties)

        implementation?.group(options)
        call.resolve()
    }

    @objc func identify(_ call: CAPPluginCall) {
        guard let distinctId = call.getString("distinctId") else {
            call.reject(errorDistinctIdMissing)
            return
        }
        let userProperties = call.getObject("userProperties")

        let options = IdentifyOptions(distinctId: distinctId, userProperties: userProperties)

        implementation?.identify(options)
        call.resolve()
    }

    @objc func register(_ call: CAPPluginCall) {
        guard let key = call.getString("key") else {
            call.reject(errorKeyMissing)
            return
        }
        guard let value = call.getObject("value") as AnyObject? else {
            call.reject(errorValueMissing)
            return
        }

        let options = RegisterOptions(key: key, value: value)

        implementation?.register(options)
        call.resolve()
    }

    @objc func reset(_ call: CAPPluginCall) {
        implementation?.reset()
        call.resolve()
    }

    @objc func screen(_ call: CAPPluginCall) {
        guard let screenTitle = call.getString("screenTitle") else {
            call.reject(errorScreenTitleMissing)
            return
        }
        let properties = call.getObject("properties")

        let options = ScreenOptions(screenTitle: screenTitle, properties: properties)

        implementation?.screen(options)
        call.resolve()
    }

    @objc func setup(_ call: CAPPluginCall) {
        guard let apiKey = call.getString("apiKey") else {
            call.reject(errorApiKeyMissing)
            return
        }
        let host = call.getString("host", "https://us.i.posthog.com")

        let options = SetupOptions(apiKey: apiKey, host: host)

        implementation?.setup(options)
        call.resolve()
    }

    @objc func unregister(_ call: CAPPluginCall) {
        guard let key = call.getString("key") else {
            call.reject(errorKeyMissing)
            return
        }

        let options = UnregisterOptions(key: key)

        implementation?.unregister(options)
        call.resolve()
    }
}
