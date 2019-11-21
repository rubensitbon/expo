package abi35_0_0.host.exp.exponent.modules.api.components.helpshift;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import abi35_0_0.com.facebook.react.ReactPackage;
import abi35_0_0.com.facebook.react.bridge.NativeModule;
import abi35_0_0.com.facebook.react.bridge.ReactApplicationContext;
import abi35_0_0.com.facebook.react.uimanager.ViewManager;
import abi35_0_0.com.facebook.react.bridge.JavaScriptModule;
public class RNHelpshiftPackage implements ReactPackage {
    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
      return Arrays.<NativeModule>asList(new RNHelpshiftModule(reactContext));
    }

    // Deprecated from RN 0.47
    public List<Class<? extends JavaScriptModule>> createJSModules() {
      return Collections.emptyList();
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Arrays.<ViewManager>asList(
                new RNHelpshiftView()
        );
    }
}