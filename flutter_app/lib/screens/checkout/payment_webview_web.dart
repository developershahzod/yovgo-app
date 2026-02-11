import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

void registerIframe(String viewId, String url, Function onLoaded) {
  ui_web.platformViewRegistry.registerViewFactory(
    viewId,
    (int id) {
      final iframe = html.IFrameElement()
        ..src = url
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'payment'
        ..setAttribute('allowfullscreen', 'true');

      iframe.onLoad.listen((_) {
        onLoaded();
      });

      return iframe;
    },
  );
}
