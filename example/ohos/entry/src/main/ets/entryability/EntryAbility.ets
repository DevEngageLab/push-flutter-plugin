import { FlutterAbility, FlutterEngine, Log } from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import FlutterPluginEngagelabPlugin from 'flutter_plugin_engagelab';

const TAG: string = 'EngageLab-Push-flutter-EntryAbility'

export default class EntryAbility extends FlutterAbility {
  configureFlutterEngine(flutterEngine: FlutterEngine) {
    Log.i(TAG, 'configureFlutterEngine')
    super.configureFlutterEngine(flutterEngine)
    GeneratedPluginRegistrant.registerWith(flutterEngine)
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    Log.i(TAG, 'onCreate :' + JSON.stringify(want))
    FlutterPluginEngagelabPlugin.setClickWant(want, this.context)
    return super.onCreate(want, launchParam)
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    Log.i(TAG, 'onNewWant :' + JSON.stringify(want));
    FlutterPluginEngagelabPlugin.setClickWant(want, this.context)
    super.onNewWant(want, launchParams)
  }
}
