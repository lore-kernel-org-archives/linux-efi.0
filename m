From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v6 1/3] x86/boot: Add acpitb.c to parse acpi tables
Date: Tue, 11 Sep 2018 15:52:16 +0800
Message-ID: <20180911075215.GD8519@localhost.localdomain>
References: <20180910124015.18073-1-fanc.fnst@cn.fujitsu.com>
 <20180910124015.18073-2-fanc.fnst@cn.fujitsu.com>
 <CAJZ5v0gep7Q4w+yOvgfOUG8rU12tYEw3qtDKCoZN2=b8-=-fjw@mail.gmail.com>
 <20180911012754.GC8519@localhost.localdomain>
 <CAJZ5v0i5UcV3mngTNdGyefobDOKVOGcSG3Tuz=7-PhQWjyyhmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJZ5v0i5UcV3mngTNdGyefobDOKVOGcSG3Tuz=7-PhQWjyyhmA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, bhe@redhat.com, indou.takao@jp.fujitsu.com, Cao jin <caoj.fnst@cn.fujitsu.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, ACPI Devel Maling List <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 11, 2018 at 09:41:36AM +0200, Rafael J. Wysocki wrote:
>On Tue, Sep 11, 2018 at 3:28 AM Chao Fan <fanc.fnst@cn.fujitsu.com> wrote:
>>
>> On Mon, Sep 10, 2018 at 10:13:49PM +0200, Rafael J. Wysocki wrote:
>> >On Mon, Sep 10, 2018 at 2:41 PM Chao Fan <fanc.fnst@cn.fujitsu.com> wrote:
>> >>
>> >> Imitate the ACPI code of parsing ACPI tables to dig and read ACPI
>> >> tables.
>> >
>> >Why?
>>
>> Sorry for that, I have sent the cover letter to you.
>
>Thanks, but please add the explanation here too.

OK, I will add more.

>
>> >
>> >> Since some operations are not needed here,
>> >
>> >What operations?
>>
>> Such as some operations related to the map between physical address
>> and virtual address. Here in compressed period, use physical address
>> directely.
>
>This information also needs to go into the changelog of the patch.

Sorry for that.

>
>> >
>> >> functions are simplified. Functions will be used to dig SRAT tables to get
>> >> information of memory, so that KASLR can the memory in immovable node.
>> >
>> >So do you want to parse SRAT only or do something in addition to that?
>>
>> Only read and get memory information, won't change SRAT.
>> So ACPI code will not be changed.
>
>I meant whether or not SRAT is the only table you need to look into.
>If so, that also needs to be said in the patch changelog.

Yes, you are right, here only SRAT table is needed.

Thanks,
Chao Fan

>
>Thanks,
>Rafael
>
>
