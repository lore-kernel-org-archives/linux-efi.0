From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/8] efi: add support for non-standard capsule headers
Date: Tue, 18 Apr 2017 17:23:42 +0100
Message-ID: <CAKv+Gu9b7ELU4RtcojrSwCmZg8p-oqXzmdTSVqzAhma1Rg+jQQ@mail.gmail.com>
References: <20170405092317.27921-1-ard.biesheuvel@linaro.org> <f417e914-7b95-9886-fb8f-bca79d5456a3@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f417e914-7b95-9886-fb8f-bca79d5456a3-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 April 2017 at 17:26, Bryan O'Donoghue
<pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org> wrote:
>
>
> On 05/04/17 10:23, Ard Biesheuvel wrote:
>>
>> This is a followup to Jan's series [0] to add support for the non-standard
>> and awkward capsule header layout that is used by the Quark platform.
>>
>> While we would prefer to adhere to the standard rigorously, the reality
>> (and common practice) in Linux is that we sometimes have to deal with
>> quirks. So while Jan's aim is to get Quark to work, the reason for my
>> involvement is to try and accommodate this in a flexible way without
>> putting any handling specific to this quirk in the common code.
>
>
> Hi Ard, Jan.
>
> I've run this series on my Galileo Gen2 and it appears to work well.
>
> Please take my;
>
> Tested-by: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
>

Thanks Bryan,

I take it this is a board that is affected by the quirk?
