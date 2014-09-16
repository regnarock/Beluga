package beluga.module.market.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.market.Market;

class Display extends MttWidget {
    var mod : Market;

    public function new (mttfile = "beluga_market_display.mtt") {
        super(mttfile);
        mod = Beluga.getInstance().getModuleInstance(Market);
    }

    override private function getContext() {
        var context = mod.getDisplayContext();
        context.base_url = ConfigLoader.getBaseUrl();
        context.id = MttWidget.id++;
        return context;
    }
}