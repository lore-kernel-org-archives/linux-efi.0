From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 8/8] efi/capsule: Add support for Quark security header
Date: Tue, 18 Apr 2017 20:11:14 +0200
Message-ID: <b2198322-b8fd-683e-fd8a-85398fc53986@siemens.com>
References: <20170405092317.27921-1-ard.biesheuvel@linaro.org>
 <20170405092317.27921-9-ard.biesheuvel@linaro.org>
 <20170418124853.GH24360@codeblueprint.co.uk>
 <CAHp75VdqSim86_B=h9vu6veT3t8T8FAdOBfGDov-W9B5GNENwg@mail.gmail.com>
 <4daca591-8937-8256-d7f5-a1075ad7714a@siemens.com>
 <20170418134426.GK24360@codeblueprint.co.uk>
 <CAKv+Gu_wM-TaZn9jgOW4yCwyjh4cTbszOagKmJdrAdov+3GCsQ@mail.gmail.com>
 <CAKv+Gu-uXd30gcUvi_9dErj2bzvTpwVzGR7yiZMgm1KcQHz0dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-uXd30gcUvi_9dErj2bzvTpwVzGR7yiZMgm1KcQHz0dw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2017-04-18 19:10, Ard Biesheuvel wrote:
> On 18 April 2017 at 14:46, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> On 18 April 2017 at 14:44, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>>> On Tue, 18 Apr, at 02:59:43PM, Jan Kiszka wrote:
>>>>
>>>> I've implemented this, but for the old design, and Ard took over then.
>>>> So it never made it to the list.
>>>>
>>>> Whatever layout of these bits is preferred, it can probably be done. I
>>>> just need an indication that there is (likely) a consensus.
>>>
>>> Post what you already have on top of Ard's series and we'll review it.
>>
>> For the record, other than the change Matt suggested (to take the
>> Quirk handling out of the normal flow), I don't think there is a need
>> to add a lot of parametrization just to implement this single quirk.
>> IMO it can wait for the next one.
> 
> OK, I have pushed patches 1 - 5 to efi/next branch, and the entire
> series (with Matt's review feedback regarding #6 and #7 incorporated)
> to my own branch here
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=quark-capsule
> 
> Jan, would you mind taking over again, i.e, update patch #8 and repost
> patches #6, #7 and #8 after retesting? (just remove my S-o-b from #8
> after you've reworked it)

Sure, I'll pick them up ASAP.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux
