From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 5/7] efi/capsule: Prepare for loading images with
 security header
Date: Tue, 28 Mar 2017 17:13:15 +0200
Message-ID: <a3d4da19-015d-0559-f837-550631f1d491@siemens.com>
References: <cover.1490376860.git.jan.kiszka@siemens.com>
 <47e87c8eccc0ee5c4033ece037c0bffc32782876.1490376860.git.jan.kiszka@siemens.com>
 <CAKv+Gu_+SVNr-g+BR1dGsSn_QGY9fA-TepQ2k6rHmW74VanPFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_+SVNr-g+BR1dGsSn_QGY9fA-TepQ2k6rHmW74VanPFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2017-03-28 15:49, Ard Biesheuvel wrote:
> On 24 March 2017 at 17:34, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
>> The Quark security header is nicely located in front of the capsule
>> image, but we still need to pass the image to the update service as if
>> there was none. Prepare efi_capsule_update and its user for this by
>> defining and evaluating a EFI header displacement in the image located
>> in memory. For standard-conforming capsules, this displacement is 0.
>>
>> Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
> 
> Hello Jan,
> 
> Thanks for taking the time to respin this.
> 
> I played around with these patches a bit (I can't really test them
> since I don't have the hardware), and I am not really happy with the
> non-trivial changes to the generic code, only to allow a header
> displacement.
> 
> So instead, I attempted to come up with an alternative which does not
> use a displacement field, but makes the core capsule routines work
> with a copy of the capsule header rather than mandating that it exists
> at the start of the buffer. This way, we can override the code that
> performs the copy, and make it originate from somewhere else.
> 
> Could you please have a look at
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=quark-capsule
> 
> and tell me if that would work for you? I will send them out for
> proper review in any case, but to avoid confusion (if I missed
> something obvious), I don't want to send them out just yet.

There is more needed to make things work again, maybe around passing the
right image size. I'm looking into this.

Another observation: Making EFI_CAPSULE_QUIRK_QUARK_CSH select
EFI_CAPSULE_LOADER technically resolves the problem that the platform
code would otherwise need something from a capsule loader module.
However, a logical configuration would rather make the quirk depend on
the loader, wouldn't it? But I'm fine with both.

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux
