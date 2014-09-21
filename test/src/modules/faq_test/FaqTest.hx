package modules.faq_test;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.module.account.model.User;
import beluga.module.account.Account;
import beluga.module.faq.Faq;
import beluga.module.faq.model.FaqModel;
import beluga.module.faq.model.CategoryModel;
import beluga.module.faq.CategoryData;
import haxe.web.Dispatch;
import haxe.Resource;
import main_view.Renderer;
import sys.db.Types;

#if php
import php.Web;
#end

class FaqTest {
    public var beluga(default, null) : Beluga;
    public var faq(default, null) : Faq;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.faq = beluga.getModuleInstance(Faq);

        this.faq.triggers.defaultPage.add(this.doDefault);
        this.faq.triggers.createCategorySuccess.add(this.print);
        this.faq.triggers.createCategoryFail.add(this.redirectCreateCategory);
        this.faq.triggers.deleteCategorySuccess.add(this.print);
        this.faq.triggers.deleteCategoryFail.add(this.print);
        this.faq.triggers.editCategorySuccess.add(this.print);
        this.faq.triggers.editCategoryFail.add(this.print);
        this.faq.triggers.createSuccess.add(this.print);
        this.faq.triggers.createFail.add(this.redirectCreateFAQ);
        this.faq.triggers.deleteSuccess.add(this.print);
        this.faq.triggers.deleteFail.add(this.print);
        this.faq.triggers.editSuccess.add(this.print);
        this.faq.triggers.editFail.add(this.print);
        this.faq.triggers.redirectCreateFAQ.add(this.redirectCreateFAQ);
        this.faq.triggers.redirectCreateCategory.add(this.redirectCreateCategory);
        this.faq.triggers.print.add(this.print);
        this.faq.triggers.redirectEditCategory.add(this.redirectEditCategory);
        this.faq.triggers.redirectEditFAQ.add(this.redirectEditFAQ);
    }

    public function doDefault() {
        print();
    }

    public function print() {
        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: faq.widgets.print.render()
        });
        Sys.print(html);
    }

    public function redirectCreateCategory() {
        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: faq.widgets.create_category.render()
        });
        Sys.print(html);
    }

    public function redirectCreateFAQ() {
        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: faq.widgets.create.render()
        });
        Sys.print(html);
    }

    public function redirectEditCategory() {
        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: faq.widgets.edit_category.render()
        });
        Sys.print(html);
    }

    public function redirectEditFAQ() {
        if (!faq.redirectEditFAQ())
            print();
        else {
            var html = Renderer.renderDefault("page_faq", "FAQ", {
                faqWidget: faq.widgets.edit_faq.render()
            });
            Sys.print(html);
        }
    }
}