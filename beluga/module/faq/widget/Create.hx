package beluga.module.faq.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.faq.Faq;
import beluga.core.BelugaI18n;

class Create extends MttWidget<FaqImpl> {

    public function new (mttfile = "beluga_faq_create_faq.mtt") {
        super(Faq, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/faq/view/local/create/", mod.i18n);
    }

    override private function getContext() {
        var context = mod.getCreateContext();
        context.base_url = ConfigLoader.getBaseUrl();
        context.id = MttWidget.id++;
        return context;
    }
}