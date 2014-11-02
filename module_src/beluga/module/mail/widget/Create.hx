package beluga.module.mail.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.mail.Mail;
import beluga.module.account.Account;
import beluga.resource.ResourceManager;

class Create extends MttWidget<Mail> {

    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/beluga/module/mail/view/tpl/sendMail.mtt");
        super(Mail, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/mail/view/locale/create/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            return mod.widgets.mail.render();
        }
        return {
            mails : mod.getSentMails(),
            user : Beluga.getInstance().getModuleInstance(Account).loggedUser,
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            path : "/beluga/mail/",
            receiver : mod.receiver,
            subject : mod.subject,
            message : mod.message
        }
    }
}